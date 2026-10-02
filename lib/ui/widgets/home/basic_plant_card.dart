part of com.watered_plants_ota_labs.app.widgets;

class BasicPlantCard extends StatefulWidget {
  const BasicPlantCard({required this.plant, super.key});
  final PlantModel plant;

  @override
  State<BasicPlantCard> createState() => _BasicPlantCardState();
}

class _BasicPlantCardState extends State<BasicPlantCard> {
  bool _watering = false;

  PlantModel get plant => widget.plant;

  /// Riego rápido desde la lista, sin tener que entrar al detalle.
  Future<void> _waterPlant() async {
    setState(() => _watering = true);
    bool updated = await Provider.of<FirebaseProvider>(
      context,
      listen: false,
    ).waterPlant(plant);
    if (!mounted) return;
    setState(() => _watering = false);
    if (updated) {
      showSuccessSnackBar(context, '${plant.plantName} regada');
    } else {
      showErrorSnackBar(context, 'No se pudo regar ${plant.plantName}');
    }
  }

  @override
  Widget build(BuildContext context) => Material(
    color: BlueprintColors.surfaceContainerLow,
    child: InkWell(
      onTap: () {
        CustomNavigator().push(context, PlantDetailScreen(plant: plant));
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
        decoration: BoxDecoration(
          border: Border.all(color: BlueprintColors.outlineVariant, width: 1),
        ),
        child: Row(
          children: <Widget>[
            PlantImageAvatar(plant: plant),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: getColorFromString(plant.color),
                        ),
                        child: const SizedBox(height: 8, width: 8),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          plant.plantName.toUpperCase(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: BlueprintColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.water_drop_rounded,
                        size: 12,
                        color: BlueprintColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Cada ${plant.wateringFrequencyDays} días',
                        style: AppTextStyles.label(size: 11, spacing: 0.5),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: BlueprintColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          plant.plantLocation.toUpperCase(),
                          style: AppTextStyles.label(size: 11, spacing: 0.5),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  getWateringMessage(
                    plant.nextWateringDate,
                    isNextWatering: true,
                  ),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 12,
                    color: wateringStatusColor(plant.nextWateringDate),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.right,
                ),
                if (plant.lastWateredDate == toYYYYMMdd(DateTime.now()) &&
                    (plant.justWatered ?? false))
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Icon(
                          Icons.local_drink_rounded,
                          size: 12,
                          color: BlueprintColors.successGreen,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Regada',
                          style: AppTextStyles.label(
                            color: BlueprintColors.successGreen,
                            size: 11,
                            spacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            if (plant.justWatered != true)
              IconButton(
                tooltip: 'Regar ${plant.plantName}',
                visualDensity: VisualDensity.compact,
                onPressed: _watering ? null : _waterPlant,
                icon: _watering
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        Icons.water_drop_outlined,
                        color: BlueprintColors.accentOrange,
                      ),
              )
            else
              const SizedBox(width: 8),
          ],
        ),
      ),
    ),
  );
}
