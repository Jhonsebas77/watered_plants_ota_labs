part of com.watered_plants_ota_labs.app.theme;

/// Tema unificado que alimenta `ThemeData`/`MaterialApp` (botones, inputs,
/// switches, chips, cards, snackbars, textTheme...). Todos los componentes
/// de Material se pintan con la paleta "Engineering Blueprint"
/// (`BlueprintColors`) y esquinas rectas (`kSharpShape`), igual que el
/// design system del proyecto de Stitch: el fondo de la app siempre es
/// oscuro (`BlueprintScaffold`), así que tema claro y oscuro comparten los
/// mismos colores de componentes — solo cambia el `brightness` del
/// `ColorScheme`.
///
/// Antes se usaban el azul `#3B82F6` y grises genéricos de Material (tema
/// portado de app_track_ota_labs): el botón principal quedaba azul con texto
/// blanco (contraste 3.68, bajo AA para 16px) y los bordes de inputs no
/// llegaban a 3:1 sobre el fondo.

// --- OVERLAYS NATIVOS (diálogos, date picker, menús, bottom sheets) ---
//
// A diferencia del resto de la UI, estos widgets no viven dentro de
// `BlueprintScaffold`: son rutas/overlays propios que resuelven su fondo
// desde `ThemeData` en el momento de abrirse, y por lo tanto SÍ cambian con
// el tema del sistema si no se fijan acá. Como `AppTextStyles` ya fuerza un
// color de texto fijo (pensado para el fondo oscuro fijo de
// `BlueprintColors.background`), estos overlays necesitan también un fondo
// fijo — si no, en tema claro del sistema terminan con fondo claro
// (heredado de `ColorScheme.surface`) y texto casi blanco encima,
// ilegible. Se usa el mismo valor (`surfaceContainerLow`) que ya usan a
// mano los `AlertDialog` de borrado (ver `fuel_history_list.dart`,
// `legal_garage_screen.dart`, `odometer_quick_update_card.dart`), así que
// esos quedan visualmente igual.
final DatePickerThemeData _blueprintDatePickerTheme = DatePickerThemeData(
  backgroundColor: BlueprintColors.surfaceContainerLow,
  headerBackgroundColor: BlueprintColors.background,
  headerForegroundColor: BlueprintColors.textPrimary,
  weekdayStyle: AppTextStyles.bodySmall,
  dayStyle: AppTextStyles.bodyMedium,
  dayForegroundColor: WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) => states.contains(WidgetState.selected)
        ? BlueprintColors.onAccent
        : states.contains(WidgetState.disabled)
        ? BlueprintColors.textMuted
        : BlueprintColors.textPrimary,
  ),
  dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) => states.contains(WidgetState.selected)
        ? BlueprintColors.accentOrange
        : null,
  ),
  todayForegroundColor: WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) => states.contains(WidgetState.selected)
        ? BlueprintColors.onAccent
        : BlueprintColors.accentOrange,
  ),
  todayBorder: const BorderSide(color: BlueprintColors.accentOrange),
  yearStyle: AppTextStyles.bodyMedium,
  yearForegroundColor: WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) => states.contains(WidgetState.selected)
        ? BlueprintColors.onAccent
        : BlueprintColors.textPrimary,
  ),
  yearBackgroundColor: WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) => states.contains(WidgetState.selected)
        ? BlueprintColors.accentOrange
        : null,
  ),
  rangePickerBackgroundColor: BlueprintColors.surfaceContainerLow,
  dividerColor: BlueprintColors.outlineVariant,
  subHeaderForegroundColor: BlueprintColors.textPrimary,
  shape: kSharpShape,
);

const DialogThemeData _blueprintDialogTheme = DialogThemeData(
  backgroundColor: BlueprintColors.surfaceContainerLow,
  shape: kSharpShape,
);

const PopupMenuThemeData _blueprintPopupMenuTheme = PopupMenuThemeData(
  color: BlueprintColors.surfaceContainerLow,
  textStyle: AppTextStyles.bodyMedium,
  shape: kSharpShape,
);

const BottomSheetThemeData _blueprintBottomSheetTheme = BottomSheetThemeData(
  backgroundColor: BlueprintColors.surfaceContainerLow,
  shape: kSharpShape,
);

