part of com.watered_plants_ota_labs.app.widgets;

class TimeWateringChip extends StatelessWidget {
  const TimeWateringChip({
    required this.timeIconString,
    required this.timeWatering,
    super.key,
  });
  final String timeIconString;
  final String timeWatering;

  @override
  Widget build(BuildContext context) => PlantChipBase(
    label: timeWatering,
    icon: Icon(
      getIconTimeDataFromString(timeIconString),
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}
