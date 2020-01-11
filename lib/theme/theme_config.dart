import 'package:flutter/material.dart';

enum EAppTheme {
  Light,
  Dark,
}

class AppTheme {
  /// Determines whether platform theme is dark
  static bool isDark(BuildContext context) => MediaQuery.of(context).platformBrightness == Brightness.dark;

  static final Map<EAppTheme, ThemeData> appThemeData = {
    EAppTheme.Light: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.cyan,
    ),
    EAppTheme.Dark: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.cyan[900],
    ),
  };
}
