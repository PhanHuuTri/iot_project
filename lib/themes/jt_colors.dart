import 'package:flutter/material.dart';

class JTColors {
  static Color primaryText = hexToColor('#000000');
  static Color secondaryText = hexToColor('#505050');
  static Color disabled = hexToColor('#F6F6F6');
  static Color error = hexToColor('#F04C4C');
  static Color themePrimary = hexToColor('#009549');
  static Color baseLightColor = hexToColor('#F2F2F2');
  static Color hintTextColor = hexToColor('#A8A8A8');
  static Color backgroundImage = hexToColor('#2183B3');

  static const Color success = Colors.green;
  static const Color warn = Colors.amber;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static Color buttonColor = hexToColor('#1D7A4A');
  static Color primary = hexToColor('#019549');
  static Color primary5 = hexToColor('#21A260');
  static Color primaryLight = hexToColor('#C1F4DA');
  static Color secondary = hexToColor('#0A7AFF');
  static Color secondary2 = hexToColor('#F0FDFB');
  static Color secondaryLight = hexToColor('#F2F2F2');
  static Color subTitle = hexToColor('#505050');
  static Color dividerColor = hexToColor('#A8A8A8');
  static Color buttonBackground = hexToColor('#F6F6F6');
  static Color authColor = hexToColor('#33A5F8');
  static Color toastIcon = hexToColor('#00BA00');
  static Color toastShadow = hexToColor('#3199e3');
  static Color hintColor = hexToColor('#737373');
  static Color emptySlotColor = hexToColor('#CECECE');
  static Color shadow = hexToColor('#7090B0');
  static Color card2 = hexToColor('#7CB342');
  static Color card3 = hexToColor('#E09A32');
  static Color noticeBackground = hexToColor('#EBEBEB');

  static Color transparent = Colors.transparent;
  static Color boxShadowColor = const Color.fromRGBO(79, 117, 140, 0.24);
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}
