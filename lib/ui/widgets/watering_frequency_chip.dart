part of com.watered_plants_ota_labs.app.widgets;

class WateringFrequencyDaysChip extends StatelessWidget {
  const WateringFrequencyDaysChip({
    required this.wateringFrequencyDays,
    super.key,
  });
  final int wateringFrequencyDays;

  @override
  Widget build(BuildContext context) => Chip(
    label: Text(
      'Cada $wateringFrequencyDays días',
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    ),
    backgroundColor: Theme.of(context).colorScheme.primary,
    shape: RoundedRectangleBorder(
      side: const BorderSide(width: 3),
      borderRadius: BorderRadius.circular(32),
    ),
    avatar: Icon(
      Icons.water_drop_rounded,
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}
