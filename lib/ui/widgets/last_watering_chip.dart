part of com.watered_plants_ota_labs.app.widgets;

class LastWateringChip extends StatelessWidget {
  const LastWateringChip({required this.lastWateredDate, super.key});
  final String lastWateredDate;

  @override
  Widget build(BuildContext context) => PlantChipBase(
    label: getWateringMessage(lastWateredDate),
    icon: Icon(Icons.history, color: Theme.of(context).colorScheme.onPrimary),
  );
}
