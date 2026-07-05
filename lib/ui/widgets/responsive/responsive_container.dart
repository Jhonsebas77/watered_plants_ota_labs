part of com.watered_plants_ota_labs.app.widgets;

/// Layout breakpoints used to adapt mobile-first screens to wider web and
/// desktop viewports.
class Breakpoints {
  const Breakpoints._();

  /// Upper bound for phone-sized layouts (single column, edge-to-edge).
  static const double mobile = 600;

  /// Upper bound for tablet-sized layouts.
  static const double tablet = 900;

  /// Threshold from which layouts are treated as desktop.
  static const double desktop = 1200;

  /// Comfortable reading width for forms and detail screens.
  static const double content = 720;

  /// Width cap for the login form so it doesn't stretch on wide screens.
  static const double compact = 420;

  /// Minimum width a plant card should have inside a responsive grid.
  static const double plantCardMinWidth = 340;
}

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
