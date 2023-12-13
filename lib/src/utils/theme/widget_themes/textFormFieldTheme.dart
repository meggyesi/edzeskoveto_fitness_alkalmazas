import 'package:flutter/material.dart';
import 'package:wtracker/src/constants/colors.dart';

class TextFormFieldTheme {
  TextFormFieldTheme._();
  static InputDecorationTheme lightInputDecorationTheme =
      const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
          prefixIconColor: secondaryColor,
          floatingLabelStyle: TextStyle(color: secondaryColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: secondaryColor),
          ));

  static InputDecorationTheme darkInputDecorationTheme =
      const InputDecorationTheme(
          filled: true,
          fillColor: Colors.black54,
          border: OutlineInputBorder(),
          prefixIconColor: primaryColor,
          floatingLabelStyle: TextStyle(color: primaryColor),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: primaryColor),
          ));
}
