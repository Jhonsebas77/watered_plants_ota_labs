// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import 'core/providers/providers.dart';
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
  Widget build(BuildContext context) => MultiProvider(
    providers: <SingleChildWidget>[
      ChangeNotifierProvider<FirebaseProvider>(
        create: (_) => FirebaseProvider(),
      ),
    ],
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Watering my plants'),
    ),
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(
        context,
        listen: false,
      )..initializeFirebase();
      await firebaseProvider.getPlantsData();
    });
    super.initState();
  }

  void initializeFirebase() {
    FirebaseApp firebaseApp = Firebase.app();
    FirebaseDatabase.instanceFor(
      app: firebaseApp,
      databaseURL:
          'https://flutter-tools-jsob-default-rtdb.firebaseio.com/watered_plants',
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(widget.title),
    ),
    body: Consumer<FirebaseProvider>(
      builder: (
        BuildContext context,
        FirebaseProvider provider,
        Widget? child,
      ) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.deepOrangeAccent),
          );
        } else if (provider.allPlants.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.error_outline_rounded),
                    SizedBox(width: 8),
                    Text('No hay nada'),
                  ],
                ),
              ),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: provider.allPlants.length,
            itemBuilder:
                (BuildContext context, int index) => BasicPlantCard(
                  plantName: provider.allPlants[index].plantName,
                  colorPlant: provider.allPlants[index].color,
                  plantIcon: provider.allPlants[index].icon,
                  nextWateringDate: provider.allPlants[index].nextWateringDate,
                  wateringFrequencyDays:
                      provider.allPlants[index].wateringFrequencyDays,
                ),
          );
        }
      },
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    ),
  );
}
