part of com.watered_plants_ota_labs.app.widgets;

class NextWateringChip extends StatelessWidget {
  const NextWateringChip({required this.nextWateringDate, super.key});
  final String nextWateringDate;

  @override
  Widget build(BuildContext context) => PlantChipBase(
    label: getWateringMessage(nextWateringDate),
    icon: Icon(
      Icons.local_drink_rounded,
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}
