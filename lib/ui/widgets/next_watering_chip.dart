part of com.watered_plants_ota_labs.app.widgets;

class NextWateringChip extends StatelessWidget {
  const NextWateringChip({required this.nextWateringDate, super.key});
  final String nextWateringDate;

  String getWateringMessage(String date) {
    DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    try {
      DateTime parsedInputDate = inputFormat.parseStrict(date);
      DateTime nextWateringDate = DateTime(
        parsedInputDate.year,
        parsedInputDate.month,
        parsedInputDate.day,
      );
      if (nextWateringDate.isAtSameMomentAs(today)) {
        return 'Hoy!';
      } else if (nextWateringDate.isAfter(today)) {
        int differenceInDays = nextWateringDate.difference(today).inDays;
        if (differenceInDays == 1) {
          return 'Mañana';
        } else {
          return 'En $differenceInDays días';
        }
      } else {
        int differenceInDays = today.difference(nextWateringDate).inDays;
        if (differenceInDays == 1) {
          return 'Ayer';
        } else {
          return 'Fue hace $differenceInDays días';
        }
      }
    } on FormatException {
      return 'Invalid date format. Please use DD/MM/YYYY.';
    } catch (e) {
      return 'Could not determine watering schedule.';
    }
  }

  @override
  Widget build(BuildContext context) => Chip(
    label: Text(
      getWateringMessage(nextWateringDate),
      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    ),
    backgroundColor: Theme.of(context).colorScheme.primary,
    shape: RoundedRectangleBorder(
      side: const BorderSide(width: 3),
      borderRadius: BorderRadius.circular(32),
    ),
    avatar: Icon(
      Icons.local_drink_rounded,
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}
