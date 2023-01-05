import 'dart:math';
import 'package:flutter/material.dart';
import '/open_sources/popover/popover.dart';
import '/widgets/joytech_components/joytech_components.dart';

class ListItemPopover<T> extends StatelessWidget {
  final String? initialValue;
  final double? popoverWidth;
  final List<T>? listItems;
  final bool? hasHeader;
  final Widget? header;
  final Widget Function(int)? child;
  final Function()? loadData;
  final double? popoverHeight;
  final bool? childDivider;
  final Color? fieldColor;
  const ListItemPopover({
    Key? key,
    this.initialValue,
    this.popoverWidth,
    this.listItems,
    this.hasHeader = true,
    this.header,
    this.child,
    this.loadData,
    this.popoverHeight,
    this.childDivider = false,
    this.fieldColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = popoverHeight ?? 51.0 + (min(listItems!.length, 5)) * 36.0;
    return JTTitleButtonFormField(
      readOnly: true,
      initialValue: initialValue,
      style: Theme.of(context).textTheme.bodyText1,
      decoration: listItems!.isNotEmpty
          ? InputDecoration(
              fillColor: fieldColor,
              suffixIcon: ButtonTheme(
                minWidth: 30,
                height: 30,
                child: Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            )
          : null,
      onPressed: listItems!.isNotEmpty
          ? () {
              if (loadData != null) {
                loadData!();
              }
              showPopover(
                context: context,
                bodyBuilder: (BuildContext context) => ListItems(
                  listItems: listItems!,
                  hasHeader: hasHeader!,
                  headerWidget: header!,
                  childWidget: child!,
                  childDivider: childDivider!,
                  height: height - 51,
                ),
                direction: PopoverDirection.bottom,
                width: popoverWidth,
                height: height,
                arrowHeight: 15,
                arrowWidth: 30,
              );
            }
          : null,
    );
  }
}

class ListItems<T> extends StatelessWidget {
  final List<T>? listItems;
  final bool? hasHeader;
  final bool? childDivider;
  final Widget? headerWidget;
  final Widget Function(int)? childWidget;
  final double? height;
  const ListItems({
    Key? key,
    this.listItems,
    this.hasHeader,
    this.headerWidget,
    this.childWidget,
    this.childDivider,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    for (int i = 0; i < listItems!.length; i++) {
      children.add(
        childWidget!(i),
      );
      if (listItems!.length > 1 &&
          i != listItems!.length - 1 &&
          childDivider!) {
        children.add(
          const Divider(),
        );
      }
    }
    return Column(
      children: [
        if (hasHeader!) headerWidget!,
        if (hasHeader!) const Divider(),
        SizedBox(
          height: height ?? (min(listItems!.length, 5)) * 68.0,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: children,
          ),
        ),
      ],
    );
  }
}
