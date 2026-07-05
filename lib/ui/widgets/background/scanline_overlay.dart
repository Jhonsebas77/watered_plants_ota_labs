part of com.watered_plants_ota_labs.app.widgets.background;

class ScanlineOverlay extends StatefulWidget {
  const ScanlineOverlay({super.key});

  @override
  State<ScanlineOverlay> createState() => _ScanlineOverlayState();
}

class _ScanlineOverlayState extends State<ScanlineOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _anim = Tween<double>(begin: 0, end: 1).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _anim,
    builder:
        (BuildContext context, _) => Positioned(
          top: MediaQuery.of(context).size.height * _anim.value,
          left: 0,
          right: 0,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.transparent,
                  const Color(0xFF00FF9D).withAlpha(30),
                  const Color(0xFF00FF9D).withAlpha(50),
                  const Color(0xFF00FF9D).withAlpha(30),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
  );
}
