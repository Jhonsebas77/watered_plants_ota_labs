part of com.watered_plants_ota_labs.app.views;

class PlantDetailScreen extends StatefulWidget {
  const PlantDetailScreen({required this.plant, super.key});
  static const String route = '/plants/detail';
  final PlantModel plant;

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  bool _watering = false;
  bool _deleting = false;

  PlantModel get plant => widget.plant;

  Future<void> _waterPlant() async {
    setState(() => _watering = true);
    FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(
      context,
      listen: false,
    );
    String newLastWateredDate = toYYYYMMdd(DateTime.now());
    String newNextWateringDate = toYYYYMMdd(
      DateTime.now().add(Duration(days: plant.wateringFrequencyDays as int)),
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
    if (!mounted) return;
    showSuccessSnackBar(context, '${plant.plantName} regada');
    Navigator.pop(context);
  }

  Future<void> _confirmDelete() async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Eliminar planta'),
        content: Text(
          '¿Seguro que quieres eliminar ${plant.plantName}? '
          'Irá al cementerio de plantas y podrás revivirla desde allí.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCELAR'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: BlueprintColors.danger,
              foregroundColor: BlueprintColors.textPrimary,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _deleting = true);
    bool deleted = await Provider.of<FirebaseProvider>(
      context,
      listen: false,
    ).deletePlant(plant);
    if (!mounted) return;
    setState(() => _deleting = false);
    if (!deleted) {
      showErrorSnackBar(context, 'No se pudo eliminar ${plant.plantName}');
      return;
    }
    showInformationSnackBar(
      context,
      '${plant.plantName} descansa ahora en el cementerio',
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => BlueprintScaffold(
    appBar: BlueprintFormAppBar(
      title: 'Detalle de la planta',
      actions: <Widget>[
        IconButton(
          tooltip: 'Editar planta',
          onPressed: () {
            CustomNavigator().push(
              context,
              PlantFormView(isUpdate: true, plant: plant),
            );
          },
          icon: const Icon(
            Icons.edit_document,
            color: BlueprintColors.textPrimary,
          ),
        ),
        IconButton(
          tooltip: 'Eliminar planta',
          onPressed: _deleting || _watering ? null : _confirmDelete,
          icon: _deleting
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(
                  Icons.delete_outline_rounded,
                  color: BlueprintColors.danger,
                ),
        ),
      ],
    ),
    body: BlueprintFormBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SummaryDetailCard(plant: plant),
          const SizedBox(height: 16),
          WateringDetailCard(plant: plant),
          const SizedBox(height: 16),
          InformationDetailCard(plant: plant),
        ],
      ),
    ),
    bottomNavigationBar: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: Breakpoints.formMaxWidth,
            ),
            child: BlueprintPrimaryButton(
              label: plant.justWatered == false ? 'REGAR PLANTA' : 'YA REGADA',
              icon: Icons.local_drink_rounded,
              loading: _watering,
              onPressed: plant.justWatered == false ? _waterPlant : null,
            ),
          ),
        ),
      ),
    ),
  );
}
