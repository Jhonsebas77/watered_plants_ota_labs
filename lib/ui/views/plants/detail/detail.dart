part of com.watered_plants_ota_labs.app.views;

class PlantDetailScreen extends StatelessWidget {
  const PlantDetailScreen({required this.plant, super.key});
  static const String route = '/plants/detail';
  final PlantModel plant;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Detalle de la planta'),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            CustomNavigator().push(
              context,
              PlantFormView(isUpdate: true, plant: plant),
            );
          },
          icon: const Icon(Icons.edit_document),
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Padding(
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
    ),
  );
}
