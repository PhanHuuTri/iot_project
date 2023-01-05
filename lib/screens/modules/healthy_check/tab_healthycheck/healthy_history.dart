import 'dart:async';
import 'package:flutter/material.dart';
import 'package:validators/sanitizers.dart';
import 'package:web_iot/config/svg_constants.dart';
import 'package:web_iot/core/base/blocs/block_state.dart';
import 'package:web_iot/screens/modules/healthy_check/content/dialogContentHistory.dart';
import 'package:web_iot/screens/modules/healthy_check/content/dialogShow.dart';
import 'package:web_iot/screens/modules/healthy_check/modelDialog/filter_model.dart';
import 'package:web_iot/core/modules/healthycheck/models/healthy_model.dart';
import 'package:web_iot/open_sources/popover/popover.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/screens/modules/healthy_check/modelDialog/dialogfilterevenhistory.dart';
import 'package:web_iot/screens/modules/smart_parking/component/export_file.dart';
import 'package:web_iot/widgets/data_table/table_pagination.dart';
import 'package:web_iot/widgets/debouncer/debouncer.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import 'package:web_iot/widgets/table_columns/table_column_date_time.dart';
import '../../../../core/modules/healthycheck/blocs/Healthy/healthy_bloc.dart';
import '../../../../core/modules/user_management/models/account_model.dart';
import '../../../../main.dart';
import '../../../../open_sources/popover/src/popover.dart';
import '../../../../widgets/calendar_popup/calendar_popup.dart';
import '../../../../widgets/data_table/table_component.dart';
import '../../../../widgets/table/dynamic_table.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xl;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:web_iot/core/modules/face_recog/blocs/event/event_bloc.dart';

import '../content/dialogHistoryFilter.dart';

//Xuất pdf
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

final heakthyHistoryKey = GlobalKey<_HealthyHistoryState>();

class HealthyHistory extends StatefulWidget {
  final HealthyBloc healthyBloc;
  final String route;

  final TextEditingController keyword;
  final Function(List<String>)? onStatusChanged;
  final Function(String)? onUpdateTimeChanged;
  final Function(
    int,
    String,
    String, {
    required int from,
    required int to,
  }) fetchHistoryData;
  final AccountModel currentUser;

  const HealthyHistory({
    Key? key,
    required this.keyword,
    this.onStatusChanged,
    this.onUpdateTimeChanged,
    required this.fetchHistoryData,
    required this.healthyBloc,
    required this.route,
    required this.currentUser,
  }) : super(key: key);

  @override
  _HealthyHistoryState createState() => _HealthyHistoryState();
}

class Combobox {
  String name;
  String highTemperature;
  String mask;
  Combobox(this.name, this.highTemperature, this.mask);
}

class _HealthyHistoryState extends State<HealthyHistory> {
  late Debouncer _debouncer;
  final _dateController = TextEditingController();
  final _eventController = TextEditingController();
  final _now = DateTime.now();
  late int _fromDate;
  late int _toDate;
  late DateTime startDate;
  late DateTime endDate;
  Combobox? selectedValue;
  int selectedcboindex = 0;
  final double columnSpacing = 50;

  bool isWarning = false;
  bool click_date = false;
  String _errorMessage = '';
  bool _allowExport = false;
  final List<String> _eventType = [];
  int eventSelectedList = 0;
  String _hint = '';
  final _eventBloc = EventBloc();
  final _eventOperationBloc = EventBloc();
  bool _isDownloading = false;
  int _limit = 7;
  int _count = 0;
  int _page = 0;
  late List<HistoryModel> data;
  List<Combobox> items = [];
  List<HistoryModel> healthys = [];
  List<FilterEvent> eventSelectHealthy = [];
  bool isShowFilterStatus = false;
  FilterEventHistory? filterEventModel;
  final filter = FilterEventHistory(
      high: false, mask: false, nohigh: false, nomask: false);

