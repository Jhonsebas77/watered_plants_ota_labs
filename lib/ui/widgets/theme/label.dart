part of com.watered_plants_ota_labs.app.widgets;

class CustomStyles {
  TextStyle customLabelTextStyle({
    Color color = BlueprintColors.textDim,
    double size = 10,
    double spacing = 1.5,
    FontWeight weight = FontWeight.w500,
  }) => GoogleFonts.jetBrainsMono(
    color: color,
    fontSize: size,
    letterSpacing: spacing,
    fontWeight: weight,
    height: 1.2,
  );
}
