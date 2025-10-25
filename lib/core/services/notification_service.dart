part of com.watered_plants_ota_labs.app.services;

class NotificationService {
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final NotificationService _instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool _isTimeZoneInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _notificationsPlugin.initialize(initializationSettings);
    await _configureLocalTimeZone();

    _isInitialized = true;
  }

  Future<void> requestPermissions() async {
    AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    IOSFlutterLocalNotificationsPlugin? iosImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> syncPlantNotifications(
    List<PlantModel> plants, {
    required bool notificationsEnabled,
    required int reminderDaysBefore,
    required Map<String, TimeOfDay> scheduleTimes,
  }) async {
    await initialize();

    if (!notificationsEnabled) {
      await _notificationsPlugin.cancelAll();
      return;
    }

    await requestPermissions();
    await _notificationsPlugin.cancelAll();

    for (PlantModel plant in plants) {
      await _schedulePlantNotification(
        plant,
        reminderDaysBefore: reminderDaysBefore,
        scheduleTimes: scheduleTimes,
      );
    }
  }

  Future<void> _schedulePlantNotification(
    PlantModel plant, {
    required int reminderDaysBefore,
    required Map<String, TimeOfDay> scheduleTimes,
  }) async {
    DateTime? nextWateringDate = plant.getNextWateringDate;
    if (nextWateringDate == null) {
      return;
    }
    TimeOfDay scheduleTime =
        scheduleTimes[plant.wateringSchedule] ??
        const TimeOfDay(hour: 9, minute: 0);

    DateTime scheduledDate = DateTime(
      nextWateringDate.year,
      nextWateringDate.month,
      nextWateringDate.day,
      scheduleTime.hour,
      scheduleTime.minute,
    );

    if (reminderDaysBefore > 0) {
      scheduledDate = scheduledDate.subtract(
        Duration(days: reminderDaysBefore),
      );
    }

    if (scheduledDate.isBefore(DateTime.now())) {
      return;
    }

    tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'watering_plants_channel',
        'Recordatorios de riego',
        channelDescription:
            'Notificaciones locales para recordar el riego de tus plantas',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    int notificationId = plant.uuid?.hashCode ?? plant.plantName.hashCode;

    Future<void> schedule(AndroidScheduleMode mode) =>
        _notificationsPlugin.zonedSchedule(
          notificationId,
          'Hora de regar ${plant.plantName}',
          _buildNotificationBody(plant, reminderDaysBefore),
          tzScheduledDate,
          notificationDetails,
          androidScheduleMode: mode,
        );

    try {
      await schedule(AndroidScheduleMode.exactAllowWhileIdle);
    } on PlatformException catch (error) {
      if (error.code == 'exact_alarms_not_permitted') {
        await schedule(AndroidScheduleMode.inexactAllowWhileIdle);
        return;
      }

      rethrow;
    }
  }

  String _buildNotificationBody(PlantModel plant, int reminderDaysBefore) {
    String scheduleText =
        getWateringScheduleFromString(plant.wateringSchedule).toLowerCase();

    if (reminderDaysBefore <= 0) {
      return 'Es momento de regar tu ${plant.plantName} en la $scheduleText.';
    }

    if (reminderDaysBefore == 1) {
      return '''Mañana toca regar tu ${plant.plantName}. Prepara todo para la $scheduleText.''';
    }

    return 'Quedan $reminderDaysBefore días para regar tu ${plant.plantName}. '
        'Programado para la $scheduleText.';
  }

  Future<void> _configureLocalTimeZone() async {
    if (_isTimeZoneInitialized) {
      return;
    }

    tz.initializeTimeZones();

    try {
      String timeZoneName =
          (await FlutterTimezone.getLocalTimezone()) as String;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    _isTimeZoneInitialized = true;
  }
}