  @override
  void initState() {
    startDate = DateTime(1970, 1, 1, 0, 0);
    endDate = DateTime(_now.year, _now.month, _now.day, 23, 59);
    _fromDate = startDate.microsecondsSinceEpoch;
    _toDate = endDate.millisecondsSinceEpoch;
    items = [
      Combobox(ScreenUtil.t(I18nKey.normal)!, 'no', 'yes'),
      Combobox(ScreenUtil.t(I18nKey.hightemperature)!, 'yes', ''),
      Combobox(ScreenUtil.t(I18nKey.notwearingmask)!, '', 'no'),
      Combobox(
          ScreenUtil.t(I18nKey.hightemperature)! +
              ' & ' +
              ScreenUtil.t(I18nKey.notwearingmask)!,
          'yes',
          'no'),
    ];
    _getPerrmisson();
    _debouncer = Debouncer(delayTime: const Duration(milliseconds: 500));
    // widget.fetchHistoryData(
    //   1,
    //   //widget.keyword.text,
    //   '',
    //   '',
    //   from: _fromDate,
    //   to: _toDate,
    // );
    setItem(filter);
    super.initState();
    checkDialogPop(context);
  }

  // final List<Combobox> items =
  @override
  void dispose() {
    _debouncer.dispose();
    eventHealthy.clear();
    super.dispose();
  }

