import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JTTextStyle {
  static TextStyle headline1({Color color = Colors.black}) {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
      fontSize: 34.0,
      color: color,
    );
  }

  static TextStyle headline2({Color color = Colors.black}) {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.bold,
      fontSize: 22,
      color: color,
    );
  }

  static TextStyle headline3({Color color = Colors.black}) {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.w500,
      fontSize: 20,
      color: color,
    );
  }

  static TextStyle headline4({Color color = Colors.black}) {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.w800,
      fontSize: 18,
      color: color,
    );
  }

  static TextStyle headline5({Color color = Colors.black}) {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: color,
    );
  }

  static TextStyle headline6({Color color = Colors.black}) {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: color,
    );
  }

  static TextStyle bodyText1({Color color = Colors.black}) {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.normal,
      fontSize: 14,
      color: color,
    );
  }

  static TextStyle bodyText2({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: color,
    );
  }

  static TextStyle caption({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w500,
      fontSize: 12.0,
      color: color,
    );
  }

  static TextStyle overline({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w500,
      fontSize: 11.0,
      color: color,
    );
  }

  static TextStyle subtitle1({Color color = Colors.black}) {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
      color: color,
    );
  }

  static TextStyle subtitle2({Color color = Colors.black}) {
    return GoogleFonts.roboto(
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.italic,
      fontSize: 14.0,
      color: color,
    );
  }

  static TextStyle link({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w400,
      color: color,
      fontSize: 14,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle superscript({Color color = Colors.black}) {
    return GoogleFonts.lexend(
      fontWeight: FontWeight.w400,
      color: color,
      fontSize: 14,
      fontFeatures: [
        const FontFeature.enable('sups'),
      ],
    );
  }
}
