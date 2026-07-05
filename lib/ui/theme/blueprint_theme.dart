part of com.watered_plants_ota_labs.app.theme;

class BlueprintTheme {
  BlueprintTheme._();

  static TextStyle _mono({
    required Color color,
    double size = 14,
    FontWeight weight = FontWeight.w400,
    double letterSpacing = 0,
    double height = 1.4,
  }) => GoogleFonts.jetBrainsMono(
    color: color,
    fontSize: size,
    fontWeight: weight,
    letterSpacing: letterSpacing,
    height: height,
  );

  static ThemeData dark() {
    const Color bg = BlueprintColors.background;
    const Color surface = BlueprintColors.surfaceContainerLow;
    const Color grid = BlueprintColors.gridLine;
    const Color text = BlueprintColors.textPrimary;
    const Color dim = BlueprintColors.textDim;
    const Color accent = BlueprintColors.primaryContainer;

    ColorScheme scheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: accent,
      onPrimary: BlueprintColors.onPrimaryFixed,
      primaryContainer: Color(0xFF6A3B00),
      onPrimaryContainer: text,
      secondary: BlueprintColors.primary,
      onSecondary: BlueprintColors.onPrimaryFixed,
      secondaryContainer: grid,
      onSecondaryContainer: text,
      tertiary: BlueprintColors.success,
      onTertiary: bg,
      tertiaryContainer: Color(0xFF004D64),
      onTertiaryContainer: text,
      error: BlueprintColors.error,
      onError: bg,
      errorContainer: BlueprintColors.errorContainer,
      onErrorContainer: BlueprintColors.error,
      surface: surface,
      onSurface: BlueprintColors.onSurface,
      surfaceContainerHighest: Color(0xFF3D332A),
      onSurfaceVariant: BlueprintColors.onSurfaceVariant,
      outline: BlueprintColors.outline,
      outlineVariant: BlueprintColors.outlineVariant,
      shadow: Colors.black38,
      scrim: Colors.black54,
      inverseSurface: text,
      onInverseSurface: bg,
      inversePrimary: Color(0xFF8B5000),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      fontFamily: GoogleFonts.jetBrainsMono().fontFamily,

      // ── SystemUI overlay ─────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: BlueprintColors.background,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: _mono(
          color: text,
          size: 16,
          weight: FontWeight.w600,
          letterSpacing: 2,
        ),
        shape: const Border(
          bottom: BorderSide(color: BlueprintColors.outline, width: 1),
        ),
      ),

      // ── Cards ────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(
            color: BlueprintColors.outline.withAlpha(80),
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // ── Elevated Button ───────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((
            Set<WidgetState> s,
          ) {
            if (s.contains(WidgetState.pressed)) return const Color(0xFFD47800);
            return accent;
          }),
          foregroundColor: WidgetStateProperty.all(
            BlueprintColors.onPrimaryFixed,
          ),
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(0),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          ),
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          textStyle: WidgetStateProperty.all(
            _mono(
              color: BlueprintColors.onPrimaryFixed,
              size: 12,
              weight: FontWeight.w700,
              letterSpacing: 3,
            ),
          ),
          side: WidgetStateProperty.all(
            const BorderSide(color: accent, width: 1),
          ),
          animationDuration: const Duration(milliseconds: 150),
        ),
      ),

      // ── Outlined Button ───────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(dim),
          side: WidgetStateProperty.all(
            BorderSide(color: BlueprintColors.outline.withAlpha(100), width: 1),
          ),
          shape: WidgetStateProperty.all(
            const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          textStyle: WidgetStateProperty.all(
            _mono(
              color: dim,
              size: 10,
              weight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
        ),
      ),

      // ── Input ─────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        hintStyle: _mono(
          color: dim.withAlpha(100),
          size: 12,
          letterSpacing: 3,
          weight: FontWeight.w500,
        ),
        labelStyle: _mono(color: dim, size: 10, letterSpacing: 2),
        floatingLabelStyle: _mono(color: accent, size: 10, letterSpacing: 2),
        prefixIconColor: dim,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(
            color: BlueprintColors.outline.withAlpha(120),
            width: 1,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: BlueprintColors.error, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: BlueprintColors.error, width: 1.5),
        ),
      ),

      // ── Divider ──────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: BlueprintColors.gridLine,
        thickness: 1,
        space: 1,
      ),

      // ── Icon ─────────────────────────────────────────────
      iconTheme: const IconThemeData(color: BlueprintColors.textDim, size: 20),
      primaryIconTheme: const IconThemeData(color: accent, size: 20),

      // ── Progress ─────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: accent,
        linearTrackColor: BlueprintColors.gridLine,
        linearMinHeight: 2,
      ),

      // ── SnackBar ─────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: grid,
        contentTextStyle: _mono(color: text, size: 12),
        actionTextColor: accent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
