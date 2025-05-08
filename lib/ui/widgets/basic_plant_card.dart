part of com.watered_plants_ota_labs.app.widgets;

class BasicPlantCard extends StatelessWidget {
  const BasicPlantCard({
    required this.plantName,
    required this.nextWateringDate,
    required this.wateringFrequencyDays,
    super.key,
  });
  final String plantName;
  final String nextWateringDate;
  final int wateringFrequencyDays;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const CircleAvatar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.green,
            child: Icon(Icons.emoji_nature),
          ),
          const SizedBox(width: 4),
          Column(
            children: <Widget>[
              Text(plantName),
              const SizedBox(height: 4),
              Text('Agua cada: $wateringFrequencyDays días'),
            ],
          ),
          const SizedBox(width: 4),
          Text('Siguiente riego:\n$nextWateringDate'),
        ],
      ),
    ),
  );
}
