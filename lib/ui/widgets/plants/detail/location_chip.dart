part of com.watered_plants_ota_labs.app.widgets;

class LocationPlantChip extends StatelessWidget {
  const LocationPlantChip({required this.plantLocation, super.key});
  final String plantLocation;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const CustomDivider(color: BlueprintColors.outlineVariant),
      const SizedBox(height: 12),
      Text('UBICACIÓN', style: AppTextStyles.label(spacing: 2)),
      const SizedBox(height: 6),
      Row(
        children: <Widget>[
          const Icon(
            Icons.location_on,
            size: 16,
            color: BlueprintColors.accentOrange,
          ),
          const SizedBox(width: 6),
          Expanded(child: Text(plantLocation, style: AppTextStyles.bodyMedium)),
        ],
      ),
    ],
  );
}
