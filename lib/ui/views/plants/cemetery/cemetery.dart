part of com.watered_plants_ota_labs.app.views;

/// "Cementerio de plantas": lista las plantas eliminadas desde el detalle.
/// Desde aquí se pueden revivir (vuelven a la lista principal) o borrar
/// para siempre.
class PlantCemeteryView extends StatefulWidget {
  const PlantCemeteryView({super.key});
  static const String route = '/plants/cemetery';

  @override
  State<PlantCemeteryView> createState() => _PlantCemeteryViewState();
}

class _PlantCemeteryViewState extends State<PlantCemeteryView> {
  /// uuid de la planta con una operación en curso, para bloquear sus botones.
  String? _busyId;

  Future<void> _revive(DeadPlantModel deadPlant) async {
    setState(() => _busyId = deadPlant.plant.uuid);
    bool revived = await Provider.of<FirebaseProvider>(
      context,
      listen: false,
    ).revivePlant(deadPlant);
    if (!mounted) return;
    setState(() => _busyId = null);
    if (revived) {
      showSuccessSnackBar(context, '${deadPlant.plant.plantName} ha revivido');
    } else {
      showErrorSnackBar(
        context,
        'No se pudo revivir ${deadPlant.plant.plantName}',
      );
    }
  }

  Future<void> _confirmBuryForever(DeadPlantModel deadPlant) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Borrar para siempre'),
        content: Text(
          '${deadPlant.plant.plantName} se borrará definitivamente y no '
          'podrás recuperarla.',
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
            child: const Text('BORRAR'),
          ),
        ],
      ),
    );
    String? customId = deadPlant.plant.uuid;
    if (confirmed != true || customId == null || !mounted) return;
    setState(() => _busyId = customId);
    bool buried = await Provider.of<FirebaseProvider>(
      context,
      listen: false,
    ).buryPlantForever(customId);
    if (!mounted) return;
    setState(() => _busyId = null);
    if (buried) {
      showInformationSnackBar(
        context,
        '${deadPlant.plant.plantName} fue borrada para siempre',
      );
    } else {
      showErrorSnackBar(
        context,
        'No se pudo borrar ${deadPlant.plant.plantName}',
      );
    }
  }

  @override
  Widget build(BuildContext context) => BlueprintScaffold(
    appBar: const BlueprintFormAppBar(title: 'Cementerio de plantas'),
    body: Consumer<FirebaseProvider>(
      builder: (BuildContext context, FirebaseProvider provider, Widget? _) {
        if (provider.isLoading) {
          return const PlantListSkeleton();
        }
        if (provider.deadPlants.isEmpty) {
          return _buildEmptyState();
        }
        List<DeadPlantModel> deadPlants = provider.deadPlants.toList()
          ..sort(
            (DeadPlantModel a, DeadPlantModel b) =>
                (b.getDeathDate ?? DateTime(0)).compareTo(
                  a.getDeathDate ?? DateTime(0),
                ),
          );
        return ResponsiveContainer(
          maxWidth: Breakpoints.formMaxWidth,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              DetailSectionTitle(label: 'En memoria (${deadPlants.length})'),
              const SizedBox(height: 12),
              ...deadPlants.map(
                (DeadPlantModel deadPlant) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DeadPlantCard(
                    deadPlant: deadPlant,
                    onRevive: _busyId == null ? () => _revive(deadPlant) : null,
                    onBuryForever: _busyId == null
                        ? () => _confirmBuryForever(deadPlant)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  Widget _buildEmptyState() => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: BlueprintColors.surfaceContainerLow,
          border: Border.all(color: BlueprintColors.outlineVariant, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.local_florist,
              color: BlueprintColors.successGreen,
              size: 32,
            ),
            const SizedBox(height: 16),
            Text(
              'CEMETERY_EMPTY',
              style: AppTextStyles.label(
                color: BlueprintColors.successGreen,
                size: 11,
                spacing: 2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'TODAS TUS PLANTAS SIGUEN VIVAS',
              style: AppTextStyles.label(size: 9, spacing: 1),
            ),
          ],
        ),
      ),
    ),
  );
}