  @override
  void didUpdateWidget(HealthyHistory oldWidget) {
    //debugPrint('State didUpdateWidget');
    items.clear();

    items.add(Combobox(ScreenUtil.t(I18nKey.normal)!, 'no', 'yes'));
    items.add(Combobox(ScreenUtil.t(I18nKey.hightemperature)!, 'yes', ''));
    items.add(Combobox(ScreenUtil.t(I18nKey.notwearingmask)!, '', 'no'));
    items.add(Combobox(
        ScreenUtil.t(I18nKey.hightemperature)! +
            ' & ' +
            ScreenUtil.t(I18nKey.notwearingmask)!,
        'yes',
        'no'));
    selectedValue = items[selectedcboindex];
    eventHealthy.clear();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    //didUpdateWidget(widget);
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
                  child: _filtersInput(items),
                ),
                filterlist(eventHealthy),
                _buildActions(),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Divider(),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: StreamBuilder(
              stream: widget.healthyBloc.historyData,
              builder: (context,
                  AsyncSnapshot<ApiResponse<HistorylListModel>> snapshot) {
                if (snapshot.hasData) {
                  healthys = snapshot.data!.model!.records;
                  //data = healthys;
                  final meta = snapshot.data!.model!.meta;
                  return Column(
                    children: [
                      //_buildTable(),
                      _tableWidget(healthys, context),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: TablePagination(
                          onFetch: (index) {
                            //debugPrint(index.toString());
                            widget.fetchHistoryData(
                                index,
                                //widget.keyword.toString(),
                                filter.mask == true
                                    ? 'yes'
                                    : filter.nomask == true
                                        ? 'no'
                                        : '',
                                filter.high == true
                                    ? 'yes'
                                    : filter.nohigh == true
                                        ? 'no'
                                        : '',
                                from: _fromDate,
                                to: _toDate);
                          },
                          pagination: meta,
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {}
                return SizedBox();
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _tableWidget(List<HistoryModel> historys, BuildContext context) {
    final header = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _sizeBoxTable(150, ScreenUtil.t(I18nKey.image)!, true, false, context),
        _sizeBoxTable(
            250, ScreenUtil.t(I18nKey.dateCreated)!, true, false, context),
        _sizeBoxTable(250, ScreenUtil.t(I18nKey.status)!, true, true, context),
        _sizeBoxTable(250, ScreenUtil.t(I18nKey.device)!, true, false, context),
        _sizeBoxTable(
            250, ScreenUtil.t(I18nKey.location)!, true, false, context)
      ],
    );
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: historys.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    header,
                    const Divider(),
                  ],
                );
              } else {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return ContentHistory(
                              history: historys[index],
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _imageTable(150, historys[index - 1].urlImage),
                          _sizeBoxTable(
                              250,
                              _formatDateTime(historys[index - 1].createTime),
                              false,
                              false,
                              context),
                          _iconsStatus(
                              historys[index - 1].mask,
                              historys[index - 1].highTemperature,
                              historys[index - 1].currTemperature),
                          _sizeBoxTable(250, historys[index - 1].channelName,
                              false, false, context),
                          _sizeBoxTable(250, historys[index - 1].region, false,
                              false, context),
                        ],
                      ),
                    ),
                    const Divider(color: Colors.grey),
                  ],
                );
              }
            }),
      ],
    );
  }

  List<FilterEvent> setItem(FilterEventHistory filter) {
    return eventHealthy = [
      FilterEvent(
          title: 'Nhiệt độ bình thường',
          urlImage: SvgIcons.nothermometer,
          check: filter.nohigh ?? false),
      FilterEvent(
          title: 'Nhiệt độ cao',
          urlImage: SvgIcons.thermometer,
          check: filter.high ?? false),
      FilterEvent(
          title: 'Có khẩu trang',
          urlImage: SvgIcons.mask,
          check: filter.mask ?? false),
      FilterEvent(
          title: 'Không có khẩu trang',
          urlImage: SvgIcons.nomask,
          check: filter.nomask ?? false),
    ];
  }

  Widget _iconsStatus(String isMask, String isHigh, double totalHigh) {
    return SizedBox(
      width: 250,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isMask == 'no'
                ? Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red),
                    ),
                    child: Tooltip(
                      message: 'Không đeo khẩu trang',
                      child: SvgIcon(
                        SvgIcons.nomask,
                        color: Colors.red,
                      ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(4),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green),
                    ),
                    child: Tooltip(
                      message: 'Đeo khẩu trang',
                      child: SvgIcon(
                        SvgIcons.mask,
                        color: Colors.green,
                      ),
                    ),
                  ),
            const SizedBox(
              width: 5,
            ),
            isHigh == 'yes'
                ? Wrap(
                  // alignment:WrapAlignment.center,
                  children: [
                    Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red),
                        ),
                        child: Tooltip(
                            message: 'Quá nhiệt',
                            child: SvgIcon(
                              SvgIcons.thermometer,
                              color: Colors.red,
                            )),
                      ),
                      SizedBox(width: 5,),
                      Align(alignment: Alignment.center,child: SizedBox(height: 30,child: Text(totalHigh.toStringAsFixed(1),style:const TextStyle(fontSize: 25,color:Colors.red ),)))
                  ],
                )
                : Wrap(
                  // alignment:WrapAlignment.center,
                  children: [
                    Container(
                        width: 30,
                        height: 30,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green),
                        ),
                        child: Tooltip(
                          message: 'Nhiệt bình thường',
                          child:
                              SvgIcon(SvgIcons.nothermometer, color: Colors.green),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Align(alignment: Alignment.center,child: SizedBox(height: 30,child: Text(totalHigh.toStringAsFixed(1),style:const TextStyle(fontSize: 25,color:Colors.green ),)))
                  ],
                ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(dynamic value) {
    final format = ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm:ss';
    String _displayedValue = '';
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
    return _displayedValue;
  }

  Widget _imageTable(double size, String urlImage) {
    return Container(
      width: size,
      height: size * 0.7,
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13))),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        child: Image.network(
          urlImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _sizeBoxTable(double size, String content, bool isHeader, bool status,
      BuildContext context) {
    if (status == true) {
      return Container(
        padding: const EdgeInsets.only(right: 20, left: 0),
        width: size,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Text(content,
                style: TextStyle(
                    fontWeight: isHeader == true
                        ? FontWeight.bold
                        : FontWeight.normal)),
            IconButton(
                onPressed: () {
                  isShowFilterStatus = true;
                  showPopover(
                    context: context,
                    bodyBuilder: (content) {
                      return FilterStatus(
                        itemFilter: eventHealthy,
                        itemSelectFilter: eventSelectHealthy,
                        filter: filter,
                        //boolEvent: filterEventModel!,
                        addFilterHistory: addItemEventFilter,
                      );
                    },
                    direction: PopoverDirection.bottom,
                    width: 250,
                    height: 250,
                    arrowHeight: 15,
                    arrowWidth: 30,
                  ).whenComplete(() {
                    isShowFilterStatus = false;
                    addItemEventFilter(eventHealthy, filter);
                    widget.fetchHistoryData(
                        1,
                        //widget.keyword.toString(),
                        filter.mask == true
                            ? 'yes'
                            : filter.nomask == true
                                ? 'no'
                                : '',
                        filter.high == true
                            ? 'yes'
                            : filter.nohigh == true
                                ? 'no'
                                : '',
                        from: _fromDate,
                        to: _toDate);
                  });
                  //debugPrint("Đã có số item là: "+eventSelectHealthy.length.toString());
                },
                icon: const Icon(
                  Icons.filter_list_outlined,
                ))
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(18),
        width: size,
        child: Center(
          child: Text(content,
              style: TextStyle(
                  fontWeight:
                      isHeader == true ? FontWeight.bold : FontWeight.normal)),
        ),
      );
    }
  }

  void addItemEventFilter(List<FilterEvent> items, FilterEventHistory filter) {
    setState(() {
      //eventHealthy.clear();
      eventHealthy = items;
      filter = this.filter;
    });
  }

//các filters thời gian, sự kiện, tìm kiếm
  Widget _filtersInput(List<Combobox> itemscb) {
    final normalStyle = Theme.of(context).textTheme.bodyText1;
    final displayedFormat = ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm';
    _dateController.text =
        '${DateFormat(displayedFormat).format(startDate)} - ${DateFormat(displayedFormat).format(endDate)}';
    // _dateController.text="Khoảng thời gian: hh:mm-hh:mm Ngày: dd/mm/yyy";
    _eventController.text = "Các sự kiện: quá nhiệt, không khẩu trang";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 387, //387
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
              hintText: 'Chọn ngày kiểm tra lịch sử ...',
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
                          click_date = true;
                          startDate = startData;
                          endDate = endData;
                          _dateController.text =
                              '${DateFormat(displayedFormat).format(startDate)} - ${DateFormat(displayedFormat).format(endDate)}';
                          _fromDate = startDate.millisecondsSinceEpoch;
                          _toDate = endDate.millisecondsSinceEpoch;
                          widget.fetchHistoryData(
                              1,
                              //widget.keyword.toString(),
                              filter.mask == true
                                  ? 'yes'
                                  : filter.nomask == true
                                      ? 'no'
                                      : '',
                              filter.high == true
                                  ? 'yes'
                                  : filter.nohigh == true
                                      ? 'no'
                                      : '',
                              from: _fromDate,
                              to: _toDate);
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

  Widget listViewflilter(String item, SvgIconData? urlImage, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, bottom: 20),
      child: Container(
        padding: const EdgeInsets.only(top: 6, bottom: 6, right: 14, left: 14),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: urlImage == null ? Colors.red : hexToColor('#90DFAA'),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                color: Colors.grey,
                offset: Offset(
                  5.0,
                  3.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 1.0,
              )
            ]),
        constraints: const BoxConstraints(
          maxWidth: 500,
          //maxHeight: 70
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            urlImage != null
                ? SvgIcon(
                    urlImage,
                    color: value == 'nomask' || value == 'high'
                        ? Colors.red
                        : Colors.green,
                  )
                : const SizedBox(),
            const SizedBox(
              width: 13,
            ),
            Text(
              item,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              width: 13,
            ),
            IconButton(
                color: Colors.white,
                hoverColor: Colors.white,
                focusColor: Colors.white,
                onPressed: () {
                  setState(() {
                    if (urlImage == null) {
                      filter.set();
                    } else if (value == 'nohigh') {
                      filter.checknohigh();
                    } else if (value == 'high') {
                      filter.checkhigh();
                    } else if (value == 'mask') {
                      filter.checkmask();
                    } else if (value == 'nomask') {
                      filter.checknomask();
                    }
                    setItem(filter);
                    widget.fetchHistoryData(
                        1,
                        //widget.keyword.toString(),
                        filter.mask == true
                            ? 'yes'
                            : filter.nomask == true
                                ? 'no'
                                : '',
                        filter.high == true
                            ? 'yes'
                            : filter.nohigh == true
                                ? 'no'
                                : '',
                        from: _fromDate,
                        to: _toDate);
                  });
                },
                icon: const Icon(
                  Icons.close,
                  size: 22,
                ))
          ]),
        ),
      ),
    );
  }

  Widget filterlist(List<FilterEvent> items) {
    items;
    if (items[0].check == false &&
        items[1].check == false &&
        items[2].check == false &&
        items[3].check == false) {
      return const SizedBox();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(ScreenUtil.t(I18nKey.filter)!)),
          Wrap(children: [
            items[0].check == true
                ? listViewflilter(items[0].title, items[0].urlImage, 'nohigh')
                : const SizedBox(),
            items[1].check == true
                ? listViewflilter(items[1].title, items[1].urlImage, 'high')
                : const SizedBox(),
            items[2].check == true
                ? listViewflilter(items[2].title, items[2].urlImage, 'mask')
                : const SizedBox(),
            items[3].check == true
                ? listViewflilter(items[3].title, items[3].urlImage, 'nomask')
                : const SizedBox(),
            listViewflilter('Xóa hết', null, ''),
          ]),
        ],
      );
    }
  }

  // List<DropdownMenuItem<Combobox>> _addDividersAfterItems(
  //     List<Combobox> items) {
  //   List<DropdownMenuItem<Combobox>> _menuItems = [];
  //   for (var item in items) {
  //     _menuItems.addAll(
  //       [
  //         DropdownMenuItem<Combobox>(
  //           value: item,
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //             child: Text(
  //               item.name,
  //               style: const TextStyle(
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ),
  //         ),
  //         //If it's last item, we will not add Divider after it.
  //         if (item != items.last)
  //           const DropdownMenuItem<Combobox>(
  //             enabled: false,
  //             child: Divider(),
  //           ),
  //       ],
  //     );
  //   }
  //   return _menuItems;
  // }

  // List<double> _getCustomItemsHeights() {
  //   List<double> _itemsHeights = [];
  //   for (var i = 0; i < (items.length * 2) - 1; i++) {
  //     if (i.isEven) {
  //       _itemsHeights.add(40);
  //     }
  //     //Dividers indexes will be the odd indexes
  //     if (i.isOdd) {
  //       _itemsHeights.add(4);
  //     }
  //   }
  //   return _itemsHeights;
  // }

  _getPerrmisson() {}
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
          'limit': 20,
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

