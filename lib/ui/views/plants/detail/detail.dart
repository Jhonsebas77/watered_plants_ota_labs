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

  /// Versión más reciente de la planta en el provider (p. ej. tras editarla
  /// desde el formulario); si ya no está, usa la que se recibió al abrir.
  PlantModel _plantFrom(FirebaseProvider provider) =>
      provider.plantById(widget.plant.uuid) ?? widget.plant;

  Future<void> _waterPlant() async {
    FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(
      context,
      listen: false,
    );
    PlantModel plant = _plantFrom(firebaseProvider);
    setState(() => _watering = true);
    bool updated = await firebaseProvider.waterPlant(plant);
    if (!mounted) return;
    setState(() => _watering = false);
    if (!updated) {
      showErrorSnackBar(context, 'No se pudo regar ${plant.plantName}');
      return;
    }
    showSuccessSnackBar(context, '${plant.plantName} regada');
    Navigator.pop(context);
  }

  Future<void> _confirmDelete() async {
    FirebaseProvider firebaseProvider = Provider.of<FirebaseProvider>(
      context,
      listen: false,
    );
    PlantModel plant = _plantFrom(firebaseProvider);
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
    bool deleted = await firebaseProvider.deletePlant(plant);
    if (!mounted) return;
    setState(() => _deleting = false);
    if (!deleted) {
      showErrorSnackBar(context, 'No se pudo eliminar ${plant.plantName}');
      return;
    }
    showInformationSnackBar(
      context,
      '${plant.plantName} descansa ahora en el cementerio',
      action: SnackBarAction(
        label: 'DESHACER',
        textColor: BlueprintColors.accentOrange,
        // Usa el provider y no el context: la pantalla ya se cerró cuando se
        // toca la acción.
        onPressed: () {
          DeadPlantModel? deadPlant = firebaseProvider.deadPlantById(
            plant.uuid,
          );
          if (deadPlant != null) {
            firebaseProvider.revivePlant(deadPlant);
          }
        },
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    PlantModel plant = _plantFrom(Provider.of<FirebaseProvider>(context));
    bool busy = _deleting || _watering;
    return BlueprintScaffold(
      appBar: BlueprintFormAppBar(
        title: 'Detalle de la planta',
        actions: <Widget>[
          IconButton(
            tooltip: 'Editar planta',
            onPressed: busy
                ? null
                : () {
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
            onPressed: busy ? null : _confirmDelete,
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
                label: plant.justWatered == false
                    ? 'REGAR PLANTA'
                    : 'YA REGADA',
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
}
