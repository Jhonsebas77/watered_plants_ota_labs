part of com.watered_plants_ota_labs.app.theme;

/// "Sharp 0px corners, industrial borders" del design_spec — una sola forma
/// compartida aplicada globalmente vía ThemeData en vez de overrides por
/// widget.
const RoundedRectangleBorder kSharpShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.zero,
);

final Border kIndustrialBorder = Border.all(
  color: BlueprintColors.outlineVariant,
  width: 1,
);

const OutlineInputBorder kSharpInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.zero,
  borderSide: BorderSide(color: BlueprintColors.outline),
);
