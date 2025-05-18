part of com.watered_plants_ota_labs.app.widgets;

class PlantChipBase extends StatelessWidget {
  const PlantChipBase({required this.label, required this.icon, super.key});
  final String label;
  final Icon icon;
  @override
  Widget build(BuildContext context) => Chip(
    label: Text(
      label,
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    ),
    backgroundColor: Theme.of(context).colorScheme.primary,
    shape: RoundedRectangleBorder(
      side: BorderSide(width: 3, color: Theme.of(context).colorScheme.primary),
      borderRadius: BorderRadius.circular(32),
    ),
    avatar: icon,
  );
}
