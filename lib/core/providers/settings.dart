part of com.watered_plants_ota_labs.app.providers;

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({NotificationService? notificationService})
    : _notificationService = notificationService ?? NotificationService() {
    _loadPreferences();
  }

  static const String _notificationsKey = 'notificationsEnabled';
  static const String _reminderDaysKey = 'reminderDaysBefore';
  static const String _scheduleKeyPrefix = 'scheduleTime';

  final NotificationService _notificationService;

  bool _notificationsEnabled = true;
  int _reminderDaysBefore = 0;
  bool _isInitialized = false;
  final Map<String, TimeOfDay> _scheduleTimes = <String, TimeOfDay>{
    'morning': const TimeOfDay(hour: 9, minute: 0),
    'afternoon': const TimeOfDay(hour: 14, minute: 0),
    'night': const TimeOfDay(hour: 19, minute: 0),
  };

  bool get notificationsEnabled => _notificationsEnabled;
  int get reminderDaysBefore => _reminderDaysBefore;
  bool get isInitialized => _isInitialized;
  Map<String, TimeOfDay> get scheduleTimes =>
      Map<String, TimeOfDay>.unmodifiable(_scheduleTimes);

  Future<void> _loadPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    _notificationsEnabled =
        preferences.getBool(_notificationsKey) ?? _notificationsEnabled;
    _reminderDaysBefore =
        preferences.getInt(_reminderDaysKey) ?? _reminderDaysBefore;

    for (String schedule in scheduleOptions) {
      String? storedTime = preferences.getString(
        '${_scheduleKeyPrefix}_$schedule',
      );
      if (storedTime != null) {
        TimeOfDay? parsed = _parseTime(storedTime);
        if (parsed != null) {
          _scheduleTimes[schedule] = parsed;
        }
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> updateNotificationsEnabled(bool value) async {
    if (_notificationsEnabled == value) {
      return;
    }

    _notificationsEnabled = value;
    notifyListeners();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_notificationsKey, value);

    if (value) {
      await _notificationService.requestPermissions();
    } else {
      await _notificationService.initialize();
      await _notificationService.syncPlantNotifications(
        const <PlantModel>[],
        notificationsEnabled: false,
        reminderDaysBefore: _reminderDaysBefore,
        scheduleTimes: _scheduleTimes,
      );
    }
  }

  Future<void> updateReminderDaysBefore(int value) async {
    if (_reminderDaysBefore == value) {
      return;
    }

    _reminderDaysBefore = value;
    notifyListeners();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_reminderDaysKey, value);
  }

  Future<void> updateScheduleTime(String schedule, TimeOfDay time) async {
    if (_scheduleTimes[schedule] == time) {
      return;
    }

    _scheduleTimes[schedule] = time;
    notifyListeners();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      '${_scheduleKeyPrefix}_$schedule',
      _formatTimeOfDay(time),
    );
  }

  TimeOfDay getScheduleTime(String schedule) =>
      _scheduleTimes[schedule] ?? const TimeOfDay(hour: 9, minute: 0);

  TimeOfDay? _parseTime(String value) {
    List<String> components = value.split(':');
    if (components.length != 2) {
      return null;
    }

    int? hour = int.tryParse(components.first);
    int? minute = int.tryParse(components.last);

    if (hour == null || minute == null) {
      return null;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTimeOfDay(TimeOfDay time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
