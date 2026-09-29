part of com.watered_plants_ota_labs.app.theme;

/// Estilos de texto estáticos, accesibles sin `Theme.of(context)` (ej.
/// `AppTextStyles.bodySmall`). Son la fuente única de verdad para
/// `appTheme`/`appDarkTheme`.textTheme (ver app_theme.dart). Fijan su color
/// desde `BlueprintColors` (no desde el `ColorScheme` claro/oscuro): casi
/// toda la app pinta su fondo con `BlueprintColors.background` a través de
/// `BlueprintScaffold`, sin importar el tema del sistema, así que el texto
/// necesita un color fijo con buen contraste sobre ese fondo oscuro en vez
/// de heredar un `onSurface` que se vuelve casi negro en tema claro.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'JetBrainsMono';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 57,
    fontWeight: FontWeight.bold,
    color: BlueprintColors.textPrimary,
  );

  /// No está en el archivo de referencia (que solo llega a headlineMedium);
  /// se agrega para el wordmark de marca (splash_screen.dart), que ya usaba
  /// este rol.
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: BlueprintColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: BlueprintColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: BlueprintColors.textPrimary,
  );

  /// No está en el archivo de referencia; se agrega porque varias vistas ya
  /// la usaban (settings, historial de combustible, mantenimiento).
  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: BlueprintColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.5,
    color: BlueprintColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 1.4,
    color: BlueprintColors.textPrimary,
  );

  /// No está en el archivo de referencia; es el rol más usado en este
  /// proyecto (labels, subtítulos, metadatos).
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    height: 1.3,
    color: BlueprintColors.textMuted,
  );

  /// No está en el archivo de referencia; usado por el bottom nav bar.
  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: BlueprintColors.textMuted,
  );

  /// No está en el archivo de referencia; usado por badges/etiquetas chicas.
  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    color: BlueprintColors.textMuted,
  );

  /// Label monoespaciado estilo HUD (mayúsculas, letter-spacing amplio) para
  /// etiquetas cortas de estado/sección. Reemplaza al antiguo
  /// `CustomStyles().customLabelTextStyle`.
  static TextStyle label({
    Color color = BlueprintColors.textMuted,
    double size = 10,
    double spacing = 1.5,
    FontWeight weight = FontWeight.w500,
  }) => TextStyle(
    fontFamily: fontFamily,
    color: color,
    fontSize: size,
    letterSpacing: spacing,
    fontWeight: weight,
    height: 1.2,
  );
}
