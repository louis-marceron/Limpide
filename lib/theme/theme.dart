import 'package:flutter/material.dart';

// Legacy color
// const Color seedColor = Color(0xFF047080);
const Color seedColor = Color(0xFF00576E);

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
  ),
  useMaterial3: true,
  extensions: <ThemeExtension<dynamic>> [
  ]
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);
