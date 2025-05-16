library com.watered_plants_ota_labs.app.utils;

import 'package:flutter/material.dart';
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
