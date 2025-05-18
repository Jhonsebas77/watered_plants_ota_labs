part of com.watered_plants_ota_labs.app.widgets;

class WateringFrequencyDaysChip extends StatelessWidget {
  const WateringFrequencyDaysChip({
    required this.wateringFrequencyDays,
    super.key,
  });
  final int wateringFrequencyDays;

  @override
  Widget build(BuildContext context) => PlantChipBase(
    label: 'Cada $wateringFrequencyDays días',
    icon: Icon(
      Icons.water_drop_rounded,
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}
