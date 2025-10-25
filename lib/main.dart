import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

import 'core/providers/providers.dart';
import 'core/services/services.dart';
import 'firebase_options.dart';
import 'ui/navigator.dart';
import 'ui/theme.dart';
import 'ui/views/views.dart';
import 'ui/widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting();
  await NotificationService().initialize();
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
      ChangeNotifierProvider<SettingsProvider>(
        create:
            (_) => SettingsProvider(notificationService: NotificationService()),
      ),
      ChangeNotifierProxyProvider<SettingsProvider, FirebaseProvider>(
        create:
            (_) => FirebaseProvider(notificationService: NotificationService()),
        update: (_, SettingsProvider settings, FirebaseProvider? firebase) {
          FirebaseProvider provider =
              firebase ??
                    FirebaseProvider(notificationService: NotificationService())
                ..updateSettings(settings);
          return provider;
        },
      ),
    ],
    child: MaterialApp(
      title: 'Watering my plants',
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
      title: Text(widget.title),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          tooltip: 'Ajustes',
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            CustomNavigator().push(context, const SettingsView());
          },
        ),
      ],
    ),
    body: const HomePlantsView(),
    floatingActionButton: const AddPlantFloatingActionButton(),
  );
}
