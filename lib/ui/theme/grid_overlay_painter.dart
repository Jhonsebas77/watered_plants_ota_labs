part of com.watered_plants_ota_labs.app.theme;

/// Grid overlay técnico del design_spec: líneas finas de `gridLine` sobre el
/// fondo `background`, espaciadas cada 24px.
class GridOverlayPainter extends CustomPainter {
  const GridOverlayPainter({this.spacing = 24});

  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = BlueprintColors.gridLine.withValues(alpha: 0.5)
      ..strokeWidth = 1;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridOverlayPainter oldDelegate) =>
      oldDelegate.spacing != spacing;
}
