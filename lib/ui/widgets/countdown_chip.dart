part of com.watered_plants_ota_labs.app.widgets;

/// "Regar en N días" — countdown hasta el próximo riego de una planta, con
/// color de semáforo según qué tan cerca (o atrasado) esté.
class CountdownChip extends StatelessWidget {
  const CountdownChip({
    required this.nextWateringDate,
    required this.now,
    super.key,
  });

  final DateTime nextWateringDate;
  final DateTime now;

  int get _daysLeft => DateTime(
    nextWateringDate.year,
    nextWateringDate.month,
    nextWateringDate.day,
  ).difference(DateTime(now.year, now.month, now.day)).inDays;

  TrafficLightLevel get _level {
    int days = _daysLeft;
    if (days < 0) return TrafficLightLevel.danger;
    if (days <= 1) return TrafficLightLevel.warning;
    return TrafficLightLevel.ok;
  }

  String get _label {
    int days = _daysLeft;
    if (days == 0) return 'Regar hoy';
    if (days == 1) return 'Regar mañana';
    if (days < 0) return 'Atrasada ${-days}d';
    return 'Regar en ${days}d';
  }

  @override
  Widget build(BuildContext context) =>
      StatusTrafficLight(label: _label, level: _level);
}
