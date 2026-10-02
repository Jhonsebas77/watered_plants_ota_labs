part of com.watered_plants_ota_labs.app.widgets.background;

/// Fondo de grilla tipo "blueprint" para la vista de login. A diferencia de
/// `BlueprintScaffold` (que también pinta un grid propio) esta vista usa un
/// [Scaffold] directo para no duplicar el overlay.
class GridBackground extends StatelessWidget {
  const GridBackground({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _GridPainter(), child: child);
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = BlueprintColors.gridLine
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const double step = 20;

    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}
