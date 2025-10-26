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
    ThemeData theme = Theme.of(context);
    DateTime weekStart = _startOfWeek(_focusedDay);
    List<DateTime> weekDays = List<DateTime>.generate(
      7,
      (int index) => weekStart.add(Duration(days: index)),
    );
    String monthLabel = _formatMonthYear(_focusedDay);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed:
                      () => setState(() {
                        _focusedDay = _focusedDay.subtract(
                          const Duration(days: DateTime.daysPerWeek),
                        );
                      }),
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                Text(
                  monthLabel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed:
                      () => setState(() {
                        _focusedDay = _focusedDay.add(
                          const Duration(days: DateTime.daysPerWeek),
                        );
                      }),
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children:
                  weekDays
                      .map(
                        (DateTime day) => Expanded(
                          child: _WeekDayIndicator(
                            day: day,
                            isSelected: _isSameDay(day, _focusedDay),
                            isToday: _isSameDay(
                              day,
                              _normalizeDate(DateTime.now()),
                            ),
                            hasWateringDue: _hasWateringDue(day),
                            hasBeenWatered: _hasBeenWatered(day),
                            onTap:
                                () => setState(() {
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
    ThemeData theme = Theme.of(context);
    Color primaryColor = theme.colorScheme.primary;
    Color todayBorderColor = theme.colorScheme.secondary;
    Color dayTextColor =
        isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;
    TextStyle? labelStyle = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color:
          isSelected
              ? theme.colorScheme.onPrimary.withValues(alpha: 0.8)
              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isToday ? todayBorderColor : Colors.transparent,
            width: isToday ? 1.5 : 0,
          ),
          color:
              isSelected
                  ? primaryColor
                  : theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.35,
                  ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              DateFormat('EEE', 'es').format(day).substring(0, 3),
              style: labelStyle,
            ),
            const SizedBox(height: 6),
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isSelected ? primaryColor : dayTextColor,
                    ),
                  ),
                ),
                if (hasWateringDue)
                  Positioned(
                    top: -8,
                    child: _StatusDot(
                      color: theme.colorScheme.secondary,
                      icon: Icons.water_drop_rounded,
                      iconColor: theme.colorScheme.onSecondary,
                    ),
                  ),
                if (hasBeenWatered)
                  Positioned(
                    bottom: -8,
                    child: _StatusDot(
                      color: theme.colorScheme.tertiary,
                      icon: Icons.check,
                      iconColor: theme.colorScheme.onTertiary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  final Color color;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: color.withValues(alpha: 0.4),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Icon(icon, size: 12, color: iconColor),
  );
}
