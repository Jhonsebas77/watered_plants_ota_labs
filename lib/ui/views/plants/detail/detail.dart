part of com.watered_plants_ota_labs.app.views;

class PlantDetailScreen extends StatelessWidget {
  const PlantDetailScreen({required this.plant, super.key});
  static const String route = '/plants/detail';
  final PlantModel plant;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        'Detalle de la planta',
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          SummaryDetailCard(plant: plant),
          const SizedBox(height: 8),
          WateringDetailCard(plant: plant),
          const SizedBox(height: 8),
          InformationDetailCard(plant: plant),
        ],
      ),
    ),
  );
}

class WateringDetailCard extends StatelessWidget {
  const WateringDetailCard({required this.plant, super.key});

  final PlantModel plant;

  @override
  Widget build(BuildContext context) => Card(
    child: Column(
      children: <Widget>[
        const Text('Horario de cuidado de las plantas'),
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
        const ItemTableDetailCare(
          label: 'Horario de riego',
          item: TimeWateringChip(timeIconString: 'd', timeWatering: 'Mañana'),
        ),
        ItemTableDetailCare(
          label: 'Último riego',
          item: LastWateringChip(lastWateredDate: plant.lastWateredDate),
        ),
      ],
    ),
  );
}

class ItemTableDetailCare extends StatelessWidget {
  const ItemTableDetailCare({
    required this.label,
    required this.item,
    super.key,
  });

  final String label;
  final Widget item;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[Text(label), item],
    ),
  );
}

class InformationDetailCard extends StatelessWidget {
  const InformationDetailCard({required this.plant, super.key});

  final PlantModel plant;

  @override
  Widget build(BuildContext context) => Card(
    child: Column(
      children: <Widget>[
        const Text('Información de la planta'),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(children: <Widget>[Text(plant.plantCare)]),
        ),
      ],
    ),
  );
}

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
