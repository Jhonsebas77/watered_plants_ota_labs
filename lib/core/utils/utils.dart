library com.watered_plants_ota_labs.app.utils;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

String generateUUID() {
  Uuid uuid = const Uuid();
  return uuid.v4();
}

Color getColorFromString(String stringColor) {
  switch (stringColor) {
    case 'red':
      return Colors.red;
    case 'green':
      return Colors.green;
    case 'blue':
      return Colors.blue;
    case 'yellow':
      return Colors.yellow;
    case 'grey':
      return Colors.grey;
    default:
      return Colors.white;
  }
}

IconData getIconDataFromString(String stringIcons) {
  switch (stringIcons) {
    case 'mood':
      return Icons.mood;
    case 'compost':
      return Icons.compost;
    case 'pets':
      return Icons.pets;
    case 'florist':
      return Icons.local_florist;
    case 'energy_savings_leaf':
      return Icons.energy_savings_leaf;
    default:
      return Icons.eco;
  }
}

String getWateringScheduleFromString(String wateringSchedule) {
  switch (wateringSchedule) {
    case 'morning':
      return 'Mañana';
    case 'afternoon':
      return 'Tarde';
    case 'night':
      return 'Noche';
    default:
      return 'Mañana';
  }
}

IconData getIconTimeDataFromString(String stringIcons) {
  switch (stringIcons) {
    case 'morning':
      return Icons.sunny;
    case 'afternoon':
      return Icons.cloud;
    case 'night':
      return Icons.nights_stay;
    default:
      return Icons.sunny;
  }
}

int? getDifferenceInDays(String date) {
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
      return 0;
    } else if (nextWateringDate.isAfter(today)) {
      int differenceInDays = nextWateringDate.difference(today).inDays;
      return differenceInDays;
    } else {
      int differenceInDays = today.difference(nextWateringDate).inDays;
      return -differenceInDays;
    }
  } on FormatException {
    return null;
  } catch (e) {
    return null;
  }
}

String getWateringMessage(String date, {bool isNextWatering = false}) {
  int? _differenceInDays = getDifferenceInDays(date);
  try {
    if (_differenceInDays == 0) {
      return 'Hoy!';
    } else if (_differenceInDays! >= 1) {
      if (_differenceInDays == 1) {
        return 'Mañana';
      } else {
        return 'En $_differenceInDays días';
      }
    } else {
      if (_differenceInDays == -1) {
        return isNextWatering ? 'Debió haber sido ayer' : 'Ayer';
      } else {
        String normalizedDifferenceInDays = _differenceInDays
            .toString()
            .replaceAll('-', '');
        return isNextWatering
            ? '''Tarde $normalizedDifferenceInDays días'''
            : 'Fue hace $normalizedDifferenceInDays días';
      }
    }
  } on FormatException {
    return 'Invalid date format. Please use DD/MM/YYYY.';
  } catch (e) {
    return 'Could not determine watering schedule.';
  }
}

Color? getWateringChipColor(BuildContext context, String date) {
  int? _differenceInDays = getDifferenceInDays(date);
  try {
    if (_differenceInDays == 0) {
      return Theme.of(context).colorScheme.secondary;
    } else if (_differenceInDays! >= 1) {
      if (_differenceInDays == 1) {
        return Theme.of(context).colorScheme.inversePrimary;
      } else {
        return Theme.of(context).colorScheme.primary;
      }
    } else {
      if (_differenceInDays == -1) {
        return Theme.of(context).colorScheme.tertiary;
      } else {
        return Theme.of(context).colorScheme.error;
      }
    }
  } on FormatException {
    return Colors.blueGrey;
  } catch (e) {
    return Colors.grey;
  }
}

num toNumeric(String numberString) => num.tryParse(numberString) ?? 0;
