import 'dart:math';
import 'package:flutter/material.dart';
import '/open_sources/popover/popover.dart'
    as local;
import 'package:popover/popover.dart' as popover;

class DynamicPopover {
  DynamicPopover.show({
    BuildContext? context,
    double titleHeight = 36.0,
    double itemHeight = 30.0,
    double contentWidth = 300.0,
    List<String> source = const [],
    Widget Function(BuildContext, double, double)? bodyBuilder,
    bool? needConfirmOnClose,
  })  : assert(contentWidth > 0, 'The content width must be greater than 0'),
        assert(source.isNotEmpty, 'DataSource must not be empty') {
    // title & divider & clear filter
    double height = titleHeight + 1 + itemHeight;
    // search
    height += source.length > 8 ? itemHeight : 0.0;
    // confirm
    height += needConfirmOnClose! ? itemHeight : 0.0;
    // items height
    height += min(source.length, 5) * itemHeight;
    popover.showPopover(
      context: context!,
      bodyBuilder: (context) => bodyBuilder!(context, titleHeight, itemHeight),
      direction: popover.PopoverDirection.bottom,
      width: contentWidth,
      height: height,
      arrowHeight: 15,
      arrowWidth: 30,
    );
  }

  DynamicPopover.dropdown({
    BuildContext? context,
    double titleHeight = 36.0,
    double itemHeight = 30.0,
    double contentWidth = 300.0,
    List<String> source = const [],
    Widget Function(BuildContext, double, double)? bodyBuilder,
    bool enableClearing = true,
    bool needConfirm = false,
    Function? whenComplete,

  }) {
    double height = titleHeight > 0.0 ? titleHeight + 1 : 0.0;
    // clear filter
    height += enableClearing ? itemHeight : 0.0;
    // search
    height += source.length > 8 ? itemHeight : 0.0;
    // items height
    height += min(source.length, 5) * itemHeight;
    // confirm
    height += needConfirm ? itemHeight : 0;
    local.showPopover(
      context: context!,
      bodyBuilder: (context) => bodyBuilder!(context, titleHeight, itemHeight),
      direction: local.PopoverDirection.bottom,
      width: contentWidth,
      height: height,
      arrowHeight: 0,
      arrowWidth: 0,
      contentDyOffset: 2,
      barrierColor: Colors.transparent,
      shadow: [],
      radius: 0,
    ).whenComplete(() => whenComplete!());
  }
}
