import 'package:flutter/material.dart';

extension NestedScrollFixExtension on Widget {
  Widget fixNestedDoubleScrollbar() {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => true,
      child: this,
    );
  }
}
