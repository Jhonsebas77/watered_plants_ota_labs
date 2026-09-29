part of com.watered_plants_ota_labs.app.widgets;

/// Variante de AppBar para pantallas pusheadas (formularios/detalle): botón
/// de retroceso + título, mismos tokens visuales que [BlueprintTopAppBar].
class BlueprintFormAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const BlueprintFormAppBar({required this.title, super.key, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: BlueprintColors.background,
    title: Text(title, style: AppTextStyles.titleLarge),
    actions: actions,
    shape: const Border(
      bottom: BorderSide(color: BlueprintColors.outlineVariant),
    ),
  );
}
