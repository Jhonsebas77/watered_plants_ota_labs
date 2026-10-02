// ignore_for_file: avoid_print
part of com.watered_plants_ota_labs.app.providers;

class FirebaseProvider extends ChangeNotifier {
  FirebaseProvider({NotificationService? notificationService})
    : _notificationService = notificationService ?? NotificationService();
  final DatabaseReference _firebaseRef = FirebaseDatabase.instance.ref();
  final NotificationService _notificationService;
  SettingsProvider? _settingsProvider;
  bool isLoading = false;
  List<PlantModel> allPlants = <PlantModel>[];
  List<DeadPlantModel> deadPlants = <DeadPlantModel>[];

  @override
  void dispose() {
    _settingsProvider?.removeListener(_handleSettingsChanged);
    super.dispose();
  }

  void updateSettings(SettingsProvider settingsProvider) {
    _settingsProvider?.removeListener(_handleSettingsChanged);
    _settingsProvider = settingsProvider;
    _settingsProvider?.addListener(_handleSettingsChanged);
    _handleSettingsChanged();
  }

  void initializeFirebase() {
    FirebaseApp firebaseApp = Firebase.app();
    FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: databaseURL);
  }

  Future<void> getPlantsData() async {
    isLoading = true;
    notifyListeners();
    DataSnapshot snapshot = await _firebaseRef.child(firebaseOriginPath).get();
    allPlants = <PlantModel>[];
    deadPlants = <DeadPlantModel>[];
    if (snapshot.exists && snapshot.value != null) {
      if (snapshot.value is Map) {
        try {
          Map<String, dynamic> typedData = Map<String, dynamic>.from(
            // ignore: cast_nullable_to_non_nullable, always_specify_types
            snapshot.value as Map,
          );
          if (typedData['plants'] is Map) {
            Map<String, dynamic>.from(
              // ignore: cast_nullable_to_non_nullable, always_specify_types
              typedData['plants'] as Map,
            ).forEach((String id, dynamic plant) {
              if (plant is Map) {
                plant['uuid'] = id;
                if (plant['last_watered_date'] == toYYYYMMdd(DateTime.now())) {
                  plant['just_watered'] = true;
                } else {
                  plant['just_watered'] = false;
                }
                Map<String, dynamic> _plantMap = Map<String, dynamic>.from(
                  plant,
                );
                PlantModel _plantModel = PlantModel.fromJSON(_plantMap);
                allPlants.add(_plantModel);
              }
            });
          }
          if (typedData['cemetery'] is Map) {
            Map<String, dynamic>.from(
              // ignore: cast_nullable_to_non_nullable, always_specify_types
              typedData['cemetery'] as Map,
            ).forEach((String id, dynamic plant) {
              if (plant is Map) {
                Map<String, dynamic> _plantMap = Map<String, dynamic>.from(
                  plant,
                )..['uuid'] = id;
                deadPlants.add(DeadPlantModel.fromJSON(_plantMap));
              }
            });
          }
        } catch (e) {
          print('Error during data conversion to Map<String, dynamic>: $e');
        }
      } else {
        print(
          '''Snapshot value is not a Map. Actual type: ${snapshot.value.runtimeType}''',
        );
        print('Snapshot value: ${snapshot.value}');
      }
    } else {
      print('No data available at this path, or snapshot.value is null.');
    }
    isLoading = false;
    notifyListeners();
    await _syncNotifications();
  }

  Future<void> addPlant(PlantModel _plantModel) async {
    try {
      String customId = generateUUID();
      DatabaseReference ref = FirebaseDatabase.instance.ref(
        '$firebasePlantsPath$customId',
      );
      await ref.update(_plantModel.toJSON());
      print('[Plant added] -> $customId');
    } catch (e) {
      print('Error during addPlant: $e');
    }
    notifyListeners();
  }

  Future<void> updatePlant(String customId, PlantModel _plantModel) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref(
        '$firebasePlantsPath$customId',
      );
      await ref.update(_plantModel.toJSON());
    } catch (e) {
      print('Error during updatePlant: $customId | $e');
    }
    notifyListeners();
  }

  Future<void> getOnePlant(String customId) async {
    isLoading = true;
    notifyListeners();
    DataSnapshot snapshot = await _firebaseRef
        .child('$firebasePlantsPath$customId')
        .get();
    if (snapshot.exists && snapshot.value != null) {
      if (snapshot.value is Map) {
        try {
          Map<String, dynamic> plant = Map<String, dynamic>.from(
            // ignore: cast_nullable_to_non_nullable, always_specify_types
            snapshot.value as Map,
          );
          Map<String, dynamic> _plantMap = Map<String, dynamic>.from(plant);
          PlantModel _plantModel = PlantModel.fromJSON(_plantMap);
          int index = allPlants.indexWhere(
            (PlantModel plant) => plant.uuid == customId,
          );
          allPlants[index] = _plantModel;
        } catch (e) {
          print('Error during data conversion to Map<String, dynamic>: $e');
        }
      } else {
        print(
          '''Snapshot value is not a Map. Actual type: ${snapshot.value.runtimeType}''',
        );
        print('Snapshot value: ${snapshot.value}');
      }
    } else {
      print('No data available at this path, or snapshot.value is null.');
    }
    isLoading = false;
    notifyListeners();
    await _syncNotifications();
  }

  /// Mueve la planta al cementerio: se guarda en `cemetery/` con la fecha de
  /// eliminación y se borra de `plants/` en un solo update atómico.
  Future<bool> deletePlant(PlantModel plant) async {
    String? customId = plant.uuid;
    if (customId == null || customId.isEmpty) {
      return false;
    }
    DeadPlantModel deadPlant = DeadPlantModel(
      plant: plant,
      deathDate: toYYYYMMdd(DateTime.now()),
    );
    try {
      await FirebaseDatabase.instance.ref(firebaseOriginPath).update(
        <String, dynamic>{
          'plants/$customId': null,
          'cemetery/$customId': deadPlant.toJSON(),
        },
      );
      allPlants.removeWhere((PlantModel plant) => plant.uuid == customId);
      deadPlants.add(deadPlant);
    } catch (e) {
      print('Error during deletePlant: $customId | $e');
      return false;
    }
    notifyListeners();
    await _syncNotifications();
    return true;
  }

  /// Saca la planta del cementerio y la devuelve a `plants/`.
  Future<bool> revivePlant(DeadPlantModel deadPlant) async {
    String? customId = deadPlant.plant.uuid;
    if (customId == null || customId.isEmpty) {
      return false;
    }
    try {
      await FirebaseDatabase.instance.ref(firebaseOriginPath).update(
        <String, dynamic>{
          'cemetery/$customId': null,
          'plants/$customId': deadPlant.plant.toJSON(),
        },
      );
      deadPlants.removeWhere(
        (DeadPlantModel dead) => dead.plant.uuid == customId,
      );
      allPlants.add(deadPlant.plant);
    } catch (e) {
      print('Error during revivePlant: $customId | $e');
      return false;
    }
    notifyListeners();
    await _syncNotifications();
    return true;
  }

  /// Borra definitivamente una planta del cementerio.
  Future<bool> buryPlantForever(String customId) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref(
        '$firebaseCemeteryPath$customId',
      );
      await ref.remove();
      deadPlants.removeWhere(
        (DeadPlantModel dead) => dead.plant.uuid == customId,
      );
    } catch (e) {
      print('Error during buryPlantForever: $customId | $e');
      return false;
    }
    notifyListeners();
    return true;
  }

  Future<void> _syncNotifications() async {
    if (_settingsProvider == null || _settingsProvider?.isInitialized != true) {
      return;
    }

    await _notificationService.syncPlantNotifications(
      allPlants,
      notificationsEnabled: _settingsProvider!.notificationsEnabled,
      reminderDaysBefore: _settingsProvider!.reminderDaysBefore,
      scheduleTimes: _settingsProvider!.scheduleTimes,
    );
  }

  void _handleSettingsChanged() {
    if (isLoading) {
      return;
    }
    unawaited(_syncNotifications());
  }
}
