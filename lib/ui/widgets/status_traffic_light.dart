part of com.watered_plants_ota_labs.app.widgets;

Color trafficLightColor(TrafficLightLevel level) {
  switch (level) {
    case TrafficLightLevel.ok:
      return BlueprintColors.successGreen;
    case TrafficLightLevel.warning:
      return BlueprintColors.warning;
    case TrafficLightLevel.danger:
      return BlueprintColors.danger;
  }
}

/// Chip de semáforo usado por Dashboard/Garaje Legal para el estado de un
/// documento (SOAT/RTM/etc.).
class StatusTrafficLight extends StatelessWidget {
  const StatusTrafficLight({
    required this.label,
    required this.level,
    super.key,
  });

  final String label;
  final TrafficLightLevel level;

  @override
  Widget build(BuildContext context) {
    Color color = trafficLightColor(level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(border: Border.all(color: color)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: color)),
        ],
      ),
    );
  }
}
