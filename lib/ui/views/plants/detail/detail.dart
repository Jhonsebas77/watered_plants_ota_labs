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
    bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed:
            (plant.justWatered == false)
                ? () async {
                  FirebaseProvider firebaseProvider =
                      Provider.of<FirebaseProvider>(context, listen: false);
                  String newLastWateredDate = toYYYYMMdd(DateTime.now());
                  String newNextWateringDate = toYYYYMMdd(
                    DateTime.now().add(
                      Duration(days: plant.wateringFrequencyDays as int),
                    ),
                  );
                  firebaseProvider.isLoading = true;
                  if (plant.uuid != null) {
                    PlantModel _plant = PlantModel(
                      color: plant.color,
                      icon: plant.icon,
                      lastWateredDate: newLastWateredDate,
                      nextWateringDate: newNextWateringDate,
                      plantCare: plant.plantCare,
                      plantImage: plant.plantImage,
                      plantLocation: plant.plantLocation,
                      plantName: plant.plantName,
                      species: plant.species,
                      wateringFrequencyDays: plant.wateringFrequencyDays,
                      wateringSchedule: plant.wateringSchedule,
                      justWatered: true,
                    );
                    String _uuid = plant.uuid!;
                    await firebaseProvider.updatePlant(_uuid, _plant);
                    await firebaseProvider.getOnePlant(_uuid);
                  }
                  await firebaseProvider.getPlantsData();
                  firebaseProvider.isLoading = false;
                  if (context.mounted) Navigator.pop(context);
                }
                : null,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Regar planta'),
            SizedBox(width: 4),
            Icon(Icons.local_drink_rounded),
          ],
        ),
      ),
    ),
  );
}
