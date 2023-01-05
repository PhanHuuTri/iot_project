import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_iot/config/fake_data.dart';
import 'package:web_iot/config/svg_constants.dart';
import 'package:web_iot/open_sources/popover/popover.dart';
//import 'package:web_iot/screens/modules/smart_parking/component/linechart/traffic_chart_parking.dart';
import 'package:web_iot/widgets/chart/pie_chart.dart';
import 'package:web_iot/widgets/debouncer/debouncer.dart';
import '../../../../core/modules/smart_parking/blocs/empty_slot/empty_slot_bloc.dart';
import '../../../../core/modules/smart_parking/blocs/report_in_out/report_in_out_bloc.dart';
import '../../../../core/modules/smart_parking/models/empty_slot_model.dart';
import '../../../../core/modules/smart_parking/models/report_in_out_model.dart';
import '../../../../main.dart';
import '../../../../widgets/joytech_components/joytech_components.dart';
import 'traffic_chart.dart';
import 'package:async/async.dart' show StreamGroup;


class IndicatorItemData {
  final String title;
  final double value;
  final IconData? icon;
  final double? total;
  final String? note;
  IndicatorItemData({
    required this.title,
    required this.value,
    this.icon,
    this.total,
    this.note,
  });
}

class Floor {
  final String name;
  final List<String> availableSlot;
  final double stands;
  final double motorParked;
  final double emptySlot;
  Floor({
    required this.name,
    required this.availableSlot,
    required this.stands,
    required this.motorParked,
    required this.emptySlot,
  });
}

class TrafficList extends StatefulWidget {
  final Function(int) changeTab;
  final Function() onFetch;
  final EmptySlotBloc motoEmptySlotBloc;
  final EmptySlotBloc carEmptySlotBloc;
  final EmptySlotBloc carslotBloc;
  final ReportInOutBloc reportInOutBloc;

  const   TrafficList({
    Key? key,
    required this.changeTab,
    required this.onFetch,
    required this.motoEmptySlotBloc,
    required this.carEmptySlotBloc,
    required this.reportInOutBloc,
    required this.carslotBloc,
  }) : super(key: key);

  @override
  _TrafficListState createState() => _TrafficListState();
}

class _TrafficListState extends State<TrafficList> {
  //final _EmptySlotBloc = EmptySlotBloc();
  final _padding = 16.0;
  int _selectValueFilterValidstatus = 0;
  int _selectValueFilterUnValidstatus = 0;
  double _total1 = 0;
  List<ChartItemData> parkingChart1 = [];
  late Debouncer _debouncer;

