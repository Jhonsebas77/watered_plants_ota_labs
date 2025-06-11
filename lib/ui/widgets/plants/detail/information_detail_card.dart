part of com.watered_plants_ota_labs.app.widgets;

class InformationDetailCard extends StatelessWidget {
  const InformationDetailCard({required this.plant, super.key});

  final PlantModel plant;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: <Widget>[
          Text(
            'Información de la planta',
            style: Headings.h6.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(plant.plantCare),
                  const SizedBox(height: 24),
                  LocationPlantChip(plantLocation: plant.plantLocation),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
