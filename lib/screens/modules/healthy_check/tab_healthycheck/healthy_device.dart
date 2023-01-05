import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_iot/core/modules/healthycheck/blocs/Healthy/healthy_bloc.dart';
import 'package:web_iot/widgets/data_table/table_pagination.dart';
import 'package:web_iot/widgets/debouncer/debouncer.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import '../../../../core/modules/smart_parking/models/vehicle_event_model.dart';
import '../../../../core/modules/user_management/models/account_model.dart';
import '../../../../main.dart';
import '../../../../widgets/data_table/table_component.dart';
import '../../../../widgets/table/dynamic_table.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xl;
import 'package:web_iot/screens/modules/smart_parking/component/export_file.dart';
import 'package:web_iot/core/modules/healthycheck/models/healthy_model.dart';

import '../content/dialogShow.dart';

final heakthyDeviceKey = GlobalKey<_DeviceListState>();

class DeviceListHealthyl extends StatefulWidget {
  final HealthyBloc healthylBloc;
  final String route;
  final Function(int) changeTab;
  final TextEditingController keyword;
  final Function(
   int,String, {
    int? limit
  }) fetchDeviceListData;
  final AccountModel currentUser;

  const DeviceListHealthyl ({
    Key? key,
    required this.keyword,
    required this.changeTab,
    required this.fetchDeviceListData,
    required this.healthylBloc,
    required this.route,
    required this.currentUser,
  }) : super(key: key);

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceListHealthyl > {
  late Debouncer _debouncer;
  final _dateController = TextEditingController();
  final _now = DateTime.now();
  late int _fromDate;
  late int _toDate;
  late DateTime startDate;
  late DateTime endDate;
  final double columnSpacing = 50;
  bool isWarning = false;
  int _limit = 10;
  int _count = 0;
  int _page = 0;

  @override
  void initState() {
    startDate = DateTime(_now.year, _now.month, _now.day, 0, 0);
    widget.fetchDeviceListData(1,widget.keyword.toString());
    endDate = startDate.add(const Duration(hours: 23, minutes: 59));
    _fromDate = startDate.millisecondsSinceEpoch;
    _toDate = endDate.millisecondsSinceEpoch;
    _debouncer = Debouncer(delayTime: const Duration(milliseconds: 500));
    super.initState();
     checkDialogPop(context);
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      checkDialogPop(context);
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isWarning)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: AppColor.error,
                      ),
                      child: Center(
                        child: Text(
                          ScreenUtil.t(I18nKey.warning)!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: AppColor.white),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                  child: _filtersInput(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: StreamBuilder(
              stream: widget.healthylBloc.deviceHeathyl,
              builder: (context,
                  AsyncSnapshot<ApiResponse<HealthylDeviceListModel>> snapshot) {
                if (snapshot.hasData) {
                  final devices = snapshot.data!.model!.records;
                  final meta = snapshot.data!.model!.meta;

                  return Column(
                        children: [
                          _buildTable(),
                          
                            Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: TablePagination(
                          onFetch: (index) {
                            debugPrint(index.toString());
                             widget.fetchDeviceListData(index,widget.keyword.toString(), limit: _limit);
                          },
                          pagination: meta,
                        ),
                      ),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          //   child: TablePagination(
                          //     onFetch: (index) {
                          //       widget.fetchDeviceListData(index,widget.keyword.toString(), limit: _limit);
                          //     },
                          //     pagination: meta,
                          //   ),
                          // ),
                        ],
                      );
                } else if (snapshot.hasError) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(snapshot.error.toString()),
                  );
                }
                return Align(
                  alignment: Alignment.centerLeft,
                  child: JTCircularProgressIndicator(
                    size: 20,
                    strokeWidth: 1.5,
                    color: Theme.of(context).textTheme.button!.color!,
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
//các filters thời g7ian, sự kiện, tìm kiếm
  Widget _filtersInput() {
    final displayedFormat = ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm';
    _dateController.text =
        '${DateFormat(displayedFormat).format(startDate)} - ${DateFormat(displayedFormat).format(endDate)}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 437,
          child: JTSearchField(
            controller: widget.keyword,
            // hintText: ScreenUtil.t(I18nKey.searchLicensePlatesUserName)!,
            hintText: ScreenUtil.t(I18nKey.enterdevicename)!,
            onPressed: () {
              setState(
                () {
                  if (widget.keyword.text.isEmpty) return;
                  widget.keyword.text = '';
                },
              );
            },
            onChanged: (newValue) {
              _debouncer.debounce(afterDuration: () {
                widget.fetchDeviceListData(1,
                  newValue,
                );
              });
            },
          ),
        ),
      ],
    );
  }
//Phần phía sau 2 nút tab
  Widget _buildTable() {
    final List<TableHeader> tableHeaders = [
      TableHeader(
        title: ScreenUtil.t(I18nKey.no)!.toUpperCase(),
        width: 100,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.device)!,
        width: (MediaQuery.of(context).size.width-100)*1/9,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.location)!,
        width: (MediaQuery.of(context).size.width-100)*1/9,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.ipAddress)!,
        width: (MediaQuery.of(context).size.width-100)*1/9,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.ipport)!,
        width: (MediaQuery.of(context).size.width-100)*1/9,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.status)!,
        width: (MediaQuery.of(context).size.width-100)*1/9,
      ),
      TableHeader(
        title:'',
        width: (MediaQuery.of(context).size.width-100)*1/9,
      ),
      // TableHeader(
      //   title: ScreenUtil.t(I18nKey.action)!,
      //   width: 150,
      //   isConstant: true,
      // ),
    ];
    return Stack(
      children:[
        StreamBuilder(
        stream:  widget.healthylBloc.deviceHeathyl,
        builder: (context, AsyncSnapshot<ApiResponse<HealthylDeviceListModel>> snapshot) {
          if(snapshot.hasData){
            final healthys = snapshot.data!.model!.records;
            final meta = snapshot.data!.model!.meta;
            _page = meta.page;
              _count = healthys.length;
            return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: LayoutBuilder(
                        builder: (context, size) {
                          return DynamicTable(
                            columnWidthRatio: tableHeaders,
                            numberOfRows: healthys.length,
                            rowBuilder: (index) => _rowFor(
                              item: healthys[index],
                              index: index,
                              meta: meta,
                            ),
                            hasBodyData: true,
                            tableBorder: Border.all(color: AppColor.black, width: 1),
                            headerBorder: TableBorder(
                              bottom: BorderSide(color: AppColor.noticeBackground),
                            ),
                            headerStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColor.black,
                              fontStyle: FontStyle.normal,
                            ),
                            bodyBorder: TableBorder(
                              horizontalInside: BorderSide(
                                color: AppColor.noticeBackground,
                              ),
                            ),
                          );
                        }
                      )
                    )
                  ]
            );
          } else if (snapshot.hasError) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(snapshot.error.toString()),
                  );
                }
                return Align(
                  alignment: Alignment.centerLeft,
                  child: JTCircularProgressIndicator(
                    size: 20,
                    strokeWidth: 1.5,
                    color: Theme.of(context).textTheme.button!.color!,
                  ),
                );
        },
        )
      ]
    );
  }

  TableRow _rowFor({
    required HealthylDeviceModel item,
    required Paging meta,
    required int index,
  }) {
    final recordOffset = meta.recordOffset;

    return TableRow(
      children: [
        tableCellText(
            title: '${recordOffset + index + 1}', alignment: Alignment.center),
        tableCellText(
          title: item.name,
        ),
        tableCellText(
          title: item.description,
        ),
        tableCellText(
          title: item.ip,
        ),
        tableCellText(
          title: item.port,
        ),
        tableCellText(
          title: item.status
        ),
        tableCellText(
          child: InkWell(
            onTap: () {
              showGeneralDialog(context: context, pageBuilder: (context, animation, secondaryAnimation) {
                return DialogDiveceHealThy(deviceItem: item,);
              },);
            },
            child:const Icon( Icons.remove_red_eye, ),
          ),
        ),
      ],
    );
  }
  checkDialogPop(BuildContext context) async {
    if (checkRoute(widget.route) != true) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }
  String _parseDisplayedDateTime(String? value) {
    ScreenUtil.init(context);
    if (value != null && value.isNotEmpty) {
      final _date =
          DateTime.fromMillisecondsSinceEpoch(int.parse(value) * 1000);
      final _displayText =
          DateFormat(ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm')
              .format(_date);
      return _displayText;
    }
    return '';
  }

  List<xl.ExcelDataRow> _buildExcel(
    List<VehicleEventModel> data,
    bool isException,
  ) {
    List<xl.ExcelDataRow> excelDataRows = <xl.ExcelDataRow>[];

    excelDataRows = data.map<xl.ExcelDataRow>((VehicleEventModel reportModel) {
      return xl.ExcelDataRow(
        cells: <xl.ExcelDataCell>[
          xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.no)!.toUpperCase(),
              value: data.indexOf(reportModel) + 1),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.licensePlate)!,
            value: reportModel.plateNumber,
          ),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.timeIn)!,
            value: _parseDisplayedDateTime(reportModel.dateTimeIn),
          ),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.timeOut)!,
            value: _parseDisplayedDateTime(reportModel.dateTimeOut),
          ),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.status)!,
            value: isException
                ? reportModel.eventType
                : ScreenUtil.t(I18nKey.success)!,
          ),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.vehicleType)!,
            value: reportModel.cardGroupName,
          ),
        ],
      );
    }).toList();

    return excelDataRows;
  }

  Future<void> exportDataGridToExcel({
    required List<VehicleEventModel> data,
    bool isException = false,
  }) async {
    final workbook = xl.Workbook();
    xl.Style headerStyle;
    xl.Style headerSubStyle;
    xl.Style tableContentStyle;
    xl.Style signStyle;

    final xl.Worksheet sheet = workbook.worksheets[0];
    const int rowIndex = 4;
    const int colIndex = 3;

    headerStyle = workbook.styles.add('headerStyle');
    headerStyle.fontName = 'Roboto';
    headerStyle.fontSize = 18;
    headerStyle.bold = true;
    headerStyle.hAlign = xl.HAlignType.center;
    headerStyle.vAlign = xl.VAlignType.center;
    headerStyle.borders.left.lineStyle = xl.LineStyle.thin;
    headerStyle.borders.right.lineStyle = xl.LineStyle.thin;
    headerStyle.borders.top.lineStyle = xl.LineStyle.thin;
    headerStyle.borders.all.color = '#000000';
    final header = sheet.getRangeByName('C2:I2');
    header.merge();
    header.setValue(ScreenUtil.t(I18nKey.vehicleList)!);
    header.cellStyle = headerStyle;
    header.rowHeight = 25;

    headerSubStyle = workbook.styles.add('headerSubStyle');
    headerSubStyle.fontName = 'Roboto';
    headerSubStyle.fontSize = 13;
    headerSubStyle.wrapText = true;
    headerSubStyle.hAlign = xl.HAlignType.left;
    headerSubStyle.vAlign = xl.VAlignType.center;
    headerSubStyle.borders.left.lineStyle = xl.LineStyle.thin;
    headerSubStyle.borders.right.lineStyle = xl.LineStyle.thin;
    headerSubStyle.borders.bottom.lineStyle = xl.LineStyle.thin;
    headerSubStyle.borders.all.color = '#000000';
    final headerSub = sheet.getRangeByName('C3:I3');
    headerSub.cellStyle = headerSubStyle;
    headerSub.merge();
    headerSub
        .setValue('${ScreenUtil.t(I18nKey.time)!}: ${_dateController.text}');
    headerSub.cellStyle = headerSubStyle;
    headerSub.rowHeight = 60;

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

    for (var r = rowIndex; r <= data.length + 1 + colIndex; r++) {
      for (var c = colIndex; c < 7 + colIndex; c++) {
        sheet.autoFitColumn(r);
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
        .getRangeByName('H${lastCellIndex + 3}')
        .setValue(ScreenUtil.t(I18nKey.reporter)!);
    sheet.getRangeByName('H${lastCellIndex + 3}').cellStyle = signStyle;
    sheet.getRangeByName('H${lastCellIndex + 3}').cellStyle.bold = true;

    sheet
        .getRangeByName('H${lastCellIndex + 4}')
        .setValue('(${ScreenUtil.t(I18nKey.signature)!})');
    sheet.getRangeByName('H${lastCellIndex + 4}').cellStyle = signStyle;

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    await saveAndLaunchFile(
        bytes, ScreenUtil.t(I18nKey.vehicleList)! + '.xlsx');
  }
}
