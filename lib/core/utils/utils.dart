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

num toNumeric(String numberString) => num.tryParse(numberString) ?? 0;
