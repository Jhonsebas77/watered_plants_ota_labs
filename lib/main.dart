import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'ui/theme/theme.dart';
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
      darkTheme: BlueprintTheme.dark(),
      themeMode: ThemeMode.dark,
      home: Consumer<AuthProvider>(
        builder:
            (BuildContext context, AuthProvider authProvider, Widget? child) {
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
    backgroundColor: BlueprintColors.background,
    appBar: AppBar(
      backgroundColor: BlueprintColors.surfaceContainerLow,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.eco_rounded,
            color: BlueprintColors.primaryContainer,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'WATERED_PLANTS',
            style: GoogleFonts.jetBrainsMono(
              color: BlueprintColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.5,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: BlueprintColors.outline.withAlpha(60),
        ),
      ),
      actions: <Widget>[
        IconButton(
          tooltip: 'LOGOUT',
          icon: const Icon(
            Icons.logout_outlined,
            color: BlueprintColors.textDim,
            size: 18,
          ),
          onPressed: () {
            showDialog<bool>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                backgroundColor: BlueprintColors.surfaceContainerLow,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                title: Text(
                  'LOGOUT_CONFIRM',
                  style: GoogleFonts.jetBrainsMono(
                    color: BlueprintColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                content: Text(
                  '¿Cerrar sesión del sistema?',
                  style: GoogleFonts.jetBrainsMono(
                    color: BlueprintColors.textDim,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      'CANCEL',
                      style: GoogleFonts.jetBrainsMono(
                        color: BlueprintColors.textDim,
                        fontSize: 10,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BlueprintColors.primaryContainer,
                      foregroundColor: BlueprintColors.onPrimaryFixed,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text(
                      'LOGOUT',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ).then((bool? confirmed) {
              if (confirmed == true && context.mounted) {
                Provider.of<AuthProvider>(context, listen: false).signOut();
              }
            });
          },
        ),
        IconButton(
          tooltip: 'SETTINGS',
          icon: const Icon(
            Icons.settings_outlined,
            color: BlueprintColors.textDim,
            size: 18,
          ),
          onPressed: () {
            CustomNavigator().push(context, const SettingsView());
          },
        ),
      ],
    ),
    body: const GridBackground(
      child: Stack(children: <Widget>[ScanlineOverlay(), HomePlantsView()]),
    ),
    floatingActionButton: const AddPlantFloatingActionButton(),
  );
}