//Phần phía sau 2 nút tab
  Widget _buildActions() {
    final enable = _dateController.text.isNotEmpty;
    return Column(
      children: [
        SizedBox(
          height: 36,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
                                _exportAction(data);
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

  // Widget _buildTable() {
  //   final List<TableHeader> tableHeaders = [
  //     TableHeader(
  //       title: ScreenUtil.t(I18nKey.no)!.toUpperCase(),
  //       width: 60,
  //       isConstant: true,
  //     ),
  //     TableHeader(
  //       title: ScreenUtil.t(I18nKey.image)!,
  //       width: 100,
  //       isConstant: true,
  //     ),
  //     TableHeader(
  //       title: ScreenUtil.t(I18nKey.dateCreated)!,
  //       width: 200,
  //       isConstant: true,
  //     ),
  //     TableHeader(
  //       title: ScreenUtil.t(I18nKey.curremperature)!,
  //       width: 200,
  //       isConstant: true,
  //     ),
  //     TableHeader(
  //       title: ScreenUtil.t(I18nKey.gender)!,
  //       width: 200,
  //       isConstant: true,
  //     ),
  //     TableHeader(
  //       title: ScreenUtil.t(I18nKey.mask)!,
  //       width: 300,
  //       isConstant: true,
  //     ),
  //     TableHeader(
  //       title: ScreenUtil.t(I18nKey.temperature)!,
  //       width: 250,
  //       isConstant: true,
  //     ),
  //     TableHeader(
  //       title: ScreenUtil.t(I18nKey.device)!,
  //       width: 200,
  //       isConstant: true,
  //     ),
  //     TableHeader(
  //       title: ScreenUtil.t(I18nKey.status)!,
  //       width: 200,
  //       isConstant: true,
  //     ),
  //   ];
  //   return Stack(children: [
  //     StreamBuilder(
  //       stream: widget.healthyBloc.historyData,
  //       builder:
  //           (context, AsyncSnapshot<ApiResponse<HistorylListModel>> snapshot) {
  //         if (snapshot.hasData) {
  //           final healthys = snapshot.data!.model!.records;
  //           final meta = snapshot.data!.model!.meta;
  //           _page = meta.page;
  //           _count = healthys.length;
  //           return Column(children: [
  //             Padding(
  //                 padding: const EdgeInsets.only(top: 16),
  //                 child: LayoutBuilder(
  //                   builder: (context, size) {
  //                     return DynamicTable(
  //                       columnWidthRatio: tableHeaders,
  //                       numberOfRows: healthys.length,
  //                       rowBuilder: (index) => _rowFor(
  //                         item: healthys[index],
  //                         index: index,
  //                         meta: meta,
  //                       ),
  //                       hasBodyData: true,
  //                       tableBorder:
  //                           Border.all(color: AppColor.black, width: 1),
  //                       headerBorder: TableBorder(
  //                         bottom: BorderSide(color: AppColor.noticeBackground),
  //                       ),
  //                       headerStyle: const TextStyle(
  //                         fontWeight: FontWeight.bold,
  //                         color: AppColor.black,
  //                         fontStyle: FontStyle.normal,
  //                       ),
  //                       bodyBorder: TableBorder(
  //                         horizontalInside: BorderSide(
  //                           color: AppColor.noticeBackground,
  //                         ),
  //                       ),
  //                     );
  //                   },
  //                 )),
  //             if (healthys.isEmpty)
  //               Center(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(16),
  //                   child: Text(ScreenUtil.t(I18nKey.noData)!),
  //                 ),
  //               ),
  //           ]);
  //         } else if (snapshot.hasError) {
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 8, bottom: 16),
  //             child: snapshot.error.toString().trim() == 'request timeout'
  //                 ? Text(ScreenUtil.t(I18nKey.requestTimeOut)!)
  //                 : Text(snapshot.error.toString()),
  //           );
  //         }
  //         return const SizedBox();
  //       },
  //     ),
  //     StreamBuilder(
  //       stream: widget.healthyBloc.allDataState,
  //       builder: (context, state) {
  //         if (!state.hasData || state.data == BlocState.fetching) {
  //           return Center(
  //             child: Padding(
  //               padding: const EdgeInsets.only(top: 8),
  //               child: JTCircularProgressIndicator(
  //                 size: 24,
  //                 strokeWidth: 2.0,
  //                 color: Theme.of(context).textTheme.button!.color!,
  //               ),
  //             ),
  //           );
  //         }
  //         return const SizedBox();
  //       },
  //     ),
  //   ]);
  // }

  // TableRow _rowFor({
  //   required HistoryModel item,
  //   required Paging meta,
  //   required int index,
  // }) {
  //   //debugPrint('User create: ' + item.userCreate);
  //   final recordOffset = meta.recordOffset;
  //   return TableRow(
  //     children: [
  //       tableCellText(
  //           title: '${recordOffset + index + 1}', alignment: Alignment.center),
  //       tableCellText(
  //           child: InkWell(
  //         onTap: () {
  //           showGeneralDialog(
  //             barrierDismissible: false,
  //             context: context,
  //             barrierColor: Colors.black.withOpacity(0.5),
  //             pageBuilder: (context, animation, secondaryAnimation) {
  //               return Material(
  //                 color: Colors.black.withOpacity(0.5),
  //                 child: Stack(children: [
  //                   Align(
  //                       alignment: Alignment.center,
  //                       child: Container(
  //                         color: Colors.black,
  //                         width: MediaQuery.of(context).size.width * 0.50,
  //                         // height: 250,
  //                         child:
  //                             Image.network(item.urlImage, fit: BoxFit.cover),
  //                       )),
  //                   Positioned(
  //                       top: 20,
  //                       right: 100,
  //                       child: Align(
  //                         alignment: Alignment.center,
  //                         child: Padding(
  //                           padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
  //                           child: IconButton(
  //                               padding:
  //                                   const EdgeInsets.fromLTRB(0, 0, 25, 15),
  //                               alignment: Alignment.center,
  //                               color: Colors.blue,
  //                               onPressed: () => Navigator.of(context).pop(),
  //                               icon: const Icon(
  //                                 Icons.close,
  //                                 size: 40,
  //                                 color: Colors.white,
  //                               )),
  //                         ),
  //                       ))
  //                 ]),
  //               );
  //             },
  //           );
  //         },
  //         child: SizedBox(
  //           child: Image.network(item.urlImage, fit: BoxFit.cover),
  //         ),
  //       )),
  //       tableCellText(
  //         alignment: Alignment.center,
  // child: TableColumnDateTime(
  //   value: item.createTime,
  //   displayedFormat: ScreenUtil.t(I18nKey.formatDMY)!,
  // ),
  //       ),
  //       tableCellText(
  //         title: item.currTemperature.toStringAsFixed(1),
  //       ),
  //       tableCellText(
  //         title: item.gender == 'male'
  //             ? ScreenUtil.t(I18nKey.male)!
  //             : ScreenUtil.t(I18nKey.female)!,
  //       ),
  //       tableCellText(
  //         title: item.mask == 'no'
  //             ? ScreenUtil.t(I18nKey.notwearingmask)!
  //             : ScreenUtil.t(I18nKey.wearingmask)!,
  //       ),
  //       tableCellText(
  //         title: item.highTemperature == 'no'
  //             ? ScreenUtil.t(I18nKey.normal)!
  //             : ScreenUtil.t(I18nKey.hightemperature)!,
  //       ),
  //       tableCellText(
  //         title: item.channelName,
  //       ),
  //       tableCellText(
  //         title: item.status,
  //       ),
  //     ],
  //   );
  // }

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

  _exportAction(List<HistoryModel> data) {
    exportDataGridToExcel(data: data);
  }

  Future<void> exportDataGridToExcel({
    required List<HistoryModel> data,
    bool isException = false,
  }) async {
    final workbook = xl.Workbook();
    xl.Style headerStyle;
    xl.Style tableContentStyle;
    xl.Style signStyle;

    final xl.Worksheet sheet = workbook.worksheets[0];
    const int rowIndex = 4;
    const int colIndex = 4;
    const String firstColCharacter = 'C';
    const String lastColCharacter = 'I';
    String reportName = eventSelectedList == 0
        ? "History_" + toDate(_now.toString()).toString()
        : 'History Healthy';

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
    for (var r = rowIndex; r <= data.length + colIndex; r++) {
      for (var c = colIndex; c < 7 + colIndex; c++) {
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

  List<xl.ExcelDataRow> _buildExcel(
    List<HistoryModel> data,
    bool isException,
  ) {
    List<xl.ExcelDataRow> excelDataRows = <xl.ExcelDataRow>[];
    excelDataRows = data.map<xl.ExcelDataRow>((HistoryModel item) {
      //String displayEvent = '';
      // if (item.eventTypeId.code == '4867') {
      //   displayEvent = ScreenUtil.t(I18nKey.identifySuccessFace)!;
      // }
      // if (item.eventTypeId.code == '5125') {
      //   displayEvent = ScreenUtil.t(I18nKey.identifyFailFace)!;
      // }
      return xl.ExcelDataRow(
        cells: <xl.ExcelDataCell>[
          xl.ExcelDataCell(
              columnHeader: ScreenUtil.t(I18nKey.no)!.toUpperCase(),
              value: data.indexOf(item) + 1),
          xl.ExcelDataCell(
            columnHeader: 'Gender',
            value: item.gender,
          ),
          xl.ExcelDataCell(
            columnHeader: 'Link Image',
            value: item.urlImage,
          ),
          xl.ExcelDataCell(
            columnHeader: 'status',
            value: item.status,
          ),
          xl.ExcelDataCell(
            columnHeader: 'Camera',
            value: item.channelName,
          ),
          xl.ExcelDataCell(
            columnHeader: 'Create Time',
            value: _parseDisplayedDateTime(item.createTime.toString()),
          ),
          xl.ExcelDataCell(
            columnHeader: 'Curr Temperature',
            value: item.currTemperature,
          ),
        ],
      );
    }).toList();
    return excelDataRows;
  }
}
