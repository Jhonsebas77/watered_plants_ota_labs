part of com.watered_plants_ota_labs.app.widgets;

class BasicPlantCard extends StatelessWidget {
  const BasicPlantCard({required this.plant, super.key});
  final PlantModel plant;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      CustomNavigator().push(context, PlantDetailScreen(plant: plant));
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: BlueprintColors.surfaceContainerLow,
        border: Border.all(
          color: BlueprintColors.outline.withAlpha(40),
          width: 1,
        ),
      ),
      child: Row(
        children: <Widget>[
          PlantImageAvatar(plant: plant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: getColorFromString(plant.color),
                      ),
                      child: const SizedBox(height: 8, width: 8),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        plant.plantName.toUpperCase(),
                        style: GoogleFonts.jetBrainsMono(
                          color: BlueprintColors.textPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.water_drop_rounded,
                      size: 10,
                      color: BlueprintColors.textDim,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Cada ${plant.wateringFrequencyDays} días',
                      style: CustomStyles().customLabelTextStyle(
                        size: 9,
                        spacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.location_on,
                      size: 10,
                      color: BlueprintColors.textDim,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        plant.plantLocation.toUpperCase(),
                        style: CustomStyles().customLabelTextStyle(
                          size: 9,
                          spacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                getWateringMessage(plant.nextWateringDate, isNextWatering: true),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  color: getWateringChipColor(context, plant.nextWateringDate),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.right,
              ),
              if (plant.lastWateredDate == toYYYYMMdd(DateTime.now()) &&
                  (plant.justWatered ?? false))
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.local_drink_rounded,
                        size: 10,
                        color: BlueprintColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Regada',
                        style: CustomStyles().customLabelTextStyle(
                          color: BlueprintColors.success,
                          size: 9,
                          spacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
