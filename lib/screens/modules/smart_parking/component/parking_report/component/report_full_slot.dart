import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_iot/themes/jt_colors.dart';
import 'package:web_iot/themes/jt_text_style.dart';
import 'package:web_iot/widgets/debouncer/debouncer.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import '../../../../../../core/modules/smart_parking/blocs/report_full_slot/report_full_slot_bloc.dart';
import '../../../../../../core/modules/smart_parking/models/report_full_slot.dart';
import '../../../../../../main.dart';
import '../../../../../../widgets/calendar_popup/calendar_popup.dart';
import '../../../../../../widgets/data_table/table_component.dart';
import '../../../../../../widgets/table/dynamic_table.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xl;
import '../../export_file.dart';

class ReportFullSlot extends StatefulWidget {
  final String route;
  final bool allowExport;
  const ReportFullSlot({
    Key? key,
    required this.route,
    required this.allowExport
  }) : super(key: key);

  @override
  _ReportFullSlotState createState() => _ReportFullSlotState();
}

class _ReportFullSlotState extends State<ReportFullSlot> {
  late Debouncer _debouncer;
  final _filterController = TextEditingController();
  final _now = DateTime.now();
  late int _fromDate;
  late int _toDate;
  late DateTime startDate;
  late DateTime endDate;
  final double columnSpacing = 50;
  final _carReportFullSlotBloc = ReportFullSlotBloc();
  final _motoReportFullSlotBloc = ReportFullSlotBloc();
  final displayedFormat = ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm';

