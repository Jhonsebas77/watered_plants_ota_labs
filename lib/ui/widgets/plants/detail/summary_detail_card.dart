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
          Image.network(
            plant.plantImage,
            height: 96,
            fit: BoxFit.cover,
            loadingBuilder: (
              BuildContext context,
              Widget image,
              ImageChunkEvent? loadingProgress,
            ) {
              if (loadingProgress == null) return image;
              return SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(
                    value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                  ),
                ),
              );
            },
          ),
          Column(
            children: <Widget>[
              Text(plant.plantName),
              Text(plant.species, style: const TextStyle(color: Colors.grey)),
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
