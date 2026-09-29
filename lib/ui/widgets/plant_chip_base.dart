part of com.watered_plants_ota_labs.app.widgets;

/// Chip Blueprint de dato de planta: borde recto + ícono + label, ambos del
/// mismo [color] (misma forma que [StatusTrafficLight], con ícono en vez de
/// punto).
class PlantChipBase extends StatelessWidget {
  const PlantChipBase({
    required this.label,
    required this.icon,
    this.color = BlueprintColors.textPrimary,
    super.key,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(border: Border.all(color: color)),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: color),
          ),
        ),
      ],
    ),
  );
}
