part of com.watered_plants_ota_labs.app.widgets.background;

class BackgroundDiagnosticStrip extends StatefulWidget {
  const BackgroundDiagnosticStrip({super.key});

  @override
  State<BackgroundDiagnosticStrip> createState() =>
      _BackgroundDiagnosticStripState();
}

class _BackgroundDiagnosticStripState extends State<BackgroundDiagnosticStrip>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

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

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 2,
    child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double totalWidth = constraints.maxWidth;
        double barWidth = totalWidth * 0.35;
        return AnimatedBuilder(
          animation: _anim,
          builder: (_, __) {
            double left = totalWidth * _anim.value;
            return Stack(
              children: <Widget>[
                Container(color: BlueprintColors.gridLine),
                Positioned(
                  left: left,
                  top: 0,
                  bottom: 0,
                  width: barWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.transparent,
                          BlueprintColors.primaryContainer.withAlpha(200),
                          BlueprintColors.primaryContainer,
                          BlueprintColors.primaryContainer.withAlpha(200),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ),
  );
}
