// TODO Implement this library.
import 'package:flutter/material.dart';


abstract class AppTheme {
  static const seed = Color(0xFF8E6CEF); // lila
  static const accentPink = Color(0xFFFF6FD8);


  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: Brightness.light,
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF6F2FF),
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
  );


  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}