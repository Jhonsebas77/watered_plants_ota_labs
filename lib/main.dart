import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/providers/providers.dart';
import 'core/services/services.dart';
import 'core/utils/constants.dart';
import 'firebase_options.dart';
import 'ui/navigator.dart';
import 'ui/theme.dart';
import 'ui/views/views.dart';
import 'ui/widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
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
      ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
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
      home: Consumer<AuthProvider>(
        builder: (
          BuildContext context,
          AuthProvider authProvider,
          Widget? child,
        ) {
          if (authProvider.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (authProvider.isAuthenticated) {
            return const MyHomePage(title: 'Watering my plants');
          }
          return const LoginView();
        },
      ),
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
          tooltip: 'Cerrar sesión',
          icon: const Icon(Icons.logout_outlined),
          onPressed: () {
            showDialog<bool>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Cerrar sesión'),
                content: const Text(
                  '¿Estás seguro de que quieres cerrar sesión?',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Cerrar sesión'),
                  ),
                ],
              ),
            ).then((bool? confirmed) {
              if (confirmed == true) {
                Provider.of<AuthProvider>(
                  context,
                  listen: false,
                ).signOut();
              }
            });
          },
        ),
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
