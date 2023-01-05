import 'package:flutter/material.dart';
export './jt_colors.dart';
export './jt_text_style.dart';

class JTThemeConfig {
  static ThemeData createTheme({
    Brightness? brightness,
    Color? background,
  }) {
    return ThemeData(
      brightness: brightness,
      backgroundColor: background,
    );
  }

  static ThemeData get lightTheme => createTheme(
        brightness: Brightness.light,
        background: Colors.white,
      );

  static ThemeData get darkTheme => createTheme(
        brightness: Brightness.dark,
        background: Colors.black,
      );
}
