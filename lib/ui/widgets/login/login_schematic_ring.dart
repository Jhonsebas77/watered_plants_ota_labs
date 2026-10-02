part of com.watered_plants_ota_labs.app.widgets;

/// Anillo punteado que rota lentamente alrededor de [child] (usado para
/// enmarcar el logo en el login).
/// (SchematicRing).
class SchematicRing extends StatefulWidget {
  const SchematicRing({required this.child, super.key, this.size = 160});
  final Widget child;
  final double size;

  @override
  State<SchematicRing> createState() => _SchematicRingState();
}

class _SchematicRingState extends State<SchematicRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double outerSize = widget.size + 32;
    return SizedBox(
      width: outerSize,
      height: outerSize,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          RepaintBoundary(
            child: RotationTransition(
              turns: _ctrl,
              child: RepaintBoundary(
                child: CustomPaint(
                  size: Size(outerSize, outerSize),
                  painter: const _DashedCirclePainter(),
                ),
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = BlueprintColors.outline.withAlpha(70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = (size.width / 2) - 2;

    const int dashCount = 36;
    const double dashAngle = (2 * math.pi) / dashCount;
    const double gapRatio = 0.4;

    for (int i = 0; i < dashCount; i++) {
      double startAngle = i * dashAngle;
      const double sweepAngle = dashAngle * (1 - gapRatio);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter old) => false;
}
