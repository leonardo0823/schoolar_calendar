import 'package:flutter/material.dart';

ThemeData dark = ThemeData.dark().copyWith(
  primaryColor: const Color(0xFF06296B),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF052C53),
    foregroundColor: Color(0xC9C9C9C9),
  ),
  listTileTheme: ListTileThemeData(
    iconColor: Color(0xC9C9C9C9),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Color(0xDCDCDCDC),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      textStyle: WidgetStateProperty.all(
        const TextStyle(
          color: Color(0xDCDCDCDC),
        ),
      ),
      foregroundColor: WidgetStateProperty.all(const Color(0xDCDCDCDC)),
    ),
  ),
  highlightColor: const Color(0xFF373739),
  iconTheme: const IconThemeData(color: Color(0xDCDCDCDC)),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF094C90),
    titleTextStyle: TextStyle(color: Colors.white),
    actionsIconTheme: IconThemeData(color: Colors.white),
    foregroundColor: Colors.white,
  ),
  colorScheme: const ColorScheme(
    primary: Color(0xFF06296B),
    secondary: Color(0xC9C9C9C9),
    // surface: Color(0xFF052C53),
    surface: Color(0xFF272727),
    brightness: Brightness.dark,
    error: Colors.red,
    onBackground: Color(0xFF094C90),
    onError: Colors.orange,
    onPrimary: Color(0xFF073487),
    onSecondary: Color(0xC8DDDCDC),
    onSurface: Color(0xFF063768),
  ),
);
