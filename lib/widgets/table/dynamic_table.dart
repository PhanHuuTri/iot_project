import 'dart:math';
import 'package:flutter/material.dart';
import 'package:web_iot/config/extensions/nested_scroll_fix.dart';
import '../../main.dart';
import '../data_table/table_component.dart';

class DynamicTable extends StatefulWidget {
  final int numberOfRows;
  final TableRow Function(int) rowBuilder;
  final EdgeInsetsGeometry contentPadding;
  final List<TableHeader> columnWidthRatio;
  final bool hasSeparator;
  final BorderSide? separatorSide;
  final bool hideHeaderSection;
  final Widget Function(BuildContext, String)? columnHeaderBuilder;
  final TableCellVerticalAlignment verticalAlignment;
  final bool hasBodyData;
  final BoxBorder? tableBorder;
  final TextStyle? headerStyle;
  final Color? headerColor;
  final TableBorder? headerBorder;
  final TableBorder? bodyBorder;
  final Widget? Function(BuildContext, String)? getHeaderButton; 
  final double headerHeight;
  const DynamicTable({
    Key? key,
    required this.columnWidthRatio,
    required this.numberOfRows,
    required this.rowBuilder,
    this.contentPadding = const EdgeInsets.only(top: 0),
    this.hasSeparator = false,
    this.separatorSide,
    this.hideHeaderSection = false,
    this.columnHeaderBuilder,
    this.verticalAlignment = TableCellVerticalAlignment.middle,
    required this.hasBodyData,
    this.tableBorder,
    this.headerStyle,
    this.headerColor,
    this.bodyBorder,
    this.headerBorder,
    this.getHeaderButton,
    this.headerHeight = 40,
  }) : super(key: key);

  @override
  State<DynamicTable> createState() => _DynamicTableState();
}

class _DynamicTableState extends State<DynamicTable> {
  final _centerHeaders = [];
  final _rightHeaders = [];
  final _tableScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, size) {
        final columnWidths = _buildColumnWidths(size: size);

        return Scrollbar(
          controller: _tableScrollController,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _tableScrollController,
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 16,
                        color: AppColor.shadow.withOpacity(0.16),
                        blurStyle: BlurStyle.outer),
                  ],
                  border: widget.tableBorder ??
                      Border.all(
                        color: AppColor.black,
                      ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    if (!widget.hideHeaderSection) _buildHeader(columnWidths),
                    widget.hasBodyData
                        ? Padding(
                            padding: widget.contentPadding,
                            child: _buildBody(columnWidths),
                          )
                        : Container(
                            constraints: const BoxConstraints(minHeight: 40),
                            child: Padding(
                              padding: widget.contentPadding,
                              child: Center(
                                child: Text(ScreenUtil.t(I18nKey.noData)!),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
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

    for (var item in widget.columnWidthRatio) {
      totalUnits += item.isConstant ? 0 : item.width;
      totalConstant += item.isConstant ? item.width : 0;
    }
    final width = size.maxWidth;
    var unit = ((width - totalConstant) / totalUnits);
    for (int i = 0; i < widget.columnWidthRatio.length; i++) {
      final pattern = widget.columnWidthRatio[i];
      var value = pattern.isConstant
          ? pattern.width
          : max(unit * pattern.width, pattern.width) - 2;
      _columnWidths[i] = FixedColumnWidth(value);
    }
    return _columnWidths;
  }

  Widget _buildHeader(Map<int, TableColumnWidth>? columnWidths) {
    return Table(
      border: widget.headerBorder ??
          TableBorder(
            verticalInside: BorderSide(
              color: AppColor.dividerColor,
            ),
            bottom: BorderSide(
              color: AppColor.dividerColor,
            ),
          ),
      columnWidths: columnWidths,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _buildColumns(
        context: context,
        headers: widget.columnWidthRatio.map((e) => e.title).toList(),
      ),
    );
  }

  Widget _buildBody(Map<int, TableColumnWidth>? columnWidths) {
    return widget.hasSeparator
        ? Column(
            children: [
              for (int i = 0; i < widget.numberOfRows; i++)
                Table(
                  border: widget.bodyBorder ??
                      TableBorder(
                        verticalInside: BorderSide(
                          color: AppColor.dividerColor,
                        ),
                        horizontalInside: BorderSide(
                          color: AppColor.dividerColor,
                        ),
                      ),
                  columnWidths: columnWidths,
                  defaultVerticalAlignment: widget.verticalAlignment,
                  children: [widget.rowBuilder(i)],
                ),
            ],
          )
        : Table(
            border: widget.bodyBorder ??
                TableBorder(
                  verticalInside: BorderSide(
                    color: AppColor.dividerColor,
                  ),
                  horizontalInside: BorderSide(
                    color: AppColor.dividerColor,
                  ),
                ),
            columnWidths: columnWidths,
            defaultVerticalAlignment: widget.verticalAlignment,
            children: <TableRow>[
              for (int i = 0; i < widget.numberOfRows; i++)
                widget.rowBuilder(i),
            ],
          );
  }

  List<TableRow> _buildColumns({
    required BuildContext context,
    List<String>? headers,
  }) {
    return [
      TableRow(
        children: [
          for (var title in headers!)
            LayoutBuilder(
              builder: (context, size) {
                if (widget.columnHeaderBuilder != null) {
                  var header = widget.columnHeaderBuilder!(context, title);
                  return header;
                }
                final index = headers.indexOf(title);
                final textAlign = _centerHeaders.contains(title)
                    ? TextAlign.center
                    : _rightHeaders.contains(title)
                        ? TextAlign.right
                        : TextAlign.left;
                return Container(
                  height: widget.headerHeight,
                  decoration: BoxDecoration(
                      color: widget.headerColor,
                      borderRadius: index == 0
                          ? const BorderRadius.only(topLeft: Radius.circular(4))
                          : index == headers.length - 1
                              ? const BorderRadius.only(
                                  topRight: Radius.circular(4))
                              : BorderRadius.zero),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            title,
                            style: widget.headerStyle ??
                                Theme.of(context).textTheme.bodyText2,
                            textAlign: textAlign,
                          ),
                        ),
                      ),
                      if (widget.getHeaderButton != null &&
                          widget.getHeaderButton!(context, title) != null)
                        widget.getHeaderButton!(context, title)!,
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    ];
  }
}