// `ListTile`/`SwitchListTile`/`CheckboxListTile` NO heredan su color de
// `textTheme` como el resto de los `Text`: su estilo por defecto es
// `textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface)` (ver
// `list_tile.dart` en el SDK de Flutter) — ese `.copyWith` pisa el color fijo
// de `AppTextStyles` con el `onSurface` adaptativo del `ColorScheme`, así que
// títulos como "Fecha del tanqueo" o "Tanque lleno" (usados sin `style`
// propio en varias pantallas) volvían a quedar casi negros en tema claro.
// Se fija acá por la misma razón que el resto de los overlays de arriba.
const ListTileThemeData _blueprintListTileTheme = ListTileThemeData(
  textColor: BlueprintColors.textPrimary,
  iconColor: BlueprintColors.textMuted,
  titleTextStyle: AppTextStyles.bodyLarge,
  subtitleTextStyle: AppTextStyles.bodySmall,
);

// --- COMPONENTES BLUEPRINT (compartidos por ambos temas) ---

const TextStyle _buttonTextStyle = TextStyle(
  fontFamily: AppTextStyles.fontFamily,
  fontSize: 16,
  fontWeight: FontWeight.bold,
  letterSpacing: 1,
);

ColorScheme _blueprintColorScheme(Brightness brightness) =>
    ColorScheme.fromSeed(
      seedColor: BlueprintColors.accentOrange,
      brightness: brightness,
      primary: BlueprintColors.accentOrange,
      onPrimary: BlueprintColors.onAccent,
      secondary: BlueprintColors.textMuted,
      tertiary: BlueprintColors.successGreen,
      error: BlueprintColors.danger,
      onError: BlueprintColors.onAccent,
      outline: BlueprintColors.outline,
      outlineVariant: BlueprintColors.outlineVariant,
    );

const AppBarTheme _blueprintAppBarTheme = AppBarTheme(
  backgroundColor: BlueprintColors.background,
  foregroundColor: BlueprintColors.textPrimary,
  centerTitle: true,
  titleTextStyle: AppTextStyles.titleLarge,
);

final ElevatedButtonThemeData _blueprintElevatedButtonTheme =
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: BlueprintColors.accentOrange,
        foregroundColor: BlueprintColors.onAccent,
        disabledBackgroundColor: BlueprintColors.accentOrange.withAlpha(120),
        disabledForegroundColor: BlueprintColors.onAccent.withAlpha(160),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: kSharpShape,
        textStyle: _buttonTextStyle,
      ),
    );

final OutlinedButtonThemeData _blueprintOutlinedButtonTheme =
    OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: BlueprintColors.accentOrange,
        side: const BorderSide(color: BlueprintColors.accentOrange),
        shape: kSharpShape,
        textStyle: _buttonTextStyle.copyWith(fontSize: 14),
      ),
    );

final TextButtonThemeData _blueprintTextButtonTheme = TextButtonThemeData(
  style: TextButton.styleFrom(
    foregroundColor: BlueprintColors.accentOrange,
    shape: kSharpShape,
    textStyle: _buttonTextStyle,
  ),
);

/// Borde de reposo con `outline` (3.24:1 sobre el fondo): el borde es lo
/// único que delimita el campo, así que necesita el 3:1 de WCAG 1.4.11 —
/// `outlineVariant` (1.67:1) queda para cards y divisores decorativos.
const InputDecorationTheme _blueprintInputDecorationTheme =
    InputDecorationTheme(
      border: kSharpInputBorder,
      enabledBorder: kSharpInputBorder,
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: BlueprintColors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: BlueprintColors.accentOrange, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: BlueprintColors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: BlueprintColors.danger, width: 2),
      ),
      // Fijo en claro: el fondo del formulario siempre es oscuro
      // (`BlueprintColors.background`), sin importar el tema del sistema.
      labelStyle: TextStyle(
        color: BlueprintColors.textPrimary,
        fontFamily: AppTextStyles.fontFamily,
      ),
      floatingLabelStyle: TextStyle(
        color: BlueprintColors.accentOrange,
        fontFamily: AppTextStyles.fontFamily,
      ),
      hintStyle: TextStyle(
        color: BlueprintColors.textMuted,
        fontFamily: AppTextStyles.fontFamily,
      ),
      errorStyle: TextStyle(
        color: BlueprintColors.danger,
        fontFamily: AppTextStyles.fontFamily,
      ),
      suffixIconColor: BlueprintColors.textMuted,
      prefixIconColor: BlueprintColors.textMuted,
    );

