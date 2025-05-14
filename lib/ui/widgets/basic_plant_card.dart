part of com.watered_plants_ota_labs.app.widgets;

class BasicPlantCard extends StatelessWidget {
  const BasicPlantCard({
    required this.plantName,
    required this.nextWateringDate,
    required this.colorPlant,
    required this.plantIcon,
    required this.wateringFrequencyDays,
    super.key,
  });
  final String plantName;
  final String colorPlant;
  final String plantIcon;
  final String nextWateringDate;
  final int wateringFrequencyDays;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: getColorFromString(colorPlant),
            foregroundColor: Colors.black,
            child: Icon(getIconDataFromString(plantIcon)),
          ),
          const SizedBox(width: 4),
          Column(
            children: <Widget>[
              Text(plantName),
              const SizedBox(height: 4),
              Chip(
                label: Text(
                  'Cada $wateringFrequencyDays días',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 3),
                  borderRadius: BorderRadius.circular(32),
                ),
                avatar: Icon(
                  Icons.local_drink_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          Chip(
            label: Text(
              getDifferenceDaysBetweenTwoDates(nextWateringDate),
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(32),
            ),
            avatar: Icon(
              Icons.local_drink_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    ),
  );
}
