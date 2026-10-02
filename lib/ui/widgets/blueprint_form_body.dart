part of com.watered_plants_ota_labs.app.widgets;

/// Cuerpo scrolleable de los formularios: centra el contenido y lo limita a
/// [Breakpoints.formMaxWidth] para que en web/tablet los inputs no se estiren
/// a todo el ancho de la ventana. En móvil no cambia nada: la pantalla ya es
/// más angosta que el límite.
class BlueprintFormBody extends StatelessWidget {
  const BlueprintFormBody({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: padding,
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Breakpoints.formMaxWidth),
        child: child,
      ),
    ),
  );
}
