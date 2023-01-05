import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_iot/open_sources/popover/popover.dart';
import 'package:web_iot/screens/modules/smart_parking/component/dialogvehicle.dart';
import 'package:web_iot/screens/modules/smart_parking/component/filer_placenumber.dart';
import 'package:web_iot/screens/modules/smart_parking/component/parking_report/component/report_full_slot.dart';
import 'package:web_iot/widgets/data_table/table_pagination.dart';
import 'package:web_iot/widgets/debouncer/debouncer.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import '../../../../config/permissions_code.dart';
import '../../../../core/modules/smart_parking/blocs/vehicle/vehicle_bloc.dart';
import '../../../../core/modules/smart_parking/models/vehicle_event_model.dart';
import '../../../../core/modules/user_management/models/account_model.dart';
import '../../../../main.dart';
import '../../../../widgets/calendar_popup/calendar_popup.dart';
// import '../../../../widgets/data_table/table_component.dart';
// import '../../../../widgets/table/dynamic_table.dart';
import '../smart_parking_screen.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xl;
import 'export_file.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:intl/intl.dart';
// import 'package:date_time_picker/date_time_picker.dart';


class ParkingModel {
  final String? id;
  final String? floor;
  final String? block;
  final String? parkingDate;
  final String? timeIn;
  final String? timeOut;
  final bool? status;
  ParkingModel({
    this.id,
    this.floor,
    this.block,
    this.parkingDate,
    this.timeIn,
    this.timeOut,
    this.status,
  });
}

class ParkingList extends StatefulWidget {
  final VehicleBloc vehicleBloc;
  final VehicleBloc vehicleExceptionBloc;
  final String route;
  final Function(int) changeTab;
  final ParkingFilterController parkingFilter;
  final TextEditingController keyword;
  final Function(List<String>)? onStatusChanged;
  final Function(String)? onUpdateTimeChanged;
  final Function onFilterCleared;
  final Function(
    int,
    int,
    String, {
    required int from,
    required int to,
  }) fetchParkingListData;
  final Function(
    int, {
    required int from,
    required int to,
  }) fetchParkingExceptionData;
  final AccountModel currentUser;

  const ParkingList({
    Key? key,
    required this.parkingFilter,
    required this.keyword,
    this.onStatusChanged,
    this.onUpdateTimeChanged,
    required this.onFilterCleared,
    required this.changeTab,
    required this.fetchParkingListData,
    required this.vehicleBloc,
    required this.route,
    required this.currentUser,
    required this.vehicleExceptionBloc,
    required this.fetchParkingExceptionData,
  }) : super(key: key);

  @override
  _ParkingListState createState() => _ParkingListState();
}

class _ParkingListState extends State<ParkingList> {
  
  late TextEditingController _controllerdatatime;
  late Debouncer _debouncer;
  final _dateController = TextEditingController();
  final _eventController = TextEditingController();
  final _now = DateTime.now();
  late int _fromDate;
  late int _toDate;
  late DateTime startDate;
  late DateTime endDate;
  final double columnSpacing = 50;
  bool isWarning = false;
  String _errorMessage = '';
  bool _allowExport = false;
  bool _isHover = false;
  final keyFilter = TextEditingController();
  int _limit = 0;
  int _limitFilter = 200;
  final _vehicleBlocFiler = VehicleBloc();
  int _selectedPlace = 0;
  String _valueToValidate='';
  String _valueSaved = '';
  String _valueChanged = '';

