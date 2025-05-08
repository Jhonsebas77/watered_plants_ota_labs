// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/models/models.dart';
import 'firebase_options.dart';
import 'ui/theme.dart';
import 'ui/widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter Demo',
    theme: lightTheme,
    darkTheme: darkTheme,
    themeMode: ThemeMode.system,
    home: const MyHomePage(title: 'Flutter Demo Home Page'),
  );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  void initializeFirebase() {
    FirebaseApp firebaseApp = Firebase.app();
    FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL:
          'https://flutter-tools-jsob-default-rtdb.firebaseio.com/watered_plants',
    );
  }

  Future<void> getData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    DataSnapshot snapshot = await ref.child('/watered_plants').get();
    if (snapshot.exists && snapshot.value != null) {
      if (snapshot.value is Map) {
        try {
          Map<String, dynamic> typedData = Map<String, dynamic>.from(
            // ignore: cast_nullable_to_non_nullable, always_specify_types
            snapshot.value as Map,
          );
          if (typedData['plants'] is Map) {
            Map<String, dynamic> _plantsMap = Map<String, dynamic>.from(
              // ignore: cast_nullable_to_non_nullable, always_specify_types
              typedData['plants'] as Map,
            )..forEach((String id, dynamic plant) {
              if (plant is Map) {
                Map<String, dynamic> _plantMap = Map<String, dynamic>.from(
                  plant,
                );
                print(
                  '[PlantModel] -> [$id] |  ${PlantModel.fromJSON(_plantMap)}',
                );
              }
            });
            print('[_plantsMap] -> $_plantsMap');
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
  }

  Future<void> addPlant() async {
    String customId = 'cb8da1ce-8ab4-4b1e-a6f4-ac1e78ee8188';
    DatabaseReference ref = FirebaseDatabase.instance.ref(
      '/watered_plants/plants/$customId',
    );

    await ref.update(<String, Object?>{
      'color': 'green',
      'icon': 'plant_1',
      'last_watered_date': '01/01/2025',
      'next_watering_date': '01/05/2025',
      'plant_care': 'Sol directo, alejar del viento',
      'plant_image': 'url...',
      'plant_name': 'Cactus y suculentas',
      'species': 'Cactus',
      'watering_frequency_days': 5,
    });
  }

  Future<void> updatePlant() async {
    String customId = 'cb8da1ce-8ab4-4b1e-a6f4-ac1e78ee8188';
    DatabaseReference ref = FirebaseDatabase.instance.ref(
      '/watered_plants/plants/$customId',
    );

    await ref.update(<String, Object?>{
      'color': 'green',
      'icon': 'plant_1',
      'last_watered_date': '01/01/2025',
      'next_watering_date': '01/05/2025',
      'plant_care': 'Sol directo, alejar del viento, poca agua',
      'plant_image': 'url...',
      'plant_name': 'Cactus y suculentas',
      'species': 'Cactus',
      'watering_frequency_days': 5,
    });
  }

  Future<void> deletePlant() async {
    String customId = '09c5197e-32f3-4e38-974c-61492dc67ff0';
    DatabaseReference ref = FirebaseDatabase.instance.ref(
      '/watered_plants/plants/$customId',
    );

    await ref.remove();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(widget.title),
    ),
    body: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[BasicPlantCard(plantName: 'Test plant')],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      // onPressed: deletePlant,
      // onPressed: updatePlant,
      // onPressed: addPlant,
      onPressed: getData,
      // onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    ),
  );
}
