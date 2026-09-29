part of com.watered_plants_ota_labs.app.widgets;

/// Centers its [child] and caps its width so mobile-first layouts stay legible
/// on wide web/desktop viewports instead of stretching edge-to-edge.
///
/// Fills the available height, so it can safely wrap scroll views or columns
/// that rely on [Expanded].
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    required this.child,
    this.maxWidth = Breakpoints.content,
    this.padding,
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: padding != null ? Padding(padding: padding!, child: child) : child,
    ),
  );
}
