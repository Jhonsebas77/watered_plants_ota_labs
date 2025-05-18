part of com.watered_plants_ota_labs.app.widgets;

class WateringDetailCard extends StatelessWidget {
  const WateringDetailCard({required this.plant, super.key});

  final PlantModel plant;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Text(
            'Horario de cuidado de las plantas',
            style: Headings.h6.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
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
