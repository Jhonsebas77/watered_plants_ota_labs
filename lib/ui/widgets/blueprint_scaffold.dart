part of com.watered_plants_ota_labs.app.widgets;

/// Scaffold compartido: pinta el grid overlay del design system detrás del
/// contenido. Usar en vez de [Scaffold] en cada pantalla para heredar el
/// fondo/grid de forma consistente.
class BlueprintScaffold extends StatelessWidget {
  const BlueprintScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: BlueprintColors.background,
    resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    appBar: appBar,
    floatingActionButton: floatingActionButton,
    bottomNavigationBar: bottomNavigationBar,
    body: Stack(
      children: <Widget>[
        const Positioned.fill(
          child: CustomPaint(painter: GridOverlayPainter()),
        ),
        body,
      ],
    ),
  );
}
