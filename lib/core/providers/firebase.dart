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

  /// Evita sincronizar notificaciones con una lista vacía antes de la
  /// primera carga, lo que borraría los recordatorios ya programados.
  bool _hasLoadedPlants = false;

  /// `ChangeNotifierProxyProvider` llama este método cada vez que
  /// [SettingsProvider] notifica, así que no hace falta registrar un listener
  /// adicional (eso disparaba dos sincronizaciones por cambio).
  void updateSettings(SettingsProvider settingsProvider) {
    _settingsProvider = settingsProvider;
    _handleSettingsChanged();
  }

  void initializeFirebase() {
    FirebaseApp firebaseApp = Firebase.app();
    FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: databaseURL);
  }

  /// Descarga plantas y cementerio. Con [showLoading] en `false` (p. ej.
  /// pull-to-refresh) no activa [isLoading], así la lista sigue visible en
  /// vez de cambiar al skeleton.
  Future<void> getPlantsData({bool showLoading = true}) async {
    if (showLoading) {
      isLoading = true;
      notifyListeners();
    }
    DataSnapshot snapshot;
    try {
      snapshot = await _firebaseRef.child(firebaseOriginPath).get();
    } catch (e) {
      print('Error during getPlantsData: $e');
      isLoading = false;
      notifyListeners();
      return;
    }
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
    _hasLoadedPlants = true;
    isLoading = false;
    notifyListeners();
    await _syncNotifications();
  }

  /// Crea la planta en Firebase y la agrega a la lista local, sin volver a
  /// descargar el árbol completo. Devuelve `false` si la escritura falla.
  Future<bool> addPlant(PlantModel plantModel) async {
    String customId = generateUUID();
    try {
      await FirebaseDatabase.instance
          .ref('$firebasePlantsPath$customId')
          .update(plantModel.toJSON());
    } catch (e) {
      print('Error during addPlant: $e');
      return false;
    }
    allPlants.add(_withLocalState(plantModel, customId));
    notifyListeners();
    await _syncNotifications();
    return true;
  }

  /// Actualiza la planta en Firebase y reemplaza su copia local. Devuelve
  /// `false` si la escritura falla.
  Future<bool> updatePlant(String customId, PlantModel plantModel) async {
    try {
      await FirebaseDatabase.instance
          .ref('$firebasePlantsPath$customId')
          .update(plantModel.toJSON());
    } catch (e) {
      print('Error during updatePlant: $customId | $e');
      return false;
    }
    PlantModel updated = _withLocalState(plantModel, customId);
    int index = allPlants.indexWhere(
      (PlantModel plant) => plant.uuid == customId,
    );
    if (index == -1) {
      allPlants.add(updated);
    } else {
      allPlants[index] = updated;
    }
    notifyListeners();
    await _syncNotifications();
    return true;
  }

  /// Marca la planta como regada hoy y calcula el siguiente riego según su
  /// frecuencia.
  Future<bool> waterPlant(PlantModel plant) {
    String? customId = plant.uuid;
    if (customId == null || customId.isEmpty) {
      return Future<bool>.value(false);
    }
    DateTime now = DateTime.now();
    int frequencyDays = plant.wateringFrequencyDays.toInt().clamp(1, 365);
    return updatePlant(
      customId,
      plant.copyWith(
        lastWateredDate: toYYYYMMdd(now),
        nextWateringDate: toYYYYMMdd(now.add(Duration(days: frequencyDays))),
        justWatered: true,
      ),
    );
  }

  /// Planta que [deletePlant] acaba de mandar al cementerio, para "Deshacer".
  DeadPlantModel? deadPlantById(String? customId) {
    if (customId == null) return null;
    for (DeadPlantModel dead in deadPlants) {
      if (dead.plant.uuid == customId) return dead;
    }
    return null;
  }

  PlantModel? plantById(String? customId) {
    if (customId == null) return null;
    for (PlantModel plant in allPlants) {
      if (plant.uuid == customId) return plant;
    }
    return null;
  }

  /// Aplica los campos que no vienen de Firebase tal cual: el id (es la key
  /// del nodo) y `justWatered`, que se deriva de la fecha de hoy igual que en
  /// [getPlantsData].
  PlantModel _withLocalState(PlantModel plant, String customId) =>
      plant.copyWith(
        uuid: customId,
        justWatered: plant.lastWateredDate == toYYYYMMdd(DateTime.now()),
      );

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
      allPlants.add(_withLocalState(deadPlant.plant, customId));
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
    if (!_hasLoadedPlants ||
        _settingsProvider == null ||
        _settingsProvider?.isInitialized != true) {
      return;
    }

    // Copia: la sincronización puede quedar en cola mientras la lista cambia.
    await _notificationService.syncPlantNotifications(
      List<PlantModel>.of(allPlants),
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
