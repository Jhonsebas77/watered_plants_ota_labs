part of com.watered_plants_ota_labs.app.widgets;

class LoginSchematicRing extends StatefulWidget {
  const LoginSchematicRing({required this.child, super.key, this.size = 160});
  final Widget child;
  final double size;

  @override
  State<LoginSchematicRing> createState() => _LoginSchematicRingState();
}

class _LoginSchematicRingState extends State<LoginSchematicRing>
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
          AnimatedBuilder(
            animation: _ctrl,
            builder:
                (_, __) => Transform.rotate(
                  angle: _ctrl.value * 2 * math.pi,
                  child: CustomPaint(
                    size: Size(outerSize, outerSize),
                    painter: _LoginDashedCirclePainter(),
                  ),
                ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _LoginDashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = BlueprintColors.outline.withAlpha(70)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2 - 2;
    const int dashCount = 36;
    const double dashAngle = (2 * math.pi) / dashCount;
    const double gapRatio = 0.4;
    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * dashAngle,
        dashAngle * (1 - gapRatio),
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_LoginDashedCirclePainter old) => false;
}
