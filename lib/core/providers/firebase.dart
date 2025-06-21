// ignore_for_file: avoid_print
part of com.watered_plants_ota_labs.app.providers;

class FirebaseProvider extends ChangeNotifier {
  final DatabaseReference _firebaseRef = FirebaseDatabase.instance.ref();
  bool isLoading = false;
  List<PlantModel> allPlants = <PlantModel>[];

  void initializeFirebase() {
    FirebaseApp firebaseApp = Firebase.app();
    FirebaseDatabase.instanceFor(app: firebaseApp, databaseURL: databaseURL);
  }

  Future<void> getPlantsData() async {
    isLoading = true;
    notifyListeners();
    DataSnapshot snapshot = await _firebaseRef.child(firebaseOriginPath).get();
    allPlants = <PlantModel>[];
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
                Map<String, dynamic> _plantMap = Map<String, dynamic>.from(
                  plant,
                );
                PlantModel _plantModel = PlantModel.fromJSON(_plantMap);
                allPlants.add(_plantModel);
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
    DataSnapshot snapshot =
        await _firebaseRef.child('$firebasePlantsPath$customId').get();
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
  }

  Future<void> deletePlant(String customId) async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref(
        '$firebasePlantsPath$customId',
      );
      await ref.remove();
    } catch (e) {
      print('Error during deletePlant: $customId | $e');
    }
    notifyListeners();
  }
}
