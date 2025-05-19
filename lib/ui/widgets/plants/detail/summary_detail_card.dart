part of com.watered_plants_ota_labs.app.widgets;

class SummaryDetailCard extends StatelessWidget {
  const SummaryDetailCard({required this.plant, super.key});

  final PlantModel plant;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (plant.plantImage.isNotEmpty)
            PlantImage(plantImage: plant.plantImage)
          else
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              foregroundColor: Colors.black,
              child: const Icon(Icons.photo),
            ),
          Column(
            children: <Widget>[
              Text(
                plant.plantName,
                style: Headings.h5.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              Text(
                plant.species,
                style: Paragraphs.mediumSemiBold.copyWith(color: Colors.grey),
              ),
            ],
          ),
          PlantAvatar(
            plantColorString: plant.color,
            plantIconString: plant.icon,
          ),
        ],
      ),
    ),
  );
}
