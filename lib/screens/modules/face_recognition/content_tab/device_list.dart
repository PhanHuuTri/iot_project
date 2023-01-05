import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_iot/core/modules/face_recog/blocs/device/device_bloc.dart';
import '../../../../core/base/blocs/block_state.dart';
import '../../../../core/modules/face_recog/models/device_model.dart';
import '../../../../main.dart';
import '../../../../widgets/data_table/table_component.dart';
import '../../../../widgets/data_table/table_pagination.dart';
import '../../../../widgets/debouncer/debouncer.dart';
import '../../../../widgets/joytech_components/joytech_components.dart';
import '../../../../widgets/table/dynamic_table.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xl;
import '../../smart_parking/component/export_file.dart';

final faceDeviceKey = GlobalKey<_DeviceListState>();

class DeviceList extends StatefulWidget {
  final Function(int) changeTab;
  const DeviceList({
    Key? key,
    required this.changeTab,
  }) : super(key: key);

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  late Debouncer _debouncer;
  String _errorMessage = '';
  final searchController = TextEditingController();
  final double columnSpacing = 50;
  final _deviceBloc = DeviceBloc();
  // ignore: prefer_final_fields
  int _limit = 10;
  // ignore: prefer_final_fields
  int _page = 1;

  @override
  void initState() {
    _debouncer = Debouncer(delayTime: const Duration(milliseconds: 500));
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _deviceBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: _buildActions(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: _buildTable(),
          ),
        ],
      );
    });
  }

  Widget _buildActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: 437,
              child: JTSearchField(
                controller: searchController,
                hintText: ScreenUtil.t(I18nKey.searchDevice)!,
                onPressed: () {
                  setState(
                    () {
                      if (searchController.text.isEmpty) return;
                      searchController.text = '';
                      _fetchData(1);
                    },
                  );
                },
                onChanged: (newValue) {
                  _debouncer.debounce(afterDuration: () {
                    _fetchData(1);
                  });
                },
              ),
            ),
            JTExportButton(
                enable: true,
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return ConfirmExportDialog(
                        onPressed: () {
                          _deviceBloc.exportObject(params: {}).then((value) {
                            if (value.records.isNotEmpty) {
                              exportDataGridToExcel(data: value.records);
                            } else {
                              setState(() {
                                _errorMessage =
                                    ScreenUtil.t(I18nKey.noDataToExport)!;
                                Timer.periodic(const Duration(seconds: 2),
                                    (timer) {
                                  setState(() {
                                    _errorMessage = '';
                                    timer.cancel();
                                  });
                                });
                              });
                            }
                          });
                        },
                      );
                    },
                  );
                }),
          ],
        ),
        if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  color: Theme.of(context).errorColor,
                  width: 1,
                ),
              ),
              child: Padding(
                child: Text(
                  _errorMessage,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).errorColor),
                ),
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTable() {
    final List<TableHeader> tableHeaders = [
      TableHeader(
        title: ScreenUtil.t(I18nKey.deviceId)!,
        width: 120,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.name)!,
        width: 170,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.deviceGroup)!,
        width: 200,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.deviceType)!,
        width: 200,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.ipAddress)!,
        width: 200,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.deviceStatus)!,
        width: 200,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.deviceFirmware)!,
        width: 200,
        isConstant: true,
      ),
    ];

    return Stack(
      children: [
        StreamBuilder(
          stream: _deviceBloc.allData,
          builder:
              (context, AsyncSnapshot<ApiResponse<DeviceListModel?>> snapshot) {
            if (snapshot.hasData) {
              final doors = snapshot.data!.model!.records;
              final int _total = int.tryParse(snapshot.data!.model!.total)!;
              int _totalPage = (_total / _limit).ceil();
              final Paging meta = Paging.fromJson(
                {
                  "total_records": _total,
                  "limit": _limit,
                  "page": _page,
                  "total_page": _totalPage,
                },
              );

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DynamicTable(
                    tableBorder: Border.all(
                      color: AppColor.white,
                    ),
                    hasBodyData: doors.isNotEmpty,
                    headerColor: AppColor.primary,
                    headerStyle: const TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.w500,
                    ),
                    headerBorder: TableBorder(
                      verticalInside: BorderSide(
                        color: AppColor.dividerColor,
                      ),
                    ),
                    bodyBorder: TableBorder.all(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    columnWidthRatio: tableHeaders,
                    numberOfRows: doors.length,
                    rowBuilder: (index) => _rowFor(
                      item: doors[index],
                    ),
                  ),
                  TablePagination(
                    onFetch: _fetchData,
                    pagination: meta,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: snapshot.error.toString().trim() == 'request timeout'
                    ? Text(ScreenUtil.t(I18nKey.requestTimeOut)!)
                    : Text(snapshot.error.toString()),
              );
            }
            return const SizedBox();
          },
        ),
        StreamBuilder(
          stream: _deviceBloc.allDataState,
          builder: (context, state) {
            if (!state.hasData || state.data == BlocState.fetching) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: JTCircularProgressIndicator(
                    size: 24,
                    strokeWidth: 2.0,
                    color: Theme.of(context).textTheme.button!.color!,
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  TableRow _rowFor({required DeviceModel item}) {
    return TableRow(
      children: [
        tableCellText(title: item.id.toString()),
        tableCellText(
          title: item.name,
        ),
        tableCellText(
          title: item.deviceGroupId.name,
        ),
        tableCellText(
          title: item.deviceTypeId.id.toString(),
        ),
        tableCellText(
          title: item.lan.ip,
        ),
        tableCellText(
          title: item.status.toString(),
        ),
        tableCellText(
          title: item.deviceVersion.firmware,
        ),
      ],
    );
  }

  _fetchData(int page) {
    faceDeviceTabIndex = page;
    Map<String, dynamic> params = {
      'limit': _limit,
      'page': faceDeviceTabIndex,
      'search_string': searchController.text,
    };

    _deviceBloc.fetchAllData(
      params: params,
    );
  }

  List<xl.ExcelDataRow> _buildExcel(
    List<DeviceModel> data,
    bool isException,
  ) {
    List<xl.ExcelDataRow> excelDataRows = <xl.ExcelDataRow>[];

    excelDataRows = data.map<xl.ExcelDataRow>((DeviceModel item) {
      return xl.ExcelDataRow(
        cells: <xl.ExcelDataCell>[
          xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.no)!.toUpperCase(),
              value: data.indexOf(item) + 1),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.deviceId)!,
            value: item.id.toString(),
          ),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.name)!,
            value: item.name,
          ),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.deviceGroup)!,
            value: item.deviceGroupId.name,
          ),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.deviceType)!,
            value: item.deviceTypeId.id.toString(),
          ),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.ipAddress)!,
            value: item.lan.ip,
          ),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.deviceStatus)!,
            value: item.status.toString(),
          ),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.deviceFirmware)!,
            value: item.deviceVersion.firmware,
          ),
        ],
      );
    }).toList();

    return excelDataRows;
  }

  Future<void> exportDataGridToExcel({
    required List<DeviceModel> data,
    bool isException = false,
  }) async {
    final workbook = xl.Workbook();
    xl.Style headerStyle;
    xl.Style tableContentStyle;
    xl.Style signStyle;

    final xl.Worksheet sheet = workbook.worksheets[0];
    const int rowIndex = 4;
    const int colIndex = 3;
    const String firstColCharacter = 'C';
    const String lastColCharacter = 'J';
    String reportName = ScreenUtil.t(I18nKey.deviceList)!;

    headerStyle = workbook.styles.add('headerStyle');
    headerStyle.fontName = 'Roboto';
    headerStyle.fontSize = 18;
    headerStyle.bold = true;
    headerStyle.hAlign = xl.HAlignType.center;
    headerStyle.vAlign = xl.VAlignType.center;
    final header =
        sheet.getRangeByName('${firstColCharacter}2:${lastColCharacter}2');
    header.merge();
    header.setValue(reportName);
    header.cellStyle = headerStyle;
    header.rowHeight = 25;
    header.autoFitColumns();

    sheet.enableSheetCalculations();
    sheet.importData(_buildExcel(data, isException), rowIndex, colIndex);
    sheet.setRowHeightInPixels(rowIndex, 30);

    tableContentStyle = workbook.styles.add('tableContentStyle');
    tableContentStyle.borders.all.lineStyle = xl.LineStyle.thin;
    tableContentStyle.borders.all.color = '#000000';
    tableContentStyle.fontName = 'Roboto';
    tableContentStyle.fontSize = 13;
    tableContentStyle.wrapText = true;
    tableContentStyle.hAlign = xl.HAlignType.center;
    tableContentStyle.vAlign = xl.VAlignType.center;
    final tableContent = sheet.getRangeByName(
        '$firstColCharacter$rowIndex:$lastColCharacter${data.length + 1 + colIndex}');
    tableContent.rowHeight = 30;
    for (var r = rowIndex; r <= data.length + 1 + colIndex; r++) {
      for (var c = colIndex; c < 8 + colIndex; c++) {
        sheet.autoFitColumn(c);
        if (r == rowIndex) {
          sheet.getRangeByIndex(r, c).cellStyle = tableContentStyle;
          sheet.getRangeByIndex(r, c).cellStyle.bold = true;
        } else {
          sheet.getRangeByIndex(r, c).cellStyle = tableContentStyle;
        }
      }
    }
    final lastCellIndex = data.length + colIndex;

    signStyle = workbook.styles.add('signStyle');
    signStyle.fontName = 'Roboto';
    signStyle.fontSize = 13;
    signStyle.hAlign = xl.HAlignType.center;
    signStyle.vAlign = xl.VAlignType.center;

    sheet
        .getRangeByName('$lastColCharacter${lastCellIndex + 3}')
        .setValue(ScreenUtil.t(I18nKey.reporter)!);
    sheet.getRangeByName('$lastColCharacter${lastCellIndex + 3}').cellStyle =
        signStyle;
    sheet
        .getRangeByName('$lastColCharacter${lastCellIndex + 3}')
        .cellStyle
        .bold = true;

    sheet
        .getRangeByName('$lastColCharacter${lastCellIndex + 4}')
        .setValue('(${ScreenUtil.t(I18nKey.signature)!})');
    sheet.getRangeByName('$lastColCharacter${lastCellIndex + 4}').cellStyle =
        signStyle;

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    await saveAndLaunchFile(bytes, reportName + '.xlsx');
  }

  fetchData() {
    _deviceBloc.fetchAllData(params: {});
  }
}
