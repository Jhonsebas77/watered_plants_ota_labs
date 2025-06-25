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
      padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8, right: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          PlantImageAvatar(plant: plant),
          const SizedBox(width: 16),
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
                      child: const SizedBox(height: 14, width: 14),
                    ),
                    const SizedBox(width: 4,),
                    Text(
                      plant.plantName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SimpleChipWithIcon(
                  iconData: Icons.water_drop_rounded,
                  text: 'Cada ${plant.wateringFrequencyDays} días',
                ),
                SimpleChipWithIcon(
                  iconData: Icons.location_on,
                  text: plant.plantLocation,
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                getWateringMessage(
                  plant.nextWateringDate,
                  isNextWatering: true,
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: getWateringChipColor(context, plant.nextWateringDate),
                  fontWeight: FontWeight.normal,
                ),
              ),
              if (plant.lastWateredDate == toYYYYMMdd(DateTime.now()) &&
                  (plant.justWatered ?? false))
                const SimpleChipWithIcon(
                  iconData: Icons.local_drink_rounded,
                  text: 'Regada',
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
