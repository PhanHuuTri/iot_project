import 'package:flutter/material.dart';
import '../locales/i18n.dart';

class ScreenUtil {
  static late MediaQueryData? _mediaQueryData;
  static double? width;
  static double? height;
  static Orientation? orientation;

  static I18n? _i18n;
  static late String? Function(String?) t;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    width = _mediaQueryData?.size.width;
    height = _mediaQueryData?.size.height;
    orientation = _mediaQueryData?.orientation;
    _i18n = I18n.of(context)!;
    t = (String? key) => _i18n!.translate(key);
  }
}