final SwitchThemeData _blueprintSwitchTheme = SwitchThemeData(
  thumbColor: WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) => states.contains(WidgetState.selected)
        ? BlueprintColors.onAccent
        : BlueprintColors.textMuted,
  ),
  trackColor: WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) => states.contains(WidgetState.selected)
        ? BlueprintColors.accentOrange
        : BlueprintColors.surfaceContainerLow,
  ),
  trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
    (Set<WidgetState> states) => states.contains(WidgetState.selected)
        ? BlueprintColors.accentOrange
        : BlueprintColors.outline,
  ),
);

final SegmentedButtonThemeData _blueprintSegmentedButtonTheme =
    SegmentedButtonThemeData(
      style: ButtonStyle(
        shape: const WidgetStatePropertyAll<OutlinedBorder>(kSharpShape),
        side: const WidgetStatePropertyAll<BorderSide>(
          BorderSide(color: BlueprintColors.outline),
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? BlueprintColors.accentOrange
              : Colors.transparent,
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? BlueprintColors.onAccent
              : BlueprintColors.textPrimary,
        ),
        textStyle: const WidgetStatePropertyAll<TextStyle>(
          AppTextStyles.bodyMedium,
        ),
      ),
    );

const ChipThemeData _blueprintChipTheme = ChipThemeData(
  backgroundColor: BlueprintColors.surfaceContainerLow,
  side: BorderSide(color: BlueprintColors.outline),
  shape: kSharpShape,
  labelStyle: AppTextStyles.bodySmall,
);

const ProgressIndicatorThemeData _blueprintProgressIndicatorTheme =
    ProgressIndicatorThemeData(color: BlueprintColors.accentOrange);

final TextSelectionThemeData _blueprintTextSelectionTheme =
    TextSelectionThemeData(
      cursorColor: BlueprintColors.accentOrange,
      selectionColor: BlueprintColors.accentOrange.withAlpha(90),
      selectionHandleColor: BlueprintColors.accentOrange,
    );

const CardThemeData _blueprintCardTheme = CardThemeData(
  elevation: 0,
  color: BlueprintColors.surfaceContainerLow,
  shape: RoundedRectangleBorder(
    side: BorderSide(color: BlueprintColors.outlineVariant),
  ),
);

const TextTheme _blueprintTextTheme = TextTheme(
  displayLarge: AppTextStyles.displayLarge,
  headlineLarge: AppTextStyles.headlineLarge,
  headlineMedium: AppTextStyles.headlineMedium,
  titleLarge: AppTextStyles.titleLarge,
  titleMedium: AppTextStyles.titleMedium,
  bodyLarge: AppTextStyles.bodyLarge,
  bodyMedium: AppTextStyles.bodyMedium,
  bodySmall: AppTextStyles.bodySmall,
  labelMedium: AppTextStyles.labelMedium,
  labelSmall: AppTextStyles.labelSmall,
);

ThemeData _blueprintTheme(Brightness brightness) => ThemeData(
  useMaterial3: true,
  fontFamily: AppTextStyles.fontFamily,
  colorScheme: _blueprintColorScheme(brightness),
  // El menú de `DropdownButton`/`DropdownButtonFormField` usa `canvasColor`
  // como fondo cuando no se pasa `dropdownColor` explícito — se fija acá
  // por la misma razón que dialogTheme/datePickerTheme (ver comentario
  // arriba): si no, en tema claro queda claro con el texto casi blanco de
  // `AppTextStyles` encima.
  canvasColor: BlueprintColors.surfaceContainerLow,
  dialogTheme: _blueprintDialogTheme,
  datePickerTheme: _blueprintDatePickerTheme,
  popupMenuTheme: _blueprintPopupMenuTheme,
  bottomSheetTheme: _blueprintBottomSheetTheme,
  listTileTheme: _blueprintListTileTheme,
  textTheme: _blueprintTextTheme,
  appBarTheme: _blueprintAppBarTheme,
  elevatedButtonTheme: _blueprintElevatedButtonTheme,
  outlinedButtonTheme: _blueprintOutlinedButtonTheme,
  textButtonTheme: _blueprintTextButtonTheme,
  inputDecorationTheme: _blueprintInputDecorationTheme,
  switchTheme: _blueprintSwitchTheme,
  segmentedButtonTheme: _blueprintSegmentedButtonTheme,
  chipTheme: _blueprintChipTheme,
  progressIndicatorTheme: _blueprintProgressIndicatorTheme,
  textSelectionTheme: _blueprintTextSelectionTheme,
  cardTheme: _blueprintCardTheme,
);

// --- LIGHT THEME ---
final ThemeData appTheme = _blueprintTheme(Brightness.light);

// --- DARK THEME ---
final ThemeData appDarkTheme = _blueprintTheme(Brightness.dark);
