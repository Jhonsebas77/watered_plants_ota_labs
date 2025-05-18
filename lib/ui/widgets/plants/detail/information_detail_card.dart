part of com.watered_plants_ota_labs.app.widgets;

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
