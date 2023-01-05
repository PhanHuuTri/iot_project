import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_iot/core/modules/face_recog/blocs/event/event_bloc.dart';
import '../../../../../core/modules/face_recog/models/event_model.dart';
import '../../../../../main.dart';
import '../../../../../widgets/calendar_popup/calendar_popup.dart';
import '../../../../../widgets/debouncer/debouncer.dart';
import '../../../../../widgets/joytech_components/joytech_components.dart';
import 'package:intl/intl.dart';
import '../../../smart_parking/component/export_file.dart';
import 'event_action_history.dart';
import 'event_inout_history.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xl;

final faceEventKey = GlobalKey<_EventListState>();

class EventList extends StatefulWidget {
  final Function(int) changeTab;
  final TextEditingController keyword;
  final bool allowViewEventHistory;
  const EventList({
    Key? key,
    required this.keyword,
    required this.changeTab,
    required this.allowViewEventHistory,
  }) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  // ignore: unused_field
  final _padding = 16.0;
  late Debouncer _debouncer;
  String _errorMessage = '';
  final _dateController = TextEditingController();
  final _now = DateTime.now();
  late int _fromDate;
  late int _toDate;
  late DateTime startDate;
  late DateTime endDate;
  final double columnSpacing = 50;
  bool isWarning = false;
  final _eventBloc = EventBloc();
  final _eventOperationBloc = EventBloc();
  final List<String> _eventType = [];
  String _hint = '';
  int eventSelectedList = 0;

