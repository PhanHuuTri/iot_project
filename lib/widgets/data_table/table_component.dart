import 'package:flutter/material.dart';

DataCell rowCellData({
  String? title,
  Widget? child,
  AlignmentGeometry alignment = Alignment.centerLeft,
}) {
  Widget cellChild;
  if (child != null) {
    cellChild = child;
  } else {
    cellChild = Padding(
      padding: alignment != Alignment.centerLeft
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: alignment,
        child: Text(
          title!,
        ),
      ),
    );
  }
  return DataCell(cellChild);
}

Widget tableCellText({
  String? title,
  Widget? child,
  TextStyle? style,
  AlignmentGeometry alignment = Alignment.centerLeft,
}) {
  return Container(
    constraints: const BoxConstraints(minHeight: 40),
    child: child ??
        Padding(
          padding: alignment != Alignment.centerLeft
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Align(
            alignment: alignment,
            child: Text(
              title!,
              style: style,
            ),
          ),
        ),
  );
}

Widget tableCellOnHover({
  required Widget child,
  required Widget onHoverChild,
  double onHoverChildTopPadding = 0,
}) {
  late OverlayEntry _overlayEntry;
  bool isMenuOpen = false;
  GlobalKey _key = GlobalKey();
  return LayoutBuilder(builder: (cellContext, size) {
    return InkWell(
      key: _key,
      child: child,
      onTap: () {},
      onHover: (value) {
        if (isMenuOpen) {
          _overlayEntry.remove();
          isMenuOpen = !isMenuOpen;
        } else {
          RenderBox renderBox =
              _key.currentContext!.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);

          _overlayEntry = OverlayEntry(
            builder: (context) {
              return Positioned(
                top: position.dy + renderBox.size.height,
                left: position.dx,
                child: onHoverChild,
              );
            },
          );
          Overlay.of(cellContext)!.insert(_overlayEntry);
          isMenuOpen = !isMenuOpen;
        }
      },
    );
  });
}

class TableHeader {
  final String title;
  final double width;
  final bool isConstant;

  TableHeader({
    required this.title,
    required this.width,
    this.isConstant = false,
  });
}
