import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_constants.dart';

class ThemeConfig {
  static ThemeData createTheme({
    required Brightness brightness,
    required Color primary,
    required Color primaryText,
    required Color background,
    required Color secondary,
    required Color baseLightColor,
    required Color secondaryText,
    required Color hintTextColor,
    required Color disabled,
    required Color error,
    required Color themePrimary,
    required Color backgroundImage,
  }) {
    final baseTextTheme = brightness == Brightness.dark
        ? Typography.blackMountainView
        : Typography.whiteMountainView;

    final systemOverlayStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;

    return ThemeData(
      brightness: brightness,
      disabledColor: disabled,
      canvasColor: background,
      dividerColor: disabled,
      dividerTheme: DividerThemeData(
        color: secondaryText,
        space: 1,
        thickness: 1,
      ),
      highlightColor: secondary,
      secondaryHeaderColor: themePrimary,
      backgroundColor: background,
      primaryColor: themePrimary,
      hintColor: hintTextColor,
      toggleableActiveColor: backgroundImage,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: systemOverlayStyle,
        color: background,
        titleTextStyle: baseTextTheme.bodyText1!.copyWith(
          color: primaryText,
          fontSize: 18,
        ),
        iconTheme: IconThemeData(
          color: themePrimary,
        ),
      ),
      iconTheme: IconThemeData(
        color: primaryText,
        size: 16.0,
      ),
      errorColor: error,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        colorScheme: ColorScheme(
          brightness: brightness,
          primary: themePrimary,
          secondary: primary,
          surface: themePrimary,
          background: background,
          error: error,
          onPrimary: primaryText,
          onSecondary: primaryText,
          onSurface: primaryText,
          onBackground: primaryText,
          onError: primaryText,
        ),
        padding: const EdgeInsets.all(16.0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: background,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: themePrimary, width: 1),
          borderRadius: BorderRadius.circular(4.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: hintTextColor,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: error,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
        errorStyle: TextStyle(color: error, fontSize: 12),
        labelStyle: TextStyle(
          fontSize: 16.0,
          color: secondaryText,
          fontWeight: FontWeight.normal,
        ),
        hintStyle: TextStyle(
          color: hintTextColor,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        suffixStyle: TextStyle(
          color: primaryText,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
      textTheme: TextTheme(
        headline1: baseTextTheme.headline1!.copyWith(
          color: primaryText,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
        ),
        headline2: baseTextTheme.headline2!.copyWith(
          color: primaryText,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        headline3: baseTextTheme.headline3!.copyWith(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        headline4: baseTextTheme.headline4!.copyWith(
          color: themePrimary,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        headline5: baseTextTheme.headline5!.copyWith(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        headline6: baseTextTheme.headline6!.copyWith(
          color: baseLightColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodyText1: baseTextTheme.bodyText1!.copyWith(
          color: primaryText,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodyText2: baseTextTheme.bodyText2!.copyWith(
          color: secondaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        button: baseTextTheme.button!.copyWith(
          color: primary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        caption: baseTextTheme.caption!.copyWith(
          color: primaryText,
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
        ),
        overline: baseTextTheme.overline!.copyWith(
          color: primaryText,
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
        ),
        subtitle1: baseTextTheme.subtitle1!.copyWith(
          color: primaryText,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
        subtitle2: baseTextTheme.subtitle2!.copyWith(
          color: secondaryText,
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.italic,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: themePrimary,
          primary: background,
          textStyle: baseTextTheme.button!.copyWith(
            color: primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

  static ThemeData get lightTheme => createTheme(
        brightness: Brightness.light,
        background: Colors.white,
        primaryText: hexToColor('#000000'),//black
        secondaryText: hexToColor('#505050'),//black
        disabled: hexToColor('#F6F6F6'),//Trắng
        error: hexToColor('#F04C4C'),//red
        themePrimary: hexToColor('#009549'),//green nhạt
        primary: hexToColor('#1D7A4A'),//green đậm
        secondary: hexToColor('#F0FDFB'),//trắng
        baseLightColor: hexToColor('#F2F2F2'),// trắng đỏ
        hintTextColor: hexToColor('#A8A8A8'),//xám đỏ
        backgroundImage: hexToColor('#2183B3'),//xanh da trời đậm
      );

  static ThemeData get darkTheme => createTheme(
        brightness: Brightness.dark,
        background: ColorConstants.darkScaffoldBackground,
        primaryText: Colors.white,
        secondaryText: Colors.black,
        disabled: ColorConstants.secondaryDarkAppColor,
        error: Colors.red,
        themePrimary: Colors.white,
        hintTextColor: Colors.white,
        primary: Colors.blueAccent,
        secondary: Colors.blueAccent.shade100,
        baseLightColor: Colors.black,
        backgroundImage: Colors.blueAccent.shade200,
      );
}
