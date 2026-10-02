library com.watered_plants_ota_labs.app.constants;

import 'package:flutter/material.dart';

const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const String supabasePublishableKey = String.fromEnvironment(
  'SUPABASE_PUBLISHABLE_KEY',
);
const String hardcodedEmail = String.fromEnvironment('AUTH_EMAIL');

const String databaseURL = String.fromEnvironment('FIREBASE_DATABASE_URL');
const String firebaseOriginPath = '/watered_plants';
const String firebasePlantsPath = '/watered_plants/plants/';
const String placeHolderImage = 'https://i.ibb.co/KcX8h982/download-16.png';

final List<Color> colorOptions = <Color>[
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.grey,
  Colors.purple,
  Colors.white,
];

final List<String> colorStringsOptions = <String>[
  'red',
  'green',
  'blue',
  'yellow',
  'grey',
  'purple',
  'white',
];

final List<String> scheduleOptions = <String>['morning', 'afternoon', 'night'];

final List<IconData> iconsOptions = <IconData>[
  Icons.mood,
  Icons.compost,
  Icons.pets,
  Icons.local_florist,
  Icons.energy_savings_leaf,
  Icons.filter_vintage,
  Icons.spa,
  Icons.park,
  Icons.grass,
  Icons.eco,
];

final List<String> iconsNameOptions = <String>[
  'mood',
  'compost',
  'pets',
  'florist',
  'energy_savings_leaf',
  'flower',
  'cactus',
  'tree',
  'grass',
  'default',
];
