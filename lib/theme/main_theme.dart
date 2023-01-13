import 'package:flutter/material.dart';

BorderRadius borderRadius16 = BorderRadius.circular(16);
Color priamry = Colors.red;
ThemeData theme = ThemeData(
  primarySwatch: Colors.red,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: priamry,
      shape: const StadiumBorder(),
    ),
  ),
);
