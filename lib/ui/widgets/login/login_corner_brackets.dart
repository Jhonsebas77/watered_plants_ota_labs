part of com.watered_plants_ota_labs.app.widgets;

/// Cuatro corchetes decorativos en las esquinas, tipo overlay de diagnóstico.
///
class CornerBrackets extends StatelessWidget {
  const CornerBrackets({
    super.key,
    this.size = 24,
    this.inset = 20,
    this.color = BlueprintColors.outline,
    this.strokeWidth = 1,
  });
  final double size;
  final double inset;
  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    Color bracketColor = color.withAlpha(100);
    return Stack(
      children: <Widget>[
        Positioned(
          top: inset,
          left: inset,
          child: _Bracket(
            size: size,
            color: bracketColor,
            strokeWidth: strokeWidth,
            corners: const <_Corner>{_Corner.topLeft},
          ),
        ),
        Positioned(
          top: inset,
          right: inset,
          child: _Bracket(
            size: size,
            color: bracketColor,
            strokeWidth: strokeWidth,
            corners: const <_Corner>{_Corner.topRight},
          ),
        ),
        Positioned(
          bottom: inset,
          left: inset,
          child: _Bracket(
            size: size,
            color: bracketColor,
            strokeWidth: strokeWidth,
            corners: const <_Corner>{_Corner.bottomLeft},
          ),
        ),
        Positioned(
          bottom: inset,
          right: inset,
          child: _Bracket(
            size: size,
            color: bracketColor,
            strokeWidth: strokeWidth,
            corners: const <_Corner>{_Corner.bottomRight},
          ),
        ),
      ],
    );
  }
}

enum _Corner { topLeft, topRight, bottomLeft, bottomRight }

class _Bracket extends StatelessWidget {
  const _Bracket({
    required this.size,
    required this.color,
    required this.strokeWidth,
    required this.corners,
  });
  final double size;
  final Color color;
  final double strokeWidth;
  final Set<_Corner> corners;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size(size, size),
    painter: _BracketPainter(
      color: color,
      strokeWidth: strokeWidth,
      corners: corners,
    ),
  );
}

class _BracketPainter extends CustomPainter {
  _BracketPainter({
    required this.color,
    required this.strokeWidth,
    required this.corners,
  });
  final Color color;
  final double strokeWidth;
  final Set<_Corner> corners;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    double w = size.width;
    double h = size.height;

    for (_Corner corner in corners) {
      switch (corner) {
        case _Corner.topLeft:
          canvas.drawLine(const Offset(0, 0), Offset(w, 0), paint);
          canvas.drawLine(const Offset(0, 0), Offset(0, h), paint);
        case _Corner.topRight:
          canvas.drawLine(const Offset(0, 0), Offset(w, 0), paint);
          canvas.drawLine(Offset(w, 0), Offset(w, h), paint);
        case _Corner.bottomLeft:
          canvas.drawLine(Offset(0, h), Offset(w, h), paint);
          canvas.drawLine(const Offset(0, 0), Offset(0, h), paint);
        case _Corner.bottomRight:
          canvas.drawLine(Offset(0, h), Offset(w, h), paint);
          canvas.drawLine(Offset(w, 0), Offset(w, h), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_BracketPainter old) => false;
}
