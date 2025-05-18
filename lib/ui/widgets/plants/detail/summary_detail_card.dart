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
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
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
                  height: 96,
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
