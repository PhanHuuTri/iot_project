import 'package:flutter/material.dart';
import 'package:web_iot/config/svg_constants.dart';

class MenuItem {
  MenuItem({
    required this.title,
    this.route,
    this.subRoute,
    this.icon,
    this.svgIcon,
    this.children = const [],
  });

  final String title;
  final String? route;
  final String? subRoute;
  final IconData? icon;
  final SvgIconData? svgIcon;
  final List<MenuItem> children;
}
