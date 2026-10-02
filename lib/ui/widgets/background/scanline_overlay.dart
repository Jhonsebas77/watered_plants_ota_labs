part of com.watered_plants_ota_labs.app.widgets.background;

/// Línea de escaneo horizontal animada de arriba a abajo, en loop cada 8s.
///
class ScanlineOverlay extends StatefulWidget {
  const ScanlineOverlay({super.key});

  @override
  State<ScanlineOverlay> createState() => _ScanlineOverlayState();
}

class _ScanlineOverlayState extends State<ScanlineOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  static final Widget _line = Container(
    height: 2,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: <Color>[
          Colors.transparent,
          BlueprintColors.successGreen.withAlpha(30),
          BlueprintColors.successGreen.withAlpha(50),
          BlueprintColors.successGreen.withAlpha(30),
          Colors.transparent,
        ],
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  /// Solo se anima un `Transform.translate` (pintado, sin relayout del
  /// `Stack`) dentro de su propio `RepaintBoundary`, así cada frame no
  /// obliga a repintar el resto del login.
  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: IgnorePointer(
      child: RepaintBoundary(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double height = constraints.maxHeight;
            return Align(
              alignment: Alignment.topCenter,
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (BuildContext context, Widget? child) =>
                    Transform.translate(
                      offset: Offset(0, height * _ctrl.value),
                      child: child,
                    ),
                child: _line,
              ),
            );
          },
        ),
      ),
    ),
  );
}
