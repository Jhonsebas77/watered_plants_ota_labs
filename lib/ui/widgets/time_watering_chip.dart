part of com.watered_plants_ota_labs.app.widgets;

class TimeWateringChip extends StatelessWidget {
  const TimeWateringChip({required this.timeWatering, super.key});

  final String timeWatering;

  @override
  Widget build(BuildContext context) => PlantChipBase(
    label: getWateringScheduleFromString(timeWatering),
    icon: Icon(
      getIconTimeDataFromString(timeWatering),
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}
