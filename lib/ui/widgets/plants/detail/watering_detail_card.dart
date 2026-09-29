part of com.watered_plants_ota_labs.app.widgets;

class WateringDetailCard extends StatelessWidget {
  const WateringDetailCard({required this.plant, super.key});

  final PlantModel plant;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const DetailSectionTitle(label: 'Horario de cuidado'),
          const SizedBox(height: 8),
          ItemTableDetailCare(
            label: 'Frecuencia de riego',
            item: WateringFrequencyDaysChip(
              wateringFrequencyDays: plant.wateringFrequencyDays,
            ),
          ),
          ItemTableDetailCare(
            label: 'Siguiente riego',
            item: NextWateringChip(nextWateringDate: plant.nextWateringDate),
          ),
          ItemTableDetailCare(
            label: 'Horario de riego',
            item: TimeWateringChip(timeWatering: plant.wateringSchedule),
          ),
          ItemTableDetailCare(
            label: 'Último riego',
            item: LastWateringChip(lastWateredDate: plant.lastWateredDate),
          ),
        ],
      ),
    ),
  );
}
