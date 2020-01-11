import 'package:flutter/material.dart';

class AppStyle {
  /*Text styles*/
  static TextStyle get textHuge => const TextStyle(fontSize: 92);
  
  static TextStyle get textH1 => const TextStyle(fontSize: 24);

  static TextStyle get textH3 => const TextStyle(fontSize: 18);

  static TextStyle get textBody1 => const TextStyle(fontSize: 14);

  static TextStyle get textCaption1 => const TextStyle(fontSize: 12);

  static TextStyle textButton(BuildContext context) {
    return TextStyle(fontSize: 21, color: Theme.of(context).primaryColor);
  }

  /*Colors*/
  static Color primaryColor(BuildContext context) {
    return Theme.of(context).primaryColor;
  }

//  static Color colorSalmon = const Color(0xFFFF8162);
//  static Color colorGainsboro = const Color(0xFFD8D7D9);
//  static Color colorManatee = const Color(0xFF9B9B9B);
}