  @override
  void initState() {
    _debouncer = Debouncer(delayTime: const Duration(milliseconds: 900));
    Timer.periodic(const Duration(hours: 1), (timer) {
      widget.onFetch();
    });
    super.initState();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(builder: (context, size) {
      return StreamBuilder(
          stream: widget.reportInOutBloc.allData,
          builder: (context,
              AsyncSnapshot<ApiResponse<ListReportInOutModel?>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TrafficChart(snapshot: snapshot),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 30, bottom: 10),
                    child: Text(
                      ScreenUtil.t(I18nKey.carParkStatus)!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 21,
                      children: [
                        _buildApiTotalValidStatus(
                            _selectValueFilterValidstatus),
                        _buildApiTotalUnValidStatus(_selectValueFilterUnValidstatus),
                      ],
                    ),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    snapshot.error.toString(),
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: JTCircularProgressIndicator(
                  size: 20,
                  strokeWidth: 1.5,
                  color: AppColor.primary,
                ),
              ),
            );
          });
    });
  }
 Widget _buildApiTotalUnValidStatus(int valueIndexcbo) {
    if (valueIndexcbo == 1) {
      return _buildPieChart(
                title: ScreenUtil.t(I18nKey.validstatus)! +
                    ' ' +
                    ScreenUtil.t(I18nKey.car)!.toLowerCase(),
                child: PieChartJT(
                  pieChart: parkingChartcar,
                ),
                indicator: _buildIndicator(
                  note: ScreenUtil.t(I18nKey.status)!,
                  items: parkingChartcar,
                ),
                context: context, status: false);
    } else if (valueIndexcbo == 2) {
      return _buildPieChart(
                title: ScreenUtil.t(I18nKey.validstatus)! +
                    ' ' +
                    ScreenUtil.t(I18nKey.car)!.toLowerCase(),
                child: PieChartJT(
                  pieChart: parkingChartmoto,
                ),
                indicator: _buildIndicator(
                  note: ScreenUtil.t(I18nKey.status)!,
                  items: parkingChartmoto,
                ),
                context: context, status: false);
    }
    return _buildPieChart(
                title: ScreenUtil.t(I18nKey.validstatus)! +
                    ' ' +
                    ScreenUtil.t(I18nKey.car)!.toLowerCase(),
                child: PieChartJT(
                  pieChart: parkingChartcarandmoto,
                ),
                indicator: _buildIndicator(
                  note: ScreenUtil.t(I18nKey.status)!,
                  items: parkingChartcarandmoto,
                ),
                context: context, status: false); 
  }

  Widget _buildApiTotalValidStatus(int valueIndexcbo) {
    double _total1 = 0;
    double sum = 0;
    double _total2 = 0;
    if (valueIndexcbo == 1) {
      return StreamBuilder(
        stream: widget.carslotBloc.allCarslot,
        builder: (context, AsyncSnapshot<ApiResponse<CarEmptySlot?>> snapshot) {
          if (snapshot.hasData) {
            final Emptycars = snapshot.data!.model!;
            //double _total = 0;
            final parkingChartcar = [
              ChartItemData(
                color: const Color(0xFF50AF9D),
                value: Emptycars.available as double,
                title: ScreenUtil.t(I18nKey.availableslots)!,
                total: 111,
              ),
              ChartItemData(
                color: const Color(0xFFD2585B),
                value: 111 - Emptycars.available as double,
                title: ScreenUtil.t(I18nKey.parkedslots)!,
                total: 111,
              ),
            ];
            return _buildPieChart(
                title: ScreenUtil.t(I18nKey.validstatus)! +
                    ' ' +
                    ScreenUtil.t(I18nKey.car)!.toLowerCase(),
                child: PieChartJT(
                  pieChart: parkingChartcar,
                ),
                indicator: _buildIndicator(
                  note: ScreenUtil.t(I18nKey.status)!,
                  items: parkingChartcar,
                ),
                context: context, status: true);
          } else if (snapshot.hasError) {
            return SizedBox(
              height: 48,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  snapshot.error.toString(),
                ),
              ),
            );
          }
          return const Align(
            alignment: Alignment.centerLeft,
            child: JTCircularProgressIndicator(
              size: 20,
              strokeWidth: 1.5,
              color: Colors.green,
            ),
          );
        },
      );
    } else if (valueIndexcbo == 2) {
      return StreamBuilder(
        stream: widget.motoEmptySlotBloc.allMoto,
        builder: (context,
            AsyncSnapshot<ApiResponse<ListMotoEmptySlotModel?>> snapshot) {
          if (snapshot.hasData) {
            final Emptymotos = snapshot.data!.model!.records;
            for (MotoEmptySlotModel emptyslot in Emptymotos) {
                for (MotoEmptySpaceModel emptyspace in emptyslot.emptySpaces) {
                  _total2 += emptyspace.emptySlot;
                }
              }
            final parkingChartmoto = [
              ChartItemData(
                color: const Color(0xFF50AF9D),
                value: _total2,
                title:ScreenUtil.t(I18nKey.availableslots)!,
                total: 400,
              ),
              ChartItemData(
                color: const Color(0xFFD2585B),
                value: 400-_total2,
                title: ScreenUtil.t(I18nKey.parkedslots)!,
                total: 400,
              ),
            ];
            return _buildPieChart(
                title: ScreenUtil.t(I18nKey.validstatus)! +
                    ' ' +
                    ScreenUtil.t(I18nKey.bike)!.toLowerCase(),
                child: PieChartJT(
                  pieChart: parkingChartmoto,
                ),
                indicator: _buildIndicator(
                  note: ScreenUtil.t(I18nKey.status)!,
                  items: parkingChartmoto,
                ),
                context: context, status: true);
          } else if (snapshot.hasError) {
            return SizedBox(
              height: 48,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  snapshot.error.toString(),
                ),
              ),
            );
          }
          return const Align(
            alignment: Alignment.centerLeft,
            child: JTCircularProgressIndicator(
              size: 20,
              strokeWidth: 1.5,
              color: Colors.green,
            ),
          );
        },
      );
    }
    return StreamBuilder(
      stream: widget.carslotBloc.allCarslot,
      builder: (context, AsyncSnapshot<ApiResponse<CarEmptySlot?>> snapshot1) {
        if (snapshot1.hasData) {
          return StreamBuilder(
            stream: widget.motoEmptySlotBloc.allMoto,
            builder: (context,
                AsyncSnapshot<ApiResponse<ListMotoEmptySlotModel?>> snapshot2) {
              if (snapshot2.hasData) {
                final Emptycars = snapshot1.data!.model!;
                _total1 = Emptycars.available as double;
                final Emptymotos = snapshot2.data!.model!.records;
                for (MotoEmptySlotModel emptyslot in Emptymotos) {
                for (MotoEmptySpaceModel emptyspace in emptyslot.emptySpaces) {
                  _total2 += emptyspace.emptySlot;
                }
              }
                sum = _total1 + _total2;
                final parkingChartmotocar = [
                  ChartItemData(
                    color: const Color(0xFF50AF9D),
                    value: sum,
                    title:ScreenUtil.t(I18nKey.availableslots)!,
                    total: 511,
                  ),
                  ChartItemData(
                    color: const Color(0xFFD2585B),
                    value: 511- sum,
                    title: ScreenUtil.t(I18nKey.parkedslots)!,
                    total: 511,
                  ),
                ];
                return _buildPieChart(
                    title: ScreenUtil.t(I18nKey.validstatus)! +
                        ' ' +
                        ScreenUtil.t(I18nKey.bike)!.toLowerCase() +
                        ' & ' +
                        ScreenUtil.t(I18nKey.car)!.toLowerCase(),
                    child: PieChartJT(
                      pieChart: parkingChartmotocar,
                    ),
                    indicator: _buildIndicator(
                      note: ScreenUtil.t(I18nKey.status)!,
                      items: parkingChartmotocar,
                    ),
                    context: context, status: true);
              } else if (snapshot1.hasError) {
                return SizedBox(
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot1.error.toString(),
                    ),
                  ),
                );
              } else if (snapshot2.hasError) {
                return SizedBox(
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot2.error.toString(),
                    ),
                  ),
                );
              }
              return const Align(
                alignment: Alignment.centerLeft,
                child: JTCircularProgressIndicator(
                  size: 20,
                  strokeWidth: 1.5,
                  color: Colors.green,
                ),
              );
            },
          );
        } else {
          return const Align(
            alignment: Alignment.centerLeft,
            child: JTCircularProgressIndicator(
              size: 20,
              strokeWidth: 1.5,
              color: Colors.green,
            ),
          );
        }
      },
    );
  }


  _buildPieChart({
    required bool status,
    required Widget child,
    required String title,
    double? width,
    required Widget indicator,
    BuildContext? context,
  }) {
    return LayoutBuilder(builder: (context, BoxConstraints size) {
      final contentWidth = width ?? 550.0;
      final chartWidth = size.maxWidth > contentWidth * 2 + 16
          ? (size.maxWidth / 2) - 16
          : size.maxWidth;

      return Card(
        elevation: 0.0,
        child: Container(
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(1, 1),
                blurRadius: 3.0,
                spreadRadius: 3.0)
          ]),
          width: chartWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 40),
                color: Theme.of(context).textTheme.headline6!.color!,
                width: chartWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    status==true? _buildActions(context: context, width: chartWidth):_buildActionsfail(context: context, width: chartWidth),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    indicator,
                    Expanded(child: child),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
  Widget _buildActionsfail({
    //double? chartWidth,
    double? width,
    BuildContext? context,
  }) {
    return LayoutBuilder(
      builder: (context, BoxConstraints size) {
        //debugPrint(size.maxWidth.toString());
        final chartWidth = width! / 3;
        return SizedBox(
          child: IconButton(
            onPressed: () {
              showPopover(
                direction: PopoverDirection.bottom,
                width: width / 2 - 70,
                height: (width / 3) - 30,
                context: context,
                bodyBuilder: (context) {
                  return SizedBox(
                    width: width / 3,
                    height: width / 3,
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectValueFilterUnValidstatus = 0;
                                });
                                Navigator.of(context).pop();
                              },
                              child: ListTile(
                                leading: const Icon(
                                  Icons.done_all,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                title: Text(ScreenUtil.t(I18nKey.all)!),
                                trailing: _selectValueFilterUnValidstatus == 0
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : const SizedBox(),
                              )),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectValueFilterUnValidstatus = 1;
                                });
                                Navigator.of(context).pop();
                              },
                              child: ListTile(
                                leading: SvgIcon(
                                  SvgIcons.car,
                                  color: Colors.green,
                                  size: 25,
                                ),
                                title: Text(ScreenUtil.t(I18nKey.car)!),
                                trailing: _selectValueFilterUnValidstatus == 1
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : const SizedBox(),
                              )),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectValueFilterUnValidstatus = 2;
                                });
                                Navigator.of(context).pop();
                              },
                              child: ListTile(
                                leading: SvgIcon(
                                  SvgIcons.bike,
                                  color: Colors.green,
                                  size: 25,
                                ),
                                title: Text(ScreenUtil.t(I18nKey.bike)!),
                                trailing: _selectValueFilterUnValidstatus == 2
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : const SizedBox(),
                              )),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.filter_alt,
              size: 20,
            ),
          ),
        );
      },
    );
  }
  Widget _buildActions({
    bool? validstatus,
    //double? chartWidth,
    double? width,
    BuildContext? context,
  }) {
    return LayoutBuilder(
      builder: (context, BoxConstraints size) {
        //debugPrint(size.maxWidth.toString());
        final chartWidth = width! / 3;
        return SizedBox(
          child: IconButton(
            onPressed: () {
              showPopover(
                direction: PopoverDirection.bottom,
                width: width / 2 - 70,
                height: (width / 3) - 30,
                context: context,
                bodyBuilder: (context) {
                  return SizedBox(
                    width: width / 3,
                    height: width / 3,
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                 validstatus==true? _selectValueFilterValidstatus = 0:_selectValueFilterUnValidstatus;
                                });
                                Navigator.of(context).pop();
                              },
                              child: ListTile(
                                leading: const Icon(
                                  Icons.done_all,
                                  color: Colors.green,
                                  size: 20,
                                ),
                                title: Text(ScreenUtil.t(I18nKey.all)!),
                                trailing: _selectValueFilterValidstatus == 0
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : const SizedBox(),
                              )),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectValueFilterValidstatus = 1;
                                });
                                Navigator.of(context).pop();
                              },
                              child: ListTile(
                                leading: SvgIcon(
                                  SvgIcons.car,
                                  color: Colors.green,
                                  size: 25,
                                ),
                                title: Text(ScreenUtil.t(I18nKey.car)!),
                                trailing: _selectValueFilterValidstatus == 1
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : const SizedBox(),
                              )),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectValueFilterValidstatus = 2;
                                });
                                Navigator.of(context).pop();
                              },
                              child: ListTile(
                                leading: SvgIcon(
                                  SvgIcons.bike,
                                  color: Colors.green,
                                  size: 25,
                                ),
                                title: Text(ScreenUtil.t(I18nKey.bike)!),
                                trailing: _selectValueFilterValidstatus == 2
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : const SizedBox(),
                              )),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.filter_alt,
              size: 20,
            ),
          ),
        );
      },
    );
  }
  Widget _buildIndicatorExciton({
    required List<ChartItemData> items,
    required String note,
    double? width,
    double? height,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: width ?? 200,
        height: height ?? 50 + 50.0 * items.length,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  note,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 12),
                ),
              ),
            ),
            for (var item in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    if (item.color != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          width: 10,
                          height: 40,
                          color: item.color,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              item.title,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              item.note ?? item.value.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  Widget _buildIndicator({
    required List<ChartItemData> items,
    required String note,
    double? width,
    double? height,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: width ?? 200,
        height: height ?? 50 + 50.0 * items.length,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  note,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 12),
                ),
              ),
            ),
            for (var item in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    if (item.color != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          width: 10,
                          height: 40,
                          color: item.color,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              item.title,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              item.note ?? item.value.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