  @override
  void initState() {
    startDate = DateTime(1970, 1, 1, 0, 0);
    endDate = DateTime(_now.year, _now.month, _now.day, 23, 59);
    _fromDate = startDate.millisecondsSinceEpoch;
    _toDate = endDate.millisecondsSinceEpoch;
    _debouncer = Debouncer(delayTime: const Duration(milliseconds: 500));
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _eventBloc.dispose();
    _eventOperationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _filtersInput(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildActions(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildTable(),
          ),
        ],
      );
    });
  }

  Widget _filtersInput() {
    final normalStyle = Theme.of(context).textTheme.bodyText1;
    final displayedFormat = ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm';
    _dateController.text =
        '${DateFormat(displayedFormat).format(startDate)} - ${DateFormat(displayedFormat).format(endDate)}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 315,
          child: JTTitleButtonFormField(
            title: ScreenUtil.t(I18nKey.time),
            titleStyle: Theme.of(context).textTheme.bodyText2,
            textAlignVertical: TextAlignVertical.center,
            readOnly: true,
            controller: _dateController,
            style: normalStyle,
            decoration: InputDecoration(
              fillColor: AppColor.secondaryLight,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor.secondaryLight,
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
                  color: normalStyle!.color,
                ),
              ),
            ),
            onPressed: () {
              showDialog<dynamic>(
                  context: context,
                  builder: (BuildContext context) {
                    return CalendarPopupView(
                      barrierDismissible: false,
                      initialStartDate: startDate,
                      initialEndDate: endDate,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      onApplyClick: (DateTime startData, DateTime endData) {
                        setState(() {
                          startDate = startData;
                          endDate = endData;
                          _dateController.text =
                              '${DateFormat(displayedFormat).format(startDate)} - ${DateFormat(displayedFormat).format(endDate)}';
                          _fromDate = startDate.millisecondsSinceEpoch;
                          _toDate = endDate.millisecondsSinceEpoch;
                          if (eventSelectedList == 0) {
                            fetchData();
                          } else {
                            _fetchOperationData(1);
                          }
                        });
                      },
                    );
                  });
            },
          ),
        ),
        SizedBox(
          width: 437,
          child: JTSearchField(
            controller: widget.keyword,
            hintText: ScreenUtil.t(I18nKey.searchRoom)!,
            onPressed: () {
              setState(
                () {
                  if (widget.keyword.text.isEmpty) return;
                  widget.keyword.text = '';
                  if (eventSelectedList == 0) {
                    fetchData();
                  } else {
                    _fetchOperationData(1);
                  }
                },
              );
            },
            onChanged: (newValue) {
              _debouncer.debounce(afterDuration: () {
                if (eventSelectedList == 0) {
                  fetchData();
                } else {
                  _fetchOperationData(1);
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    final enable = _dateController.text.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          height: 36,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTabButton(),
              JTExportButton(
                enable: enable,
                onPressed: enable
                    ? () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return ConfirmExportDialog(
                              onPressed: () {
                                _exportAction();
                              },
                            );
                          },
                        );
                      }
                    : null,
              ),
            ],
          ),
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

  _buildTabButton() {
    final tabs = [
      ScreenUtil.t(I18nKey.eventInOutHistory)!,
      ScreenUtil.t(I18nKey.eventUserHistory)!
    ];

    return LayoutBuilder(builder: (context, size) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var tab in tabs)
            LayoutBuilder(builder: (context, size) {
              final tabIndex = tabs.indexOf(tab);
              final enable = eventSelectedList == tabIndex;

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: enable ? AppColor.primary : Colors.transparent,
                    border: Border.all(
                      color: enable ? AppColor.primary : AppColor.subTitle,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Center(
                        child: Text(
                          tab,
                          style: TextStyle(
                            color: enable ? AppColor.white : AppColor.subTitle,
                          ),
                        ),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(50),
                    hoverColor: AppColor.secondary2,
                    onTap: () {
                      setState(() {
                        eventSelectedList = tabIndex;
                        if (eventSelectedList == 0) {
                          fetchData();
                        } else {
                          _fetchOperationData(1);
                        }
                      });
                    },
                  ),
                ),
              );
            }),
        ],
      );
    });
  }

  Widget _buildTable() {
    return eventSelectedList == 0
        ? StreamBuilder(
            stream: _eventBloc.allData,
            builder: (context,
                AsyncSnapshot<ApiResponse<EventListModel?>> snapshot) {
              if (snapshot.hasData) {
                final events = snapshot.data!.model!.records;
                return EventInOutHitory(
                  eventBloc: _eventBloc,
                  onFetch: fetchData,
                  eventType: _eventType,
                  listEventData: events,
                  isInitData: _hint.isEmpty,
                );
              } else {
                return EventInOutHitory(
                  eventBloc: _eventBloc,
                  onFetch: fetchData,
                  eventType: _eventType,
                );
              }
            },
          )
        : EventActionHitory(
            eventOperationBloc: _eventOperationBloc,
            onFetch: _fetchOperationData,
            eventType: _eventType,
          );
  }

  fetchData({
    List<String>? eventType,
    String? hint,
  }) {
    setState(() {
      if (eventType != null) {
        if (_eventType != eventType) {
          if (_eventType.isNotEmpty) {
            _eventType.clear();
          }
          _eventType.addAll(eventType);
        }
      }
      if (eventSelectedList == 0) {
        Map<String, dynamic> params = {
          'fromDate': _fromDate,
          'toDate': _toDate,
          'doorID': widget.keyword.text,
          'limit': 10,
          'eventType': _eventType,
        };
        if (hint != null && hint.isNotEmpty) {
          _hint = hint;
          params['hint'] = _hint;
        } else {
          _hint = '';
        }
        _eventBloc.fetchEventsData(params: params);
      } else {
        Map<String, dynamic> params = {
          'fromDate': _fromDate,
          'toDate': _toDate,
          'limit': 10,
          'page': 1,
          'doorID': widget.keyword.text,
        };
        if (eventType != null && eventType.isNotEmpty) {
          params['eventType'] = eventType;
        }
        _eventOperationBloc.fetchOperationData(params: params);
      }
    });
  }

  _fetchOperationData(int page, {List<String>? eventType}) {
    Map<String, dynamic> params = {
      'fromDate': _fromDate,
      'toDate': _toDate,
      'limit': 10,
      'page': page,
      'doorID': widget.keyword.text,
    };
    if (eventType != null && eventType.isNotEmpty) {
      params['eventType'] = eventType;
    }
    _eventOperationBloc.fetchOperationData(params: params);
  }

  List<xl.ExcelDataRow> _buildExcel(
    List<EventModel> data,
    bool isException,
  ) 
  {
    List<xl.ExcelDataRow> excelDataRows = <xl.ExcelDataRow>[];
    if (eventSelectedList == 0) {
      excelDataRows = data.map<xl.ExcelDataRow>((EventModel item) {
        String displayEvent = '';
        if (item.eventTypeId.code == '4867') {
          displayEvent = ScreenUtil.t(I18nKey.identifySuccessFace)!;
        }
        if (item.eventTypeId.code == '5125') {
          displayEvent = ScreenUtil.t(I18nKey.identifyFailFace)!;
        }
        return xl.ExcelDataRow(
          cells: <xl.ExcelDataCell>[
            xl.ExcelDataCell(
                columnHeader: ScreenUtil.t(I18nKey.no)!.toUpperCase(),
                value: data.indexOf(item) + 1),
            xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.room)!,
              value:
                  item.doorModels.isNotEmpty ? item.doorModels.first.name : '',
            ),
            xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.event)!,
              value: displayEvent,
            ),
            xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.faceRecoUser)!,
              value: item.userId.name,
            ),
            xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.faceRecoGroupUser)!,
              value: item.userGroupId.name,
            ),
            xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.date)!,
              value: _parseDisplayedDate(item.datetime),
            ),
            xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.time)!,
              value: _parseDisplayedTime(item.datetime),
            ),
            xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.deviceId)!,
              value: item.deviceId.id,
            ),
          ],
        );
      }).toList();
    } else {
      excelDataRows = data.map<xl.ExcelDataRow>((EventModel item) {
        String displayEvent = '';
        if (item.event == 'lock') {
          displayEvent = ScreenUtil.t(I18nKey.lock)!;
        }
        if (item.event == 'unlock') {
          displayEvent = ScreenUtil.t(I18nKey.unlock)!;
        }
        if (item.event == 'open') {
          displayEvent = ScreenUtil.t(I18nKey.openDoor)!;
        }
        return xl.ExcelDataRow(
          cells: <xl.ExcelDataCell>[
            xl.ExcelDataCell(
                columnHeader: ScreenUtil.t(I18nKey.no)!.toUpperCase(),
                value: data.indexOf(item) + 1),
            xl.ExcelDataCell(
                columnHeader: ScreenUtil.t(I18nKey.room)!,
                value: item.doorModels.isNotEmpty
                    ? item.doorModels.first.name
                    : ''),
            xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.eventUser)!,
              value: item.userId.name,
            ),
            xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.email)!,
              value: item.userEmail,
            ),
            xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.date)!,
              value: _parseDisplayedDate(item.datetime),
            ),
            xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.time)!,
              value: _parseDisplayedTime(item.datetime),
            ),
            xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.deviceId)!,
              value: item.deviceId.id,
            ),
            xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.event)!,
              value: displayEvent,
            ),
          ],
        );
      }).toList();
    }
    return excelDataRows;
  }

  Future<void> exportDataGridToExcel({
    required List<EventModel> data,
    bool isException = false,
  }) async
  {
    final workbook = xl.Workbook();
    xl.Style headerStyle;
    xl.Style tableContentStyle;
    xl.Style signStyle;

    final xl.Worksheet sheet = workbook.worksheets[0];
    const int rowIndex = 4;
    const int colIndex = 3;
    const String firstColCharacter = 'C';
    const String lastColCharacter = 'J';
    String reportName = eventSelectedList == 0
        ? ScreenUtil.t(I18nKey.eventInOutHistory)!
        : ScreenUtil.t(I18nKey.eventUserHistory)!;

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

  String _parseDisplayedDate(dynamic value) {
    ScreenUtil.init(context);
    String _displayedValue = '';
    if (value != null && value.isNotEmpty) {
      final format = ScreenUtil.t(I18nKey.formatDMY)!;
      if (value is int) {
        if (value != 0) {
          final _dateTime = DateTime.fromMillisecondsSinceEpoch(value);
          final _dateTimeLocal = _dateTime.toLocal();
          _displayedValue = DateFormat(format).format(_dateTimeLocal);
        }
      } else if (value is String) {
        final _dateTime = DateTime.tryParse(value);
        final _dateTimeLocal = _dateTime!.toLocal();
        _displayedValue = DateFormat(format).format(_dateTimeLocal);
      }
    }
    return _displayedValue;
  }

  String _parseDisplayedTime(dynamic value) {
    ScreenUtil.init(context);
    String _displayedValue = '';
    if (value != null && value.isNotEmpty) {
      const format = 'HH:mm:ss';
      if (value is int) {
        if (value != 0) {
          final _dateTime = DateTime.fromMillisecondsSinceEpoch(value);
          final _dateTimeLocal = _dateTime.toLocal();
          _displayedValue = DateFormat(format).format(_dateTimeLocal);
        }
      } else if (value is String) {
        final _dateTime = DateTime.tryParse(value);
        final _dateTimeLocal = _dateTime!.toLocal();
        _displayedValue = DateFormat(format).format(_dateTimeLocal);
      }
    }
    return _displayedValue;
  }

  _exportAction() {
    if (eventSelectedList == 0) {
      _eventBloc.exportEvent(params: {
        'fromDate': _fromDate,
        'toDate': _toDate,
        'doorID': widget.keyword.text,
      }).then((value) {
        if (value.records.isNotEmpty) {
          exportDataGridToExcel(data: value.records);
        } else {
          setState(() {
            _errorMessage = ScreenUtil.t(I18nKey.noDataToExport)!;
            Timer.periodic(const Duration(seconds: 2), (timer) {
              setState(() {
                _errorMessage = '';
                timer.cancel();
              });
            });
          });
        }
      });
    } else {
      _eventOperationBloc.exportEventOperation(params: {
        'fromDate': _fromDate,
        'toDate': _toDate,
        'doorID': widget.keyword.text,
      }).then((value) {
        if (value.records.isNotEmpty) {
          exportDataGridToExcel(data: value.records);
        } else {
          setState(() {
            _errorMessage = ScreenUtil.t(I18nKey.noDataToExport)!;
            Timer.periodic(const Duration(seconds: 2), (timer) {
              setState(() {
                _errorMessage = '';
                timer.cancel();
              });
            });
          });
        }
      });
    }
  }
}
