part of com.watered_plants_ota_labs.app.widgets;

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
    this.color,
    this.thickness = 1,
    this.dashWidth = 7,
    this.dashSpace = 5,
    this.isDash = false,
    this.isVertical = false,
  });
  final Color? color;
  final double thickness;
  final double dashWidth;
  final double dashSpace;
  final bool isDash;
  final bool isVertical;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) => SizedBox(
      height: isVertical ? constraints.maxHeight : thickness,
      width: isVertical ? thickness : constraints.maxWidth,
      child: CustomPaint(
        painter: DividerPainter(
          lineSize: isVertical ? constraints.maxHeight : constraints.maxWidth,
          isDash: isDash,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
          thickness: thickness,
          color: color,
          isVertical: isVertical,
        ),
      ),
    ),
  );
}

class DividerPainter extends CustomPainter {
  const DividerPainter({
    required this.lineSize,
    this.color,
    this.dashWidth = 5,
    this.dashSpace = 5,
    this.thickness = 1,
    this.isDash = false,
    this.isVertical = false,
  });

  final double? lineSize;
  final Color? color;
  final double dashWidth;
  final double dashSpace;
  final double thickness;
  final bool isDash;
  final bool isVertical;

  @override
  void paint(Canvas canvas, Size size) {
    // Un solo Paint para todos los trazos (antes se creaba uno por guion).
    Paint paint = Paint()
      ..color = color!
      ..strokeWidth = thickness;

    double max = lineSize!;
    double startX = 0;
    double startY = 0;

    if (isDash) {
      if (isVertical) {
        while (max >= 0) {
          canvas.drawLine(
            Offset(size.width * 0.50, startY),
            Offset(size.width * 0.50, startY + dashWidth),
            paint,
          );
          double space = dashSpace + dashWidth;
          startY += space;
          max -= space;
        }
      } else {
        while (max >= 0) {
          canvas.drawLine(
            Offset(startX, size.height * 0.50),
            Offset(startX + dashWidth, size.height * 0.50),
            paint,
          );
          double space = dashSpace + dashWidth;
          startX += space;
          max -= space;
        }
      }
    } else {
      if (isVertical) {
        canvas.drawLine(
          Offset(size.width * 0.50, startY),
          Offset(size.width * 0.50, lineSize!),
          paint,
        );
      } else {
        canvas.drawLine(
          Offset(startX, size.height * 0.50),
          Offset(lineSize!, size.height * 0.50),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DividerPainter oldDelegate) =>
      color != oldDelegate.color ||
      dashWidth != oldDelegate.dashWidth ||
      dashSpace != oldDelegate.dashSpace ||
      thickness != oldDelegate.thickness ||
      isDash != oldDelegate.isDash ||
      isVertical != oldDelegate.isVertical ||
      lineSize != oldDelegate.lineSize;
}

class CustomDividerWithLabel extends StatelessWidget {
  const CustomDividerWithLabel({
    required this.label,
    required this.color,
    super.key,
  });

  final String label;
  final Color? color;
  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          color: color,
          height: 1.2,
        ),
      ),
      const SizedBox(width: 16),
      Expanded(child: CustomDivider(color: color)),
    ],
  );
}
