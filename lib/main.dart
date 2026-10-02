import 'package:firebase_core/firebase_core.dart';
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
import 'ui/theme/theme.dart';
import 'ui/views/views.dart';
import 'ui/widgets/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (supabaseUrl.isEmpty ||
      supabasePublishableKey.isEmpty ||
      hardcodedEmail.isEmpty ||
      databaseURL.isEmpty) {
    throw StateError(
      'Faltan las credenciales. Corre la app con '
      '--dart-define=SUPABASE_URL=... '
      '--dart-define=SUPABASE_PUBLISHABLE_KEY=... '
      '--dart-define=AUTH_EMAIL=... '
      '--dart-define=FIREBASE_DATABASE_URL=... '
      '(o --dart-define-from-file=config/dart_defines.local.json).',
    );
  }
  await Supabase.initialize(url: supabaseUrl, anonKey: supabasePublishableKey);
  await initializeDateFormatting();
  await NotificationService().initialize();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: BlueprintColors.background,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: BlueprintColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
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
        create: (_) =>
            SettingsProvider(notificationService: NotificationService()),
      ),
      ChangeNotifierProxyProvider<SettingsProvider, FirebaseProvider>(
        create: (_) =>
            FirebaseProvider(notificationService: NotificationService()),
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
      theme: appTheme,
      darkTheme: appDarkTheme,
      themeMode: ThemeMode.dark,
      home: Consumer<AuthProvider>(
        builder:
            (BuildContext context, AuthProvider authProvider, Widget? child) {
              if (authProvider.isLoading) {
                return const BlueprintScaffold(
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

  Future<void> _confirmLogout() async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('LOGOUT_CONFIRM'),
        content: const Text('¿Cerrar sesión del sistema?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('SALIR'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await Provider.of<AuthProvider>(context, listen: false).signOut();
    }
  }

  @override
  Widget build(BuildContext context) => BlueprintScaffold(
    appBar: BlueprintTopAppBar(
      actions: <Widget>[
        IconButton(
          tooltip: 'Cerrar sesión',
          icon: const Icon(
            Icons.logout_outlined,
            color: BlueprintColors.textPrimary,
          ),
          onPressed: _confirmLogout,
        ),
        IconButton(
          tooltip: 'Ajustes',
          icon: const Icon(Icons.settings, color: BlueprintColors.textPrimary),
          onPressed: () =>
              CustomNavigator().push(context, const SettingsView()),
        ),
      ],
    ),
    body: const Stack(children: <Widget>[ScanlineOverlay(), HomePlantsView()]),
    floatingActionButton: const AddPlantFloatingActionButton(),
  );
}
