part of com.watered_plants_ota_labs.app.theme;

class BlueprintColors {
  BlueprintColors._();

  // ── Background / Surface ─────────────────────────────────
  static const Color background = Color(0xFF0B1623);
  static const Color surfaceContainerLow = Color(0xFF221A13);
  static const Color surfaceContainer = Color(0xFF271E16);
  static const Color gridLine = Color(0xFF1C2B3A);
  static const Color outlineVariant = Color(0xFF544435);
  static const Color outline = Color(0xFFA28D7B);

  // ── Text ─────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF0F0F0);
  static const Color textDim = Color(0xFF8B9BB4);
  static const Color onSurface = Color(0xFFF0DFD3);
  static const Color onSurfaceVariant = Color(0xFFDAC2AF);

  // ── Accent / Primary ─────────────────────────────────────
  static const Color primary = Color(0xFFFFC690);
  static const Color primaryContainer = Color(0xFFFF9F30);
  static const Color onPrimaryFixed = Color(0xFF2D1600);
  static const Color onPrimaryFixedVariant = Color(0xFF6A3C00);
  static const Color warning = Color(0xFFFF9F30);

  // ── Status ───────────────────────────────────────────────
  static const Color success = Color(0xFF00FF9D);
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);

  // ── Computed ─────────────────────────────────────────────
  static Color accentGlow = const Color(0xFFFF9F30).withAlpha(40);
  static Color successGlow = const Color(0xFF00FF9D).withAlpha(30);
}
