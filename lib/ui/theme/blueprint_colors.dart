part of com.watered_plants_ota_labs.app.theme;

/// Paleta del design system "Engineering Blueprint Schematic"
/// (claude/design_spec.md). Los cuatro primeros valores vienen directo del
/// spec; el resto son derivados no especificados, documentados como tales.
class BlueprintColors {
  BlueprintColors._();

  static const Color background = Color(0xFF0B1623);
  static const Color gridLine = Color(0xFF1C2B3A);
  static const Color accentOrange = Color(0xFFFF9F30);
  static const Color successGreen = Color(0xFF00FF9D);

  // Derivados (no están en design_spec.md), elegidos para completar la
  // paleta oscura/monospace/industrial sin romper el contraste con el fondo.
  static const Color warning = accentOrange;
  static const Color danger = Color(0xFFFF4D4D);
  static const Color outlineVariant = Color(0xFF2A3F52);
  static const Color surfaceContainerLow = Color(0xFF101E2C);
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textMuted = Color(0xFF7C93A8);

  /// Línea decorativa más clara que [outlineVariant] (brackets, ring
  /// giratorio de la vista de login). Derivado, no está en design_spec.md.
  static const Color outline = Color(0xFF4A6B85);

  /// Color de texto/ícono sobre [accentOrange] (botón primario de acento).
  /// Derivado, no está en design_spec.md.
  static const Color onAccent = Color(0xFF1A0F00);

  /// Acento azul (badges informativos, ej. gasolina extra). Derivado, no
  /// está en design_spec.md.
  static const Color infoBlue = Color(0xFF4DA6FF);
}
