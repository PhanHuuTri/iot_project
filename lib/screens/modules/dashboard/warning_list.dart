import 'package:flutter/material.dart';
import 'package:web_iot/config/fake_data.dart';
import 'package:web_iot/main.dart';
import 'package:web_iot/widgets/data_table/table_pagination.dart';
import '../../../widgets/data_table/table_component.dart';
import '../../../widgets/table/dynamic_table.dart';

class WarningList extends StatefulWidget {
  const WarningList({Key? key}) : super(key: key);

  @override
  _WarningListState createState() => _WarningListState();
}

class _WarningListState extends State<WarningList> {
  int _page = 1;
  final columnSpacing = 10;
  final List<TableHeader> warningTableHeaders = [
    TableHeader(title: 'Id', width: 70, isConstant: true),
    TableHeader(
      title: ScreenUtil.t(I18nKey.name)!,
      width: 200,
    ),
    TableHeader(
        title: ScreenUtil.t(I18nKey.warning)!, width: 300, isConstant: true),
    TableHeader(
        title: ScreenUtil.t(I18nKey.location)!, width: 150, isConstant: true),
    TableHeader(
        title: ScreenUtil.t(I18nKey.warningTime)!,
        width: 160,
        isConstant: true),
    TableHeader(
        title: ScreenUtil.t(I18nKey.status)!, width: 150, isConstant: true),
  ];
  void tableOnFetch(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Paging meta = Paging.fromJson(
      {
        "total_records": warningTableRows.length,
        "limit": 5,
        "page": _page,
        "total_page": warningTableRows.length ~/ 5,
      },
    );
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: DynamicTable(
              columnWidthRatio: warningTableHeaders,
              headerStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyText1!.color,
                fontStyle: FontStyle.normal,
              ),
              numberOfRows: warningTableRows.length,
              rowBuilder: (index) => _rowFor(
                item: warningTableRows[index],
              ),
              headerBorder: TableBorder(
                bottom: BorderSide(
                  color: AppColor.dividerColor.withOpacity(0.2),
                ),
              ),
              bodyBorder: TableBorder(
                horizontalInside: BorderSide(
                  color: AppColor.dividerColor.withOpacity(0.2),
                ),
              ),
              hasBodyData: true,
            ),
          ),
          TablePagination(
            onFetch: tableOnFetch,
            pagination: meta,
            onLeft: true,
          ),
        ],
      ),
    );
  }

  _rowFor({required WarningModel item}) {
    return TableRow(
      children: [
        tableCellText(title: item.id!),
        tableCellText(
          title: item.name!,
        ),
        tableCellText(
          title: item.warning!,
        ),
        tableCellText(
          title: item.location!,
        ),
        tableCellText(
          title: item.warningTime!,
        ),
        tableCellText(
          title: item.status!,
        ),
      ],
    );
  }
}