  @override
  void initState() {
    endDate = DateTime.utc(_now.year, _now.month, _now.day, 23, 59);
    startDate = DateTime.utc(_now.year, _now.month - 1, _now.day, 0, 0);
    _fromDate = startDate.millisecondsSinceEpoch;
    _toDate = endDate.millisecondsSinceEpoch;
    _debouncer = Debouncer(delayTime: const Duration(milliseconds: 500));
    _filterController.text =
        '${DateFormat(displayedFormat).format(startDate)} - ${DateFormat(displayedFormat).format(endDate)}';
    _fetchTableData(
      from: _fromDate,
      to: _toDate,
    );
    super.initState();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _carReportFullSlotBloc.dispose();
    _motoReportFullSlotBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: Colors.grey,height: 2,),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: _filtersInput(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReport(isCar: true),
                _buildReport(),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildReport({bool isCar = false}) {
    return Expanded(
      flex: 1,
      child: StreamBuilder(
        stream: isCar
            ? _carReportFullSlotBloc.allData
            : _motoReportFullSlotBloc.allData,
        builder: (context,
            AsyncSnapshot<ApiResponse<ReportFullSlotModel?>> snapshot) {
          if (snapshot.hasData) {
            final details = snapshot.data!.model!.details;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _exportButton(details, isCar: isCar),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    isCar
                        ? ScreenUtil.t(I18nKey.car)!
                        : ScreenUtil.t(I18nKey.bikeAndAnotherVehicle)!,
                  ),
                ),
                _buildTable(
                  details: details,
                ),
                if (details.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(ScreenUtil.t(I18nKey.noData)!),
                  ),
              ],
            );
          } else if (snapshot.hasError) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Align(
              alignment: Alignment.centerLeft,
              child: JTCircularProgressIndicator(
                size: 20,
                strokeWidth: 1.5,
                color: JTColors.buttonColor,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _filtersInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 315,
          child: JTTitleButtonFormField(
            title: ScreenUtil.t(I18nKey.time),
            titleStyle: JTTextStyle.bodyText2(color: JTColors.secondaryText),
            textAlignVertical: TextAlignVertical.center,
            readOnly: true,
            controller: _filterController,
            style: JTTextStyle.bodyText1(color: JTColors.primaryText),
            decoration: InputDecoration(
              fillColor: JTColors.secondaryLight,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: JTColors.secondaryLight,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              hintText: ScreenUtil.t(I18nKey.startTime)! +
                  ' - ' +
                  ScreenUtil.t(I18nKey.endTime)!,
              prefixIcon: ButtonTheme(
                minWidth: 30,
                height: 30,
                child: Icon(
                  Icons.date_range_outlined,
                  size: 16,
                  color: JTColors.primaryText,
                ),
              ),
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // if (checkRoute(widget.route) != true) {
                    //   if (Navigator.of(context).canPop()) {
                    //     Navigator.of(context).pop();
                    //   }
                    // }
                    return CalendarPopupView(
                      barrierDismissible: false,
                      initialStartDate: startDate,
                      initialEndDate: endDate,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      onApplyClick: (DateTime startData, DateTime endData) {
                        setState(() {
                          endDate = DateTime.utc(
                              endData.year, endData.month, endData.day, 23, 59);
                          startDate = DateTime.utc(startData.year,
                              startData.month, startData.day, 0, 0);
                          _filterController.text = _displayFilterTime(
                            startData: startData,
                            endData: endData,
                          );
                          _fromDate = startDate.millisecondsSinceEpoch;
                          _toDate = endDate.millisecondsSinceEpoch;
                          _fetchTableData(
                            from: _fromDate,
                            to: _toDate,
                          );
                        });
                      },
                    );
                  });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTable({
    required List details,
  }) {
    final List<TableHeader> tableHeaders = [
      TableHeader(
        title: ScreenUtil.t(I18nKey.no)!.toUpperCase(),
        width: 60,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.date)!,
        width: 200,
        isConstant: true,
      ),
      TableHeader(
        title: ScreenUtil.t(I18nKey.time)!,
        width: 200,
        isConstant: true,
      ),
    ];
    return DynamicTable(
      columnWidthRatio: tableHeaders,
      numberOfRows: details.length,
      rowBuilder: (index) => _rowFor(
        item: details[index],
        index: index,
      ),
      hasBodyData: true,
      tableBorder: Border.all(color: JTColors.black, width: 1),
      headerBorder: TableBorder(
        bottom: BorderSide(color: JTColors.noticeBackground),
      ),
      headerStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: JTColors.black,
        fontStyle: FontStyle.normal,
      ),
      bodyBorder: TableBorder(
        horizontalInside: BorderSide(
          color: JTColors.noticeBackground,
        ),
      ),
    );
  }

  TableRow _rowFor({
    required int item,
    required int index,
  }) {
    return TableRow(
      children: [
        tableCellText(title: '${index + 1}', alignment: Alignment.center),
        tableCellText(
          title: _parseDisplayedDateTime(item),
        ),
        tableCellText(
          title: _parseDisplayedDateTime(
            item,
            isTime: true,
          ),
        ),
      ],
    );
  }

  String _parseDisplayedDateTime(int? value, {bool isTime = false}) {
    ScreenUtil.init(context);
    if (value != null) {
      final _date = DateTime.fromMillisecondsSinceEpoch(value * 1000);
      final _displayText =
          DateFormat(isTime ? 'HH:mm' : ScreenUtil.t(I18nKey.formatDMY)!)
              .format(_date);
      return _displayText;
    }
    return '';
  }

  String _displayFilterTime({
    required DateTime startData,
    required DateTime endData,
  }) {
    return '${DateFormat(displayedFormat).format(startData)} - ${DateFormat(displayedFormat).format(endData)}';
  }

  _fetchTableData({
    required int from,
    required int to,
  }) async {
    final fromDate = from / 1000;
    final toDate = to / 1000;

    Map<String, dynamic> params = {
      'fromDate': fromDate,
      'toDate': toDate,
    };
    await _carReportFullSlotBloc.reportFullSlotCar(params: params);
    await _motoReportFullSlotBloc.reportFullSlotMoto(params: params);
  }

  Widget _exportButton(List<int> data, {bool isCar = false}) {
    //final enable = true;
    final enable = data.isNotEmpty;
    return SizedBox(
      width: 200,
      child: JTExportButton(
        enable: enable,
        onPressed: enable
            ? () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return ConfirmExportDialog(
                      onPressed: () {
                        exportDataGridToExcel(data: data, isCar: isCar);
                      },
                    );
                  },
                );
              }
            : null,
      ),
    );
  }

  Future<void> exportDataGridToExcel({
    required List<int> data,
    bool isCar = false,
  }) async {
    final reportExcelName = ScreenUtil.t(I18nKey.reportFullSlot)!;
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
    header.setValue(reportExcelName);
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
        .setValue('${ScreenUtil.t(I18nKey.time)!}: ${_filterController.text}');
    headerSub.cellStyle = headerSubStyle;
    headerSub.rowHeight = 60;

    sheet.enableSheetCalculations();
    sheet.importData(_buildExcel(data, isCar), rowIndex, colIndex);
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
    await saveAndLaunchFile(bytes, reportExcelName + '.xlsx');
  }

  List<xl.ExcelDataRow> _buildExcel(
    List<int> data,
    bool isCar,
  ) {
    List<xl.ExcelDataRow> excelDataRows = <xl.ExcelDataRow>[];

    excelDataRows = data.map<xl.ExcelDataRow>((int item) {
      return xl.ExcelDataRow(
        cells: <xl.ExcelDataCell>[
          xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.no)!.toUpperCase(),
              value: data.indexOf(item) + 1),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.date)!,
            value: _parseDisplayedDateTime(
              item,
            ),
          ),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.time)!,
            value: _parseDisplayedDateTime(
              item,
              isTime: true,
            ),
          ),
          xl.ExcelDataCell(
            columnHeader: ScreenUtil.t(I18nKey.vehicleType)!,
            value: isCar
                ? ScreenUtil.t(I18nKey.car)!
                : ScreenUtil.t(I18nKey.bikeAndAnotherVehicle)!,
          ),
        ],
      );
    }).toList();

    return excelDataRows;
  }
}
