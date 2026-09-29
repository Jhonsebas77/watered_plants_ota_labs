part of com.watered_plants_ota_labs.app.widgets;

class SummaryDetailCard extends StatelessWidget {
  const SummaryDetailCard({required this.plant, super.key});

  final PlantModel plant;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          PlantImage(
            plantImage: plant.plantImage,
            plantColorString: plant.color,
            plantIconString: plant.icon,
            displayAvatar: plant.plantImage.isNotEmpty,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  plant.plantName,
                  style: AppTextStyles.titleLarge,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Text(plant.species, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
