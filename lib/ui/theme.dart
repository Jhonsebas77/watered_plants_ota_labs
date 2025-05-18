import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.greenAccent,
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
  useMaterial3: true,
);

ThemeData // Define the dark theme based on the same seed color
darkTheme = ThemeData(
  // Generate the color scheme from the seed color for dark mode
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.green, // Same pastel green seed
    brightness: Brightness.dark, // Tells it to generate DARK colors
  ),
  textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
  // Ensure Material 3 is enabled
  useMaterial3: true,
);
