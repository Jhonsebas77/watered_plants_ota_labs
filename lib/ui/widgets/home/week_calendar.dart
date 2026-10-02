part of com.watered_plants_ota_labs.app.widgets;

class HomeWeekCalendar extends StatefulWidget {
  const HomeWeekCalendar({required this.plants, super.key});

  final List<PlantModel> plants;

  @override
  State<HomeWeekCalendar> createState() => _HomeWeekCalendarState();
}

class _HomeWeekCalendarState extends State<HomeWeekCalendar> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = _normalizeDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = _normalizeDate(DateTime.now());
    DateTime weekStart = _startOfWeek(_focusedDay);
    List<DateTime> weekDays = List<DateTime>.generate(
      7,
      (int index) => weekStart.add(Duration(days: index)),
    );
    String monthLabel = _formatMonthYear(_focusedDay);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () => setState(() {
                    _focusedDay = _focusedDay.subtract(
                      const Duration(days: DateTime.daysPerWeek),
                    );
                  }),
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    color: BlueprintColors.textPrimary,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      monthLabel.toUpperCase(),
                      style: AppTextStyles.label(
                        color: BlueprintColors.textPrimary,
                        size: 12,
                        spacing: 2,
                        weight: FontWeight.w700,
                      ),
                    ),
                    Visibility(
                      visible: !_isSameDay(_focusedDay, today),
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: TextButton(
                        onPressed: () => setState(() {
                          _focusedDay = today;
                        }),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Hoy'),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => setState(() {
                    _focusedDay = _focusedDay.add(
                      const Duration(days: DateTime.daysPerWeek),
                    );
                  }),
                  icon: const Icon(
                    Icons.chevron_right_rounded,
                    color: BlueprintColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: weekDays
                  .map(
                    (DateTime day) => Expanded(
                      child: _WeekDayIndicator(
                        day: day,
                        isSelected: _isSameDay(day, _focusedDay),
                        isToday: _isSameDay(day, today),
                        hasWateringDue: _hasWateringDue(day),
                        hasBeenWatered: _hasBeenWatered(day),
                        onTap: () => setState(() {
                          _focusedDay = _normalizeDate(day);
                        }),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _startOfWeek(DateTime date) {
    int daysToSubtract = date.weekday % DateTime.daysPerWeek;
    return date.subtract(Duration(days: daysToSubtract));
  }

  bool _hasWateringDue(DateTime day) => widget.plants.any((PlantModel plant) {
    DateTime? nextWateringDate = plant.getNextWateringDate;
    return nextWateringDate != null && _isSameDay(nextWateringDate, day);
  });

  bool _hasBeenWatered(DateTime day) => widget.plants.any((PlantModel plant) {
    DateTime? lastWateredDate = plant.getLastWateredDate;
    return lastWateredDate != null && _isSameDay(lastWateredDate, day);
  });

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatMonthYear(DateTime date) {
    String formatted = DateFormat('MMMM yyyy', 'es').format(date);
    return toBeginningOfSentenceCase(formatted) ?? formatted;
  }
}

class _WeekDayIndicator extends StatelessWidget {
  const _WeekDayIndicator({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.hasWateringDue,
    required this.hasBeenWatered,
    required this.onTap,
  });

  final DateTime day;
  final bool isSelected;
  final bool isToday;
  final bool hasWateringDue;
  final bool hasBeenWatered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color dayTextColor = isSelected
        ? BlueprintColors.onAccent
        : BlueprintColors.textPrimary;
    TextStyle labelStyle = AppTextStyles.label(
      color: isSelected
          ? BlueprintColors.onAccent.withValues(alpha: 0.8)
          : BlueprintColors.textMuted,
      spacing: 1,
      weight: FontWeight.w600,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isToday
                ? BlueprintColors.accentOrange
                : BlueprintColors.outlineVariant,
          ),
          color: isSelected
              ? BlueprintColors.accentOrange
              : BlueprintColors.background,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              DateFormat('EEE', 'es').format(day).substring(0, 3).toUpperCase(),
              style: labelStyle,
            ),
            const SizedBox(height: 6),
            Text(
              '${day.day}',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: dayTextColor,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _StatusIcon(
                  visible: hasWateringDue,
                  icon: Icons.water_drop_rounded,
                  semanticLabel: 'Riego pendiente',
                  color: isSelected
                      ? BlueprintColors.onAccent
                      : BlueprintColors.accentOrange,
                ),
                const SizedBox(width: 4),
                _StatusIcon(
                  visible: hasBeenWatered,
                  icon: Icons.check,
                  semanticLabel: 'Planta regada',
                  color: isSelected
                      ? BlueprintColors.onAccent
                      : BlueprintColors.successGreen,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Ícono de estado del día: gota = riego pendiente, check = alguna planta
/// fue regada ese día. Cuando no aplica conserva su espacio para que todos
/// los días del calendario tengan la misma altura.
class _StatusIcon extends StatelessWidget {
  const _StatusIcon({
    required this.visible,
    required this.icon,
    required this.color,
    required this.semanticLabel,
  });

  final bool visible;
  final IconData icon;
  final Color color;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => Visibility(
    visible: visible,
    maintainSize: true,
    maintainAnimation: true,
    maintainState: true,
    child: Icon(icon, size: 14, color: color, semanticLabel: semanticLabel),
  );
}
