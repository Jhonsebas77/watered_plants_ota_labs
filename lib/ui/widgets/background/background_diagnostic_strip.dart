part of com.watered_plants_ota_labs.app.widgets.background;

/// Barra de acento animada del footer del login (rebota de izquierda a
/// derecha en loop).
class DiagnosticStrip extends StatefulWidget {
  const DiagnosticStrip({super.key});

  @override
  State<DiagnosticStrip> createState() => _DiagnosticStripState();
}

class _DiagnosticStripState extends State<DiagnosticStrip>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  static final Decoration _barDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: <Color>[
        Colors.transparent,
        BlueprintColors.accentOrange.withAlpha(200),
        BlueprintColors.accentOrange,
        BlueprintColors.accentOrange.withAlpha(200),
        Colors.transparent,
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _anim = Tween<double>(
      begin: -0.4,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// Solo se anima un `Transform.translate` (sin relayout) dentro de su
  /// propio `RepaintBoundary`; el fondo y la barra se construyen una vez.
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 2,
    child: RepaintBoundary(
      child: ClipRect(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double totalWidth = constraints.maxWidth;
            double barWidth = totalWidth * 0.35;

            return Stack(
              children: <Widget>[
                const Positioned.fill(
                  child: ColoredBox(color: BlueprintColors.gridLine),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: barWidth,
                  child: AnimatedBuilder(
                    animation: _anim,
                    builder: (BuildContext context, Widget? child) =>
                        Transform.translate(
                          offset: Offset(totalWidth * _anim.value, 0),
                          child: child,
                        ),
                    child: DecoratedBox(decoration: _barDecoration),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}
