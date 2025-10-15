import 'package:flutter/material.dart';

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF336B2B), // A fresh, leafy green
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFB5F4A4),
  onPrimaryContainer: Color(0xFF002200),
  secondary: Color(0xFF336B82), // A clear water blue
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFB9EFFF),
  onSecondaryContainer: Color(0xFF001F29),
  tertiary: Color(0xFF9C4328), // A warm, earthy terracotta
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFDBD2),
  onTertiaryContainer: Color(0xFF3E0400),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFFDFDF7),
  onSurface: Color(0xFF1B1C1A),
  surfaceContainerHighest: Color(0xFFDFE4D8),
  onSurfaceVariant: Color(0xFF434840),
  outline: Color(0xFF73796E),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFF2F312E),
  onInverseSurface: Color(0xFFF1F1EB),
  inversePrimary: Color(0xFF9AD78B),
  surfaceTint: Color(0xFF336B2B),
);

// Dark Mode Color Scheme
const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF9AD78B), // A calmer, soft green for dark mode
  onPrimary: Color(0xFF003A00),
  primaryContainer: Color(0xFF195213),
  onPrimaryContainer: Color(0xFFB5F4A4),
  secondary: Color(0xFF9DD2E7), // A muted, calm blue
  onSecondary: Color(0xFF003545),
  secondaryContainer: Color(0xFF175268),
  onSecondaryContainer: Color(0xFFB9EFFF),
  tertiary: Color(0xFFFFB5A2), // A gentle, glowing terracotta
  onTertiary: Color(0xFF5F1600),
  tertiaryContainer: Color(0xFF7D2C13),
  onTertiaryContainer: Color(0xFFFFDBD2),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFB4AB),
  surface: Color(0xFF1B1C1A),
  onSurface: Color(0xFFE4E3DE),
  surfaceContainerHighest: Color(0xFF434840),
  onSurfaceVariant: Color(0xFFC3C8BC),
  outline: Color(0xFF8D9387),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFFE3E3DC),
  onInverseSurface: Color(0xFF1B1C1A),
  inversePrimary: Color(0xFF336B2B),
  surfaceTint: Color(0xFF9AD78B),
);

// ThemeData for Light Mode
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: lightColorScheme,
);

// ThemeData for Dark Mode
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: darkColorScheme,
);
