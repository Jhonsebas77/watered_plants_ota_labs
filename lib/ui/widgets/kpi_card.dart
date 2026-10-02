part of com.watered_plants_ota_labs.app.widgets;

class KpiCard extends StatelessWidget {
  const KpiCard({
    required this.label,
    required this.value,
    super.key,
    this.subtitle,
  });

  final String label;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: BlueprintColors.surfaceContainerLow,
      border: Border.all(color: BlueprintColors.outlineVariant),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          label,
          style: AppTextStyles.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: AppTextStyles.titleLarge.copyWith(
            color: BlueprintColors.accentOrange,
          ),
        ),
        if (subtitle != null) ...<Widget>[
          const SizedBox(height: 2),
          Text(subtitle!, style: AppTextStyles.bodySmall),
        ],
      ],
    ),
  );
}
