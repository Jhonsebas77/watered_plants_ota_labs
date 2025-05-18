part of com.watered_plants_ota_labs.app.widgets;

class BasicPlantCard extends StatelessWidget {
  const BasicPlantCard({required this.plant, super.key});
  final PlantModel plant;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute<Widget>(
          builder: (BuildContext context) => PlantDetailScreen(plant: plant),
        ),
      );
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            PlantAvatar(
              plantColorString: plant.color,
              plantIconString: plant.icon,
            ),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(plant.plantName),
                const SizedBox(height: 4),
                Text(plant.species, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    WateringFrequencyDaysChip(
                      wateringFrequencyDays: plant.wateringFrequencyDays,
                    ),
                    const SizedBox(width: 4),
                    NextWateringChip(nextWateringDate: plant.nextWateringDate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
