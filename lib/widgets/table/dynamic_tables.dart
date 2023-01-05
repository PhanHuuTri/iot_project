import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web_iot/config/extensions/nested_scroll_fix.dart';
import '../data_table/table_component.dart';

class DynamicTables extends StatelessWidget {
  final int numberOfRows;
  final Widget Function(int, Map<int, TableColumnWidth>) rowBuilder;
  final EdgeInsetsGeometry contentPadding;
  final List<TableHeader> columnWidthRatio;
  final bool hasSeparator;
  final BorderSide? separatorSide;
  final bool hideHeaderSection;
  final Widget Function(BuildContext, String)? columnHeaderBuilder;
  final Widget? checkBox;
  DynamicTables({Key? key, 
    required this.columnWidthRatio,
    required this.numberOfRows,
    required this.rowBuilder,
    this.contentPadding = const EdgeInsets.only(top: 0),
    this.hasSeparator = false,
    this.separatorSide,
    this.hideHeaderSection = false,
    this.checkBox,
    this.columnHeaderBuilder,
  }) : super(key: key);

  final _centerHeaders = [
    'STT',
    'Vị trí',
    'Số lượng thiết bị',
    'Thao tác',
    'Cập nhật file đang phát',
  ];
  final _rightHeaders = [];
  final _horScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        final columnWidths = _buildColumnWidths(size: size);
        return Scrollbar(
          controller: _horScrollController,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _horScrollController,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                hideHeaderSection
                    ? const SizedBox()
                    : Table(
                        border: TableBorder(
                          bottom: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 0.5,
                          ),
                          verticalInside: BorderSide(
                            width: 0.25,
                            color: Theme.of(context).dividerColor,
                            style: BorderStyle.solid,
                          ),
                        ),
                        columnWidths: columnWidths,
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: _buildColumns(
                          context: context,
                          headers:
                              columnWidthRatio.map((e) => e.title).toList(),
                          checkBox: checkBox,
                        ),
                      ),
                Padding(
                  padding: contentPadding,
                  child: Column(
                    children: [
                      for (int i = 0; i < numberOfRows; i++)
                        rowBuilder(i, columnWidths),
                    ],
                  ),
                )
              ],
            ),
          ),
        ).fixNestedDoubleScrollbar();
      },
    );
  }

  _buildColumnWidths({required BoxConstraints size}) {
    Map<int, FixedColumnWidth> _columnWidths = {};
    double totalUnits = 0;
    double totalConstant = 0;
    int numOfUnit = 0;
    for (var item in columnWidthRatio) {
      totalUnits += item.isConstant ? 0 : item.width;
      totalConstant += item.isConstant ? item.width + 50 : 0;
      numOfUnit += item.isConstant ? 1 : 0;
    }
    final width = size.maxWidth;
    var unit = ((width - totalConstant - 50) / totalUnits) / numOfUnit;
    for (int i = 0; i < columnWidthRatio.length; i++) {
      final pattern = columnWidthRatio[i];
      var value = pattern.isConstant
          ? pattern.width
          : max(unit * pattern.width, pattern.width);
      _columnWidths[i] = FixedColumnWidth(value);
    }
    return _columnWidths;
  }

  _buildColumns({
    required BuildContext context,
    List<String>? headers,
    Widget? checkBox,
  }) {
    return [
      TableRow(
        children: [
          for (var title in headers!)
            _buildColumn(
              context: context,
              headerName: title,
              checkBox: checkBox,
            )
        ],
      ),
    ];
  }

  _buildColumn({
    required BuildContext context,
    String? headerName,
    Widget? checkBox,
  }) {
    if (headerName == 'checkBox') {
      return checkBox;
    }
    if (columnHeaderBuilder != null) {
      var header = columnHeaderBuilder!(context, headerName!);
      return header;
    }
    final alignment = _centerHeaders.contains(headerName)
        ? Alignment.center
        : _rightHeaders.contains(headerName)
            ? Alignment.centerRight
            : Alignment.centerLeft;
    final textAlign = _centerHeaders.contains(headerName)
        ? TextAlign.center
        : _rightHeaders.contains(headerName)
            ? TextAlign.right
            : TextAlign.left;
    return SizedBox(
      height: 44,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            headerName!,
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: textAlign,
          ),
        ),
      ),
    );
  }
}

class ColumnWidthPattern {
  final double value;
  final bool isConstant;
  const ColumnWidthPattern({required this.value, this.isConstant = false});
}