  @override
  void initState() {
    startDate = DateTime(2021, 1, 1, 0, 0);
    endDate = DateTime(_now.year, _now.month, _now.day, 23, 59);
    _fromDate = startDate.millisecondsSinceEpoch;
    _toDate = endDate.millisecondsSinceEpoch;
    //Intl.defaultLocale = 'pt_BR';
    _controllerdatatime = TextEditingController(text: DateTime.now().toString());
    if (parkSelectedList == 0) {
      widget.fetchParkingListData(
        1,
        10,
        '',
        from: _fromDate,
        to: _toDate,
      );
    } else {
      widget.fetchParkingExceptionData(
        1,
        from: _fromDate,
        to: _toDate,
      );
    }

    _getPerrmisson();
    _debouncer = Debouncer(delayTime: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    _vehicleBlocFiler.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widthrow =  MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, size) {
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
                parkSelectedList == 2?const SizedBox():Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                  child: _filtersInput(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: _buildActions(),
                ),
              ],
            ),
          ),
          parkSelectedList == 2
              ? ReportFullSlot(
                  route: 'true',
                  allowExport: false,
                )
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: StreamBuilder(
                    stream: parkSelectedList == 0
                        ? widget.vehicleBloc.allData
                        : widget.vehicleExceptionBloc.allData,
                    builder: (context,
                        AsyncSnapshot<ApiResponse<VehicleEventListModel?>>
                            snapshot) {
                      if (snapshot.hasData) {
                        final vehicles = snapshot.data!.model!.records;
                        final meta = snapshot.data!.model!.meta;
                        List<VehicleEventModel> moto = vehicles.where((element) => element.cardGroupName!='oto',).toList();
                        return LayoutBuilder(
                          builder: (context, size) {
                            return Column(
                              children: [
                                buildTable(vehicles: moto, meta: meta),
                                //_buildTable(vehicles: vehicles, meta: meta),
                                if (vehicles.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(ScreenUtil.t(I18nKey.noData)!),
                                  ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                  child: TablePagination(
                                    onFetch: (index) {
                                      if (parkSelectedList == 0) {
                                        widget.fetchParkingListData(
                                          index,
                                          10,
                                          widget.keyword.text,
                                          from: _fromDate,
                                          to: _toDate,
                                        );
                                      } else {
                                        widget.fetchParkingExceptionData(
                                          index,
                                          from: _fromDate,
                                          to: _toDate,
                                        );
                                      }
                                    },
                                    pagination: meta,
                                  ),
                                ),
                              ],
                            );
                          },
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

//các filters thời gian, sự kiện, tìm kiếm
  Widget _filtersInput() {
    final normalStyle = Theme.of(context).textTheme.bodyText1;
    final displayedFormat = ScreenUtil.t(I18nKey.formatDMY)! + ', HH:mm';
    _dateController.text =
        '${DateFormat(displayedFormat).format(startDate)} - ${DateFormat(displayedFormat).format(endDate)}';
    // _dateController.text="Khoảng thời gian: hh:mm-hh:mm Ngày: dd/mm/yyy";
    // _eventController.text="Các sự kiện: quá nhiệt, người lạ, không khẩu trang";
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // SizedBox(
        //   width: 387,
        //   child: DateTimePicker(
        //           type: DateTimePickerType.dateTime,
        //           dateMask: 'd MMMM, yyyy - hh:mm a',
        //           controller: _controllerdatatime,
        //           //initialValue: _initialValue,
        //           firstDate: DateTime(2000),
        //           lastDate: DateTime(2100),
        //           //icon: Icon(Icons.event),
        //           dateLabelText: ScreenUtil.t(I18nKey.time),
        //           use24HourFormat: false,
        //           locale: Locale('en', 'US'),
        //           onChanged: (val) => setState(() => _valueChanged = val),
        //           validator: (val) {
        //             setState(() => _valueToValidate = val ?? '');
        //             return null;
        //           },
        //           onSaved: (val) => setState(() => _valueSaved = val ?? ''),
        //         ),
        // ),
        
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
              hintText: ScreenUtil.t(I18nKey.startTime)! +
                  ' - ' +
                  ScreenUtil.t(I18nKey.endTime)!,
              // hintText: "Khoảng thời gian: hh:mm-hh:mm Ngày: dd/mm/yyyy",
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
              showDialog(
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
                          if (parkSelectedList == 0) {
                            widget.fetchParkingListData(
                              1,
                              10,
                              widget.keyword.text,
                              from: _fromDate,
                              to: _toDate,
                            );
                          } else {
                            widget.fetchParkingExceptionData(
                              1,
                              from: _fromDate,
                              to: _toDate,
                            );
                          }
                        });
                      },
                    );
                  });
            },
          ),
        ),
        SizedBox(width: 50,),
        SizedBox(
          width: 437,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(top: 10,bottom: 10),child: Text(ScreenUtil.t(I18nKey.search)!,)),
              JTSearchField(
                controller: widget.keyword,
                hintText: ScreenUtil.t(I18nKey.searchLicensePlatesUserName)!,
                //hintText: "Nhập tên nhân viên",
                onPressed: () {
                  setState(
                    () {
                      if (widget.keyword.text.isEmpty) return;
                      widget.keyword.text = '';
                      if (parkSelectedList == 0) {
                        widget.fetchParkingListData(
                          1,
                          10,
                          widget.keyword.text,
                          from: _fromDate,
                          to: _toDate,
                        );
                      } else {
                        widget.fetchParkingExceptionData(
                          1,
                          from: _fromDate,
                          to: _toDate,
                        );
                      }
                    },
                  );
                },
                onChanged: (newValue) {
                  _debouncer.debounce(afterDuration: () {
                    if (parkSelectedList == 0) {
                      widget.fetchParkingListData(
                        1,
                        10,
                        widget.keyword.text,
                        from: _fromDate,
                        to: _toDate,
                      );
                    } else {
                      widget.fetchParkingExceptionData(
                        1,
                        from: _fromDate,
                        to: _toDate,
                      );
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  _getPerrmisson() {
    final listPermissionCodes = widget.currentUser.roles.map((e) {
      if (e.modules.where((e) => e.name == 'SMART_PARKING').isNotEmpty) {
        return e.modules
            .firstWhere((e) => e.name == 'SMART_PARKING')
            .permissions
            .map((e) => e.permissionCode)
            .toList();
      }
    }).toList();
    if (widget.currentUser.isSuperadmin) {
      _allowExport = true;
    } else {
      for (var permissionCodes in listPermissionCodes) {
        setState(() {
          if (permissionCodes!.contains(PermissionsCode.smartParkingAllRoles)) {
            _allowExport = true;
          }
          if (permissionCodes
              .contains(PermissionsCode.smartParkingStaticFile)) {
            _allowExport = true;
          }
        });
      }
    }
  }

//Phần phía sau 2 nút tab
  Widget _buildActions() {
    final enable = _allowExport && _dateController.text.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildTabButton(),
            const Spacer(),
             parkSelectedList == 2?SizedBox():JTExportButton(
              enable: enable,
              onPressed: enable
                  ? () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return ConfirmExportDialog(
                            onPressed: () {
                              Map<String, dynamic> params = {
                                'fromDate': _fromDate / 1000,
                                'toDate': _toDate / 1000,
                              };
                              if (parkSelectedList == 0) {
                                widget.vehicleBloc
                                    .exportSuccess(params: params)
                                    .then((value) {
                                  if (value.records.isNotEmpty) {
                                    exportDataGridToExcel(data: value.records.where((element) => element.cardGroupName!='oto').toList());
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
                              } else {
                                widget.vehicleBloc
                                    .exportException(params: params)
                                    .then((value) {
                                  if (value.records.isNotEmpty) {
                                    exportDataGridToExcel(
                                      data: value.records,
                                      isException: true,
                                    );
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
                              }
                            },
                          );
                        },
                      );
                    }
                  : null,
            ),
            parkSelectedList == 2?SizedBox():Padding(
              padding: const EdgeInsets.only(left: 16),
              child: InkWell(
                onTap: () {},
                onHover: (value) {
                  setState(() {
                    _isHover = value;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: _isHover ? AppColor.toastShadow : AppColor.white,
                    border: Border.all(
                      color: !_isHover ? AppColor.toastShadow : AppColor.white,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.refresh,
                          color:
                              !_isHover ? AppColor.toastShadow : AppColor.white,
                          size: 25,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          ScreenUtil.t(I18nKey.refresh)!,
                          style: !_isHover
                              ? TextStyle(color: AppColor.toastShadow)
                              : const TextStyle(color: AppColor.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        if (parkSelectedList == 0) {
                          widget.fetchParkingListData(
                            1,
                            10,
                            widget.keyword.text,
                            from: _fromDate,
                            to: _toDate,
                          );
                        } else {
                          widget.fetchParkingExceptionData(
                            1,
                            from: _fromDate,
                            to: _toDate,
                          );
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
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

  _buildTabButton() {
    final tabs = [
      ScreenUtil.t(I18nKey.parkingList)!,
      ScreenUtil.t(I18nKey.parkingException)!,
      ScreenUtil.t(I18nKey.statisticfullslot)!
    ];

    return LayoutBuilder(builder: (context, size) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var tab in tabs)
            LayoutBuilder(builder: (context, size) {
              final tabIndex = tabs.indexOf(tab);
              final enable = parkSelectedList == tabIndex;

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
                        parkSelectedList = tabIndex;
                        if (parkSelectedList == 0) {
                          widget.fetchParkingListData(
                            1,
                            10,
                            widget.keyword.text,
                            from: _fromDate,
                            to: _toDate,
                          );
                        } else if (parkSelectedList == 1) {
                          widget.fetchParkingExceptionData(
                            1,
                            from: _fromDate,
                            to: _toDate,
                          );
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

  Widget buildTable({
    required List<VehicleEventModel> vehicles,
    required Paging meta,
  }) {
    //List<VehicleEventModel> bikeVehicles = vehicles.where((element) => element.cardGroupName!='oto').toList();
    TextStyle _styleHeader =
        const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
    List<Widget> titilesHeader = [
      Center(
          child: Text(ScreenUtil.t(I18nKey.no)!.toUpperCase(),
              style: _styleHeader)),
       
      LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: 180,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(ScreenUtil.t(I18nKey.licensePlate)!, style: _styleHeader),
                const SizedBox(
                  width: 3,
                ),
                IconButton(
                  onPressed: () {
                    showPopover(
                      width: 250,
                      height: 380,
                      direction: PopoverDirection.bottom,
                      arrowWidth: 24,
                      arrowHeight: 12,
                      context: context,
                      bodyBuilder: (context) {
                        return TextFieldCombo(
                          fetchParkingExceptionData:
                              widget.fetchParkingExceptionData,
                          fetchParkingListData: widget.fetchParkingListData,
                          fromDate: _fromDate,
                          toDate: _toDate,
                          keyword: keyFilter,
                          vehicleBloc: _vehicleBlocFiler,
                          vehicleExceptionBloc: widget.vehicleExceptionBloc, 
                          fetchParkingfiler: _fetchParkingListData, keywordmain: widget.keyword,
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.filter_alt,
                  ),
                )
              ],
            ),
          );
        },
      ),
      Center(child: Text(ScreenUtil.t(I18nKey.image)!, style: _styleHeader)),
      Center(child: Text(ScreenUtil.t(I18nKey.timeIn)!, style: _styleHeader)),
      Center(child: Text(ScreenUtil.t(I18nKey.timeOut)!, style: _styleHeader)),
      Center(
          child: Text(ScreenUtil.t(I18nKey.vehicleType)!, style: _styleHeader)),
    ];
    final _rowHeader = _row(titilesHeader);
    return ListView.builder(
      shrinkWrap: true,
      //physics: NeverScrollableScrollPhysics(),
      itemCount: vehicles.length + 1,
      itemBuilder: (context, index) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              index == 0
                  ? _rowHeader
                  : InkWell(
                      onTap: () {
                        showGeneralDialog(
                          context: context,
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return DialogVehicleEvent(
                                vehicleEvent: vehicles[index - 1]);
                          },
                        );
                      },
                      child: _rowContentTable(
                          item: vehicles[index - 1], meta: meta, index: index)),
            ],
          ),
        );
      },
    );
  }

  Widget _rowContentTable({
    required VehicleEventModel item,
    required Paging meta,
    required int index,
  }) {
    TextStyle _styleContent = const TextStyle(color: Colors.black);
    final recordOffset = meta.recordOffset;
    final _no = Text(
      '${recordOffset + index}',
      style: _styleContent,
    );
    final _licensePlate = Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            border: Border.all(color: Colors.green, width: 2)),
        child: Center(
            child: item.plateNumber == ''
                ? const Text(
                    '51A-34512',
                    style:  TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  )
                : Text(
                    item.plateNumber,
                    style: _styleContent.copyWith(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  )));
    final _image = SizedBox(
      width: 50,
      height: 45,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Image.asset(
          item.cardGroupName == 'oto'
              ? "assets/images/car.jpg"
              : "assets/images/bike.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
    final _timeIn = Center(
      child: Text(
        _parseDisplayedDateTime(item.dateTimeIn),
        style: _styleContent,
      ),
    );
    final _timeOut = Center(
      child: Text(
        _parseDisplayedDateTime(item.dateTimeOut),
        style: _styleContent,
      ),
    );
    final _vehicleType = Center(
      child: Text(
        item.cardGroupName!='oto'?ScreenUtil.t(I18nKey.bikeAndAnotherVehicle)!:ScreenUtil.t(I18nKey.car)!,
        style: _styleContent,
      ),
    );
    List<Widget> widgets = [
      _no,
      _licensePlate,
      _image,
      _timeIn,
      _timeOut,
      _vehicleType
    ];
    return _row(widgets);
  }

  Widget _row(List<Widget> titles) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 2))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _cell(titles[0], MediaQuery.of(context).size.width*0.05),
          _cell(titles[1],  MediaQuery.of(context).size.width*0.15),
          _cell(titles[2],  MediaQuery.of(context).size.width*0.1),
          _cell(titles[3],  MediaQuery.of(context).size.width*0.15),
          _cell(titles[4],  MediaQuery.of(context).size.width*0.15),
          _cell(titles[5],  MediaQuery.of(context).size.width*0.2),
        ],
      ),
    );
  }

  Widget _cell(Widget title, double width) {
    return Container(
      padding: const EdgeInsets.all(25),
      width: width,
      child: title,
    );
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
          // xl.ExcelDataCell(
          //   columnHeader: ScreenUtil.t(I18nKey.floor)!,
          //   value: '',
          // ),
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

  _fetchParkingListData(
    int limit,
    String search, {
    required int from,
    required int to,
  }) {
    final fromDate = from / 1000;
    final toDate = to / 1000;
    _limitFilter = limit;
    parkingListSearchString = search;
    Map<String, dynamic> params = {
      'fromDate': fromDate,
      'toDate': toDate,
      'limit': 200,
      'plateNumber': parkingListSearchString
    };
    _vehicleBlocFiler.fetchAllData(params: params);
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
