part of com.watered_plants_ota_labs.app.widgets;

/// TopAppBar del design system: avatar leading, headline, acciones trailing
/// y borde inferior de separación.
class BlueprintTopAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const BlueprintTopAppBar({
    super.key,
    this.headline = 'WATERED_PLANTS',
    this.actions = const <Widget>[],
  });

  final String headline;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: BlueprintColors.background,
      border: Border(bottom: BorderSide(color: BlueprintColors.outlineVariant)),
    ),
    child: SafeArea(
      bottom: false,
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          children: <Widget>[
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 16,
              backgroundColor: BlueprintColors.surfaceContainerLow,
              child: Image.asset('assets/ota_bg.png', fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                headline,
                style: AppTextStyles.titleLarge.copyWith(
                  color: BlueprintColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ...actions,
            const SizedBox(width: 4),
          ],
        ),
      ),
    ),
  );
}
