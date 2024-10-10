import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
  primaryColor: Colors.white,
  primarySwatch: Colors.blue,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.grey.shade900,
  highlightColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Colors.black,
    foregroundColor: Colors.white,
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStateProperty.all(Colors.grey),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(const Color(0xFF3C4CBD)),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.red,
  ),
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    foregroundColor: WidgetStateProperty.all(Colors.white),
  )),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF3C4CBD),
    contentTextStyle: TextStyle(
      color: Colors.white,
    ), // SnackBar metin rengi
    actionTextColor: Colors.yellow, //
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      color: Colors.white,
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.grey,
    thickness: 1,
  ),
  listTileTheme: ListTileThemeData(
    minTileHeight: 0,
    contentPadding: const EdgeInsets.all(2),
    selectedColor: Colors.amber,
    selectedTileColor: Colors.grey.shade800,
    textColor: Colors.grey,
    iconColor: Colors.grey,
    subtitleTextStyle: const TextStyle(
      color: Colors.grey,
    ),
    leadingAndTrailingTextStyle: const TextStyle(
      color: Colors.white38,
    ),
  ),
  expansionTileTheme: const ExpansionTileThemeData(
    textColor: Colors.white,
    collapsedTextColor: Colors.white,
  ),
  checkboxTheme: CheckboxThemeData(
    checkColor: const WidgetStatePropertyAll(Colors.white),
    fillColor: WidgetStatePropertyAll(Colors.black.withOpacity(0.2)),
    overlayColor: WidgetStatePropertyAll(Colors.black.withOpacity(0.5)),
  ),
);
