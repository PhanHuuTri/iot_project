import 'package:flutter/material.dart';
import '../../main.dart';

class DataTableJT extends StatefulWidget {
  final List<DataColumn> tableColumns;
  final List<List<DataCell>> tableRows;
  const DataTableJT({
    Key? key,
    required this.tableColumns,
    required this.tableRows,
  }) : super(key: key);

  @override
  _DataTableJTState createState() => _DataTableJTState();
}

class _DataTableJTState extends State<DataTableJT> {
  final _horScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _horScrollController,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _horScrollController,
        physics: const ClampingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.black),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DataTable(
              columns: tableColumns(),
              rows: tableRows(),
              dividerThickness: 0.1,
              horizontalMargin: 0,
              columnSpacing: 0,
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> tableColumns() {
    return List.generate(widget.tableColumns.length, (i) {
      final item = widget.tableColumns[i];
      return item;
    });
  }

  List<DataRow> tableRows() {
    return List.generate(widget.tableRows.length, (i) {
      final item = widget.tableRows[i];
      return DataRow(
        cells: item,
      );
    });
  }
}
