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
        AndroidInitializationSettings('@drawable/ic_stat_watering');

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

    IOSFlutterLocalNotificationsPlugin? iosImplementation = _notificationsPlugin
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

    Map<DateTime, Map<String, List<PlantModel>>> reminders =
        <DateTime, Map<String, List<PlantModel>>>{};

    for (PlantModel plant in plants) {
      _collectPlantReminders(
        plant,
        reminders,
        reminderDaysBefore: reminderDaysBefore,
        scheduleTimes: scheduleTimes,
      );
    }

    for (MapEntry<DateTime, Map<String, List<PlantModel>>> dayEntry
        in reminders.entries) {
      for (MapEntry<String, List<PlantModel>> slotEntry
          in dayEntry.value.entries) {
        await _scheduleReminder(
          day: dayEntry.key,
          schedule: slotEntry.key,
          duePlants: slotEntry.value,
          reminderDaysBefore: reminderDaysBefore,
          scheduleTimes: scheduleTimes,
        );
      }
    }
  }

  /// Agrega las próximas ocurrencias de riego de [plant] a [reminders],
  /// agrupadas por día de notificación y jornada, de modo que se programe
  /// máximo una notificación por jornada al día.
  void _collectPlantReminders(
    PlantModel plant,
    Map<DateTime, Map<String, List<PlantModel>>> reminders, {
    required int reminderDaysBefore,
    required Map<String, TimeOfDay> scheduleTimes,
  }) {
    DateTime? nextWateringDate = plant.getNextWateringDate;
    if (nextWateringDate == null) {
      return;
    }

    // Horarios desconocidos se tratan como 'morning', igual que el resto de
    // la app (getWateringScheduleFromString); así el día queda limitado a
    // máximo una notificación por cada una de las tres jornadas.
    String schedule = scheduleOptions.contains(plant.wateringSchedule)
        ? plant.wateringSchedule
        : scheduleOptions.first;

    TimeOfDay scheduleTime =
        scheduleTimes[schedule] ?? const TimeOfDay(hour: 9, minute: 0);
    int frequencyDays = plant.wateringFrequencyDays.toInt().clamp(1, 365);
    DateTime now = DateTime.now();

    const int futureOccurrences = 10;

    DateTime notifyMoment(DateTime occurrence) {
      DateTime moment = DateTime(
        occurrence.year,
        occurrence.month,
        occurrence.day,
        scheduleTime.hour,
        scheduleTime.minute,
      );
      if (reminderDaysBefore > 0) {
        moment = moment.subtract(Duration(days: reminderDaysBefore));
      }
      return moment;
    }

    DateTime occurrence = nextWateringDate;
    DateTime moment = notifyMoment(occurrence);

    if (moment.isBefore(now)) {
      int periodsLate = now.difference(moment).inDays ~/ frequencyDays;
      occurrence = occurrence.add(Duration(days: periodsLate * frequencyDays));
      moment = notifyMoment(occurrence);
      while (moment.isBefore(now)) {
        occurrence = occurrence.add(Duration(days: frequencyDays));
        moment = notifyMoment(occurrence);
      }
    }

    for (int i = 0; i < futureOccurrences; i++) {
      DateTime day = DateTime(moment.year, moment.month, moment.day);
      reminders
          .putIfAbsent(day, () => <String, List<PlantModel>>{})
          .putIfAbsent(schedule, () => <PlantModel>[])
          .add(plant);

      occurrence = occurrence.add(Duration(days: frequencyDays));
      moment = notifyMoment(occurrence);
    }
  }

  Future<void> _scheduleReminder({
    required DateTime day,
    required String schedule,
    required List<PlantModel> duePlants,
    required int reminderDaysBefore,
    required Map<String, TimeOfDay> scheduleTimes,
  }) async {
    TimeOfDay scheduleTime =
        scheduleTimes[schedule] ?? const TimeOfDay(hour: 9, minute: 0);

    DateTime scheduledDate = DateTime(
      day.year,
      day.month,
      day.day,
      scheduleTime.hour,
      scheduleTime.minute,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'watering_plants_channel',
        'Recordatorios de riego',
        channelDescription:
            'Notificaciones locales para recordar el riego de tus plantas',
        importance: Importance.max,
        priority: Priority.high,
        // Mismo naranja que BlueprintColors.primaryContainer (lib/ui/theme);
        // no se importa para no acoplar core/services a la capa de UI.
        color: Color(0xFFFF9F30),
      ),
      iOS: DarwinNotificationDetails(),
    );

    // Un id determinístico por día y jornada: yyyymmdd * 10 + índice de
    // jornada. Garantiza máximo una notificación por jornada al día.
    int slotIndex = scheduleOptions.indexOf(schedule);
    int notificationId =
        (day.year * 10000 + day.month * 100 + day.day) * 10 +
        (slotIndex < 0 ? 9 : slotIndex);

    String title;
    String body;
    if (duePlants.length == 1) {
      PlantModel plant = duePlants.first;
      title = 'Hora de regar ${plant.plantName}';
      body = _buildNotificationBody(plant, reminderDaysBefore);
    } else {
      title = 'Hora de regar tus plantas';
      body =
          'Tienes ${duePlants.length} plantas por regar, '
          'abre la app para ver cuáles son.';
    }

    tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    Future<void> scheduleWithMode(AndroidScheduleMode mode) =>
        _notificationsPlugin.zonedSchedule(
          notificationId,
          title,
          body,
          tzScheduledDate,
          notificationDetails,
          androidScheduleMode: mode,
        );

    try {
      await scheduleWithMode(AndroidScheduleMode.exactAllowWhileIdle);
    } on PlatformException catch (error) {
      if (error.code == 'exact_alarms_not_permitted') {
        await scheduleWithMode(AndroidScheduleMode.inexactAllowWhileIdle);
        return;
      }
      rethrow;
    }
  }

  String _buildNotificationBody(PlantModel plant, int reminderDaysBefore) {
    String scheduleText = getWateringScheduleFromString(
      plant.wateringSchedule,
    ).toLowerCase();

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
      TimezoneInfo timeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZone.identifier));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    _isTimeZoneInitialized = true;
  }
}
