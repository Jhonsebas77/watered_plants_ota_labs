part of com.watered_plants_ota_labs.app.widgets;

class LoginCornerBrackets extends StatelessWidget {
  const LoginCornerBrackets({super.key, this.size = 24, this.inset = 20});
  final double size;
  final double inset;

  @override
  Widget build(BuildContext context) => Stack(
    children: <Widget>[
      Positioned(
        top: inset,
        left: inset,
        child: _LoginBracket(
          size: size,
          corners: const <_BracketCorner>{_BracketCorner.topLeft},
        ),
      ),
      Positioned(
        top: inset,
        right: inset,
        child: _LoginBracket(
          size: size,
          corners: const <_BracketCorner>{_BracketCorner.topRight},
        ),
      ),
      Positioned(
        bottom: inset,
        left: inset,
        child: _LoginBracket(
          size: size,
          corners: const <_BracketCorner>{_BracketCorner.bottomLeft},
        ),
      ),
      Positioned(
        bottom: inset,
        right: inset,
        child: _LoginBracket(
          size: size,
          corners: const <_BracketCorner>{_BracketCorner.bottomRight},
        ),
      ),
    ],
  );
}

enum _BracketCorner { topLeft, topRight, bottomLeft, bottomRight }

class _LoginBracket extends StatelessWidget {
  const _LoginBracket({required this.size, required this.corners});
  final double size;
  final Set<_BracketCorner> corners;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size(size, size),
    painter: _LoginBracketPainter(corners: corners),
  );
}

class _LoginBracketPainter extends CustomPainter {
  _LoginBracketPainter({required this.corners});
  final Set<_BracketCorner> corners;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = BlueprintColors.outline.withAlpha(100)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.square;
    double w = size.width, h = size.height;
    for (_BracketCorner c in corners) {
      switch (c) {
        case _BracketCorner.topLeft:
          canvas.drawLine(const Offset(0, 0), Offset(w, 0), paint);
          canvas.drawLine(const Offset(0, 0), Offset(0, h), paint);
        case _BracketCorner.topRight:
          canvas.drawLine(const Offset(0, 0), Offset(w, 0), paint);
          canvas.drawLine(Offset(w, 0), Offset(w, h), paint);
        case _BracketCorner.bottomLeft:
          canvas.drawLine(Offset(0, h), Offset(w, h), paint);
          canvas.drawLine(const Offset(0, 0), Offset(0, h), paint);
        case _BracketCorner.bottomRight:
          canvas.drawLine(Offset(0, h), Offset(w, h), paint);
          canvas.drawLine(Offset(w, 0), Offset(w, h), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_LoginBracketPainter old) => false;
}
