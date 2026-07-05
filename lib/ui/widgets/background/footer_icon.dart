part of com.watered_plants_ota_labs.app.widgets.background;

class LoginFooterIcon extends StatelessWidget {
  const LoginFooterIcon({required this.icon, super.key});
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      border: Border.all(
        color: BlueprintColors.outline.withAlpha(80),
        width: 1,
      ),
    ),
    child: Icon(icon, size: 15, color: BlueprintColors.textDim),
  );
}
