part of com.watered_plants_ota_labs.app.widgets;

class NextWateringChip extends StatelessWidget {
  const NextWateringChip({required this.nextWateringDate, super.key});
  final String nextWateringDate;

  @override
  Widget build(BuildContext context) {
    DateTime? date = toDateTime(nextWateringDate);
    if (date == null) {
      return PlantChipBase(
        label: getWateringMessage(nextWateringDate, isNextWatering: true),
        icon: Icons.local_drink_rounded,
        color: BlueprintColors.textMuted,
      );
    }
    return CountdownChip(nextWateringDate: date, now: DateTime.now());
  }
}
