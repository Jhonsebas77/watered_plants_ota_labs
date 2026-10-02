part of com.watered_plants_ota_labs.app.widgets;

/// Tarjeta de una planta en el cementerio: misma estructura que
/// [BasicPlantCard] pero con la imagen en escala de grises, la fecha de
/// eliminación y las acciones de revivir / borrar para siempre.
class DeadPlantCard extends StatelessWidget {
  const DeadPlantCard({
    required this.deadPlant,
    required this.onRevive,
    required this.onBuryForever,
    super.key,
  });

  final DeadPlantModel deadPlant;
  final VoidCallback? onRevive;
  final VoidCallback? onBuryForever;

  static const ColorFilter _grayscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0, //
  ]);

  PlantModel get plant => deadPlant.plant;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: BlueprintColors.surfaceContainerLow,
      border: Border.all(color: BlueprintColors.outlineVariant, width: 1),
    ),
    child: Row(
      children: <Widget>[
        ColorFiltered(
          colorFilter: _grayscale,
          child: Opacity(opacity: 0.7, child: PlantImageAvatar(plant: plant)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                plant.plantName.toUpperCase(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: BlueprintColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  decoration: TextDecoration.lineThrough,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.heart_broken_outlined,
                    size: 10,
                    color: BlueprintColors.danger,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      deadPlant.deathDate.isNotEmpty
                          ? 'R.I.P. ${deadPlant.deathDate}'
                          : 'R.I.P.',
                      style: AppTextStyles.label(
                        color: BlueprintColors.danger,
                        size: 9,
                        spacing: 0.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (plant.species.isNotEmpty) ...<Widget>[
                const SizedBox(height: 2),
                Text(
                  plant.species,
                  style: AppTextStyles.label(size: 9, spacing: 0.5),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        IconButton(
          tooltip: 'Revivir planta',
          onPressed: onRevive,
          icon: const Icon(
            Icons.restore_rounded,
            color: BlueprintColors.successGreen,
          ),
        ),
        IconButton(
          tooltip: 'Borrar para siempre',
          onPressed: onBuryForever,
          icon: const Icon(
            Icons.delete_forever_outlined,
            color: BlueprintColors.danger,
          ),
        ),
      ],
    ),
  );
}
