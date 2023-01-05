import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:web_iot/config/svg_constants.dart';
import 'package:web_iot/core/modules/face_recog/blocs/dashboard/dashbroad_bloc.dart';
import 'package:web_iot/main.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import 'package:week_of_year/week_of_year.dart';
import '../../../../core/base/blocs/block_state.dart';
import '../../../../core/modules/face_recog/models/dashboard_model.dart';
import '../../../../widgets/chart/line_chart.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/data_table/table_component.dart';
import '../../../../widgets/table/dynamic_table.dart';

final faceDashboardKey = GlobalKey<_DashboardState>();

class Dashboard extends StatefulWidget {
  final Function(int) changeTab;
  const Dashboard({
    Key? key,
    required this.changeTab,
  }) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}


class _DashboardState extends State<Dashboard> {
  int currentChart = 0;
  final double columnSpacing = 50;
  final now = DateTime.now();
  late DateTime startWeek;
  late DateTime endWeek;
  final _dashboardStatus = DashboardBloc();
  final _dashboardAlertStatistic = DashboardBloc();
  final _dashboardAlert = DashboardBloc();
  final _dashboardNotice = DashboardBloc();
  List<AlertStatisticModel> alertStatisticList=[];
  final StreamController<String> _streamController = StreamController<String>(); 

  @override
  void initState() {

    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _dashboardStatus.dispose();
    _dashboardAlertStatistic.dispose();
    _dashboardAlert.dispose();
    _dashboardNotice.dispose();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              ScreenUtil.t(I18nKey.recDashboard)!,
              style: const TextStyle(
                color: AppColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildDashboardChar(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: LayoutBuilder(builder: (context, size) {
              final double usageWidht =
                  min(size.maxWidth - size.maxWidth / 3 - 16, 725 + 16);
              return Row(
                children: [
                  Container(
                    constraints: const BoxConstraints(minHeight: 203),
                    width: usageWidht,
                    child: _buildUsage(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 203),
                      width: size.maxWidth - usageWidht - 16,
                      child: _buildNotices(),
                    ),
                  ),
                ],
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
            child: Text(
              ScreenUtil.t(I18nKey.missedAlarm)!,
              style: const TextStyle(
                color: AppColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: _buildMissedAlarm(),
          ),
        ],
      );
    });
  }

  _buildDashboardChar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            color: AppColor.shadow.withOpacity(0.16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(51.5, 12.5, 0, 12.5),
                  child: Text(
                    ScreenUtil.t(I18nKey.recDashboard)!,
                    style: const TextStyle(
                      color: AppColor.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 29.5),
                  child: Row(
                    children: [
                      _chartControllButton(
                        title: ScreenUtil.t(I18nKey.week)!,
                        chartIndex: 0,
                        onTap: () {
                          setState(() {
                            currentChart = 0;
                            _dashboardAlertStatistic
                                .fetchDashboardAlertStatistic(
                                    params: {'group_id': currentChart});
                          });
                        },
                      ),
                      _chartControllButton(
                        title: ScreenUtil.t(I18nKey.month)!,
                        chartIndex: 1,
                        onTap: () {
                          setState(() {
                            currentChart = 1;
                            _dashboardAlertStatistic
                                .fetchDashboardAlertStatistic(
                                    params: {'group_id': currentChart});
                          });
                        },
                      ),
                      _chartControllButton(
                        title: ScreenUtil.t(I18nKey.year)!,
                        chartIndex: 2,
                        onTap: () {
                          setState(() {
                            currentChart = 2;
                            _dashboardAlertStatistic
                                .fetchDashboardAlertStatistic(
                                    params: {'group_id': currentChart});
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 0, 16),
            child: Text(
              _getChartTime(),
              style: const TextStyle(
                color: AppColor.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          _buildChart(),
        ],
      ),
    );
  }

  Widget _buildNotices() {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          StreamBuilder(
              stream: _dashboardNotice.allData,
              builder: (context,
                  AsyncSnapshot<ApiResponse<DashboardModel?>> snapshot) {
                if (snapshot.hasData) {
                  final notices = snapshot.data!.model!.dashboardNoticeModel;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Text(
                          ScreenUtil.t(I18nKey.notice)!,
                          style: const TextStyle(
                            color: AppColor.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        height: 166,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          border: Border.all(color: AppColor.subTitle),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: notices.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                child: InkWell(
                                  child: Container(
                                    height: 36,
                                    color: index % 2 != 0
                                        ? AppColor.white
                                        : AppColor.noticeBackground,
                                    padding: const EdgeInsets.all(10),
                                    child: Text(notices[index].name),
                                  ),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return _noticeDialog(notices[index]);
                                        });
                                  },
                                ),
                              );
                            }),
                      )
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
              }),
          StreamBuilder(
            stream: _dashboardNotice.allDataState,
            builder: (context, state) {
              if (!state.hasData || state.data == BlocState.fetching) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: JTCircularProgressIndicator(
                    size: 24,
                    strokeWidth: 2.0,
                    color: Theme.of(context).textTheme.button!.color!,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      );
    });
  }

  Widget _buildUsage() {
    return LayoutBuilder(builder: (context, size) {
      return Stack(
        children: [
          StreamBuilder(
              stream: _dashboardStatus.allData,
              builder: (context,
                  AsyncSnapshot<ApiResponse<DashboardModel?>> snapshot) {
                if (snapshot.hasData) {
                  final dashboardStatusModel =
                      snapshot.data!.model!.dashboardStatusModel;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Text(
                          ScreenUtil.t(I18nKey.usage)!,
                          style: const TextStyle(
                            color: AppColor.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(minHeight: 166),
                        width: size.maxWidth,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          border: Border.all(color: AppColor.subTitle),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const ClampingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildUsageItem(
                                  svgIcon: SvgIcons.faceRecoUser,
                                  title: ScreenUtil.t(I18nKey.faceRecoUser)!,
                                  value:
                                      dashboardStatusModel.dashboardUser.count,
                                ),
                                _buildUsageItem(
                                  svgIcon: SvgIcons.fingerprint,
                                  title: ScreenUtil.t(I18nKey.fingerprint)!,
                                  value: dashboardStatusModel
                                      .dashboardFingerTempletes.count,
                                ),
                                _buildUsageItem(
                                  svgIcon: SvgIcons.face,
                                  title: ScreenUtil.t(I18nKey.face)!,
                                  value:
                                      dashboardStatusModel.dashboardFaces.count,
                                ),
                                _buildUsageItem(
                                  svgIcon: SvgIcons.card,
                                  title: ScreenUtil.t(I18nKey.card)!,
                                  value:
                                      dashboardStatusModel.dashboardCards.count,
                                ),
                                _buildUsageItem(
                                  svgIcon: SvgIcons.device,
                                  title: ScreenUtil.t(I18nKey.device)!,
                                  value:
                                      '${dashboardStatusModel.dashboardDevices.count}/${dashboardStatusModel.dashboardDevices.maxCount}',
                                ),
                                _buildUsageItem(
                                  svgIcon: SvgIcons.door,
                                  title: ScreenUtil.t(I18nKey.door)!,
                                  value:
                                      '${dashboardStatusModel.dashboardDoors.count}/${dashboardStatusModel.dashboardDoors.maxCount}',
                                ),
                                _buildUsageItem(
                                  svgIcon: SvgIcons.accessGroup,
                                  title: ScreenUtil.t(I18nKey.accessGroup)!,
                                  value: dashboardStatusModel
                                      .dashboardAccessGroups.count,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
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
              }),
          StreamBuilder(
            stream: _dashboardStatus.allDataState,
            builder: (context, state) {
              if (!state.hasData || state.data == BlocState.fetching) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: JTCircularProgressIndicator(
                    size: 24,
                    strokeWidth: 2.0,
                    color: Theme.of(context).textTheme.button!.color!,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      );
    });
  }

  Widget _chartControllButton({
    required String title,
    required int chartIndex,
    Function()? onTap,
  }) {
    bool isSelected = chartIndex == currentChart;
    return Padding(
      padding: EdgeInsets.only(top: isSelected ? 10 : 17),
      child: Container(
        width: 100,
        height: isSelected ? 36 : 29,
        decoration: BoxDecoration(
          color: isSelected ? AppColor.white : AppColor.primary4,
          borderRadius: isSelected
              ? const BorderRadius.vertical(top: Radius.circular(4))
              : chartIndex == 1
                  ? BorderRadius.zero
                  : chartIndex == 2
                      ? const BorderRadius.only(
                          topRight: Radius.circular(4),
                        )
                      : const BorderRadius.only(
                          topLeft: Radius.circular(4),
                        ),
        ),
        child: InkWell(
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColor.black : AppColor.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildChart() {
    final textTheme = Theme.of(context).textTheme;
    //final List<String> lineChartLeftTitles = ['0', '2', '4', '6', '8', '10','12','14','16','18','20','22','24','26','28','30'];
    //lineChartLeftTitles ;
    //int minimum;
    final List<String> lineChartBottomTitles = _getChartBottomTitles();

    return LayoutBuilder(builder: (context, size) {
      return StreamBuilder(
          stream: _dashboardAlertStatistic.allData,
          builder:
              (context, AsyncSnapshot<ApiResponse<DashboardModel?>> snapshot) {
            if (snapshot.hasData) {
              List<AlertStatisticModel> alertStatistics =
                  snapshot.data!.model!.dashboardAlertStatisticModel.rows;
                  alertStatisticList = alertStatistics;
              final dotValueList = _getDotValues(
                alertStatistics: alertStatistics,
                lineChartBottomTitles: lineChartBottomTitles,
              );
              debugPrint('dotValueList: -'+dotValueList.toString());
              List<String> lineChartLeftTitles = _getlistleftchart(dotValueList);
              int minimum = _getminivalue(dotValueList).ceil();
              int totalText = 0;
              for (var alertStatistic in alertStatistics) {
                totalText = totalText + int.tryParse(alertStatistic.count)!;
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 16, 0, 24),
                    child: SizedBox(
                        width: size.maxWidth - 160 - 32,
                        height: 189,
                        child: LineChartJT(
                          chartHeight: 80.0 * (lineChartLeftTitles.length + 1),
                          chartWidth: 150.0 * lineChartBottomTitles.length,
                          leftTitles: lineChartLeftTitles,
                          bottomTitles: lineChartBottomTitles,
                          leftTitlesOffset:
                              Offset(0, lineChartLeftTitles.length - 1),
                          bottomTitlesOffset:
                              Offset(0, lineChartBottomTitles.length - 1),
                          chartMarginLeft: 11,
                          chartMarginBottom: 6,
                          dotValueList: dotValueList,
                          dotMinimumValue:minimum,
                          isCurved:  false,
                          dataDash: const [8, 10],
                          tooltipBgColor: Theme.of(context).primaryColor,
                          getTooltipItems: (value) {
                            return value.map((e) {
                              final title = dotValueList[e.spotIndex];
                              return LineTooltipItem(
                                '',
                                textTheme.bodyText1!.copyWith(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                                children: [
                                  TextSpan(
                                    text: '$title ',
                                    style: textTheme.headline2!
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              );
                            }).toList();
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(51, 8, 41, 0),
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                          color: AppColor.primary, shape: BoxShape.circle),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 22),
                            child: Center(
                              child: Text(
                                ScreenUtil.t(I18nKey.total)!,
                                style: const TextStyle(
                                  color: AppColor.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            totalText.toString(),
                            style: const TextStyle(
                              color: AppColor.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
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
            } else {
              return StreamBuilder(
                stream: _dashboardAlert.allDataState,
                builder: (context, state) {
                  if (!state.hasData || state.data == BlocState.fetching) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
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
              );
            }
          });
    });
  }
  double _getminivalue(List<double> dotValueList) {
    double n;
    double max =0 ;
    for(double i in dotValueList){
                  if(i>max) max=i;
                }
                n = max/5;
    return n;
  }
  List<String> _getlistleftchart(List<double> dotValueList){
    double max =0 ;
                var n;
                List<String> n1;
                for(double i in dotValueList){
                  if(i>max) max=i;
                }
                n = (max/5).ceil();
                n1 =<String> ["0","$n","${n*2}","${n*3}","${n*4}","${n*5}"];
                
                return n1;
  }

  String _getChartTime() {
    String chartTitle = '';
    if (currentChart == 0) {
      startWeek = now.subtract(const Duration(days: 6));
      endWeek = now;
      final currentlanguageCode = App.of(context)!.currentLocale.languageCode;
      final startWeekText =
          DateFormat('dd MMMM yyyy', currentlanguageCode).format(startWeek);
      final endWeekText =
          DateFormat('dd MMMM yyyy', currentlanguageCode).format(endWeek);
      chartTitle = startWeekText.replaceRange(
              3, 4, startWeekText.characters.elementAt(3).toUpperCase()) +
          ' - ' +
          endWeekText.replaceRange(
              3, 4, endWeekText.characters.elementAt(3).toUpperCase());
    }
    if (currentChart == 1) {
      startWeek = now.subtract(Duration(days: now.weekday + 7 * 4));
      endWeek = now;
      final currentlanguageCode = App.of(context)!.currentLocale.languageCode;
      final startWeekText =
          DateFormat('dd MMMM yyyy', currentlanguageCode).format(startWeek);
      final endWeekText =
          DateFormat('dd MMMM yyyy', currentlanguageCode).format(endWeek);
      chartTitle = startWeekText.replaceRange(
              3, 4, startWeekText.characters.elementAt(3).toUpperCase()) +
          ' - ' +
          endWeekText.replaceRange(
              3, 4, endWeekText.characters.elementAt(3).toUpperCase());
    }
    if (currentChart == 2) {
      startWeek = DateTime(now.year, now.month - 11, now.day);
      endWeek = now;
      final currentlanguageCode = App.of(context)!.currentLocale.languageCode;
      final startWeekText =
          DateFormat('MMM yyyy', currentlanguageCode).format(startWeek);
      final endWeekText =
          DateFormat('MMM yyyy', currentlanguageCode).format(endWeek);
      chartTitle = startWeekText.replaceRange(
              3, 4, startWeekText.characters.elementAt(3).toUpperCase()) +
          ' - ' +
          endWeekText.replaceRange(
              3, 4, endWeekText.characters.elementAt(3).toUpperCase());
    }

    return chartTitle;
  }

  List<String> _getChartBottomTitles() {
    final List<String> lineChartBottomTitles = [];
    switch (currentChart) {
      case 0:
        for (var i = 6; i >= 0; i--) {
          lineChartBottomTitles.add('${now.subtract(Duration(days: i)).day}');
        }
        return lineChartBottomTitles;
      case 1:
        for (var i = 3; i >= -1; i--) {
          final month = 1 + i * 7;
          if (i == -1) {
            lineChartBottomTitles.add(DateFormat('d MMM').format(now));
          } else {
            lineChartBottomTitles.add(
                '${now.subtract(Duration(days: now.weekday + month)).day} ${DateFormat('MMM').format(now.subtract(Duration(days: now.weekday + month)))}');
          }
        }
        return lineChartBottomTitles;
      case 2:
        for (var i = 11; i >= 0; i--) {
          lineChartBottomTitles.add(DateFormat('MMM')
              .format(DateTime(now.year, now.month - i, now.day)));
        }
        return lineChartBottomTitles;
      default:
        return lineChartBottomTitles;
    }
  }

  List<double> _getDotValues({
    required List<AlertStatisticModel> alertStatistics,
    required List<String> lineChartBottomTitles,
  }) {
    List<double> dotValueList = [];
    if (currentChart == 0) {
      for (var d in lineChartBottomTitles) {
        if (alertStatistics.where((e) {
          if (e.id.length == 8) {
            return DateTime.tryParse(e.id)!.day == int.tryParse(d);
          } else {
            return false;
          }
        }).isNotEmpty) {
          var value = alertStatistics
              .firstWhere(
                  (e) => DateTime.tryParse(e.id)!.day == int.tryParse(d))
              .count;
          dotValueList.add(double.tryParse(value)!);
        } else {
          dotValueList.add(0);
        }
      }
    }
    if (currentChart == 1) {
      for (var d in lineChartBottomTitles) {
        if (alertStatistics.where((e) {
          var week = int.tryParse(e.id.substring(4, e.id.length));
          var chartBottomDay = DateFormat('d MMM').parse(d);
          var chartBottomWeek = chartBottomDay.weekOfYear;
          if (e.id.length == 6) {
            return week == chartBottomWeek;
          } else {
            return false;
          }
        }).isNotEmpty) {
          var value = alertStatistics.firstWhere((e) {
            var week = int.tryParse(e.id.substring(4, e.id.length));
            var chartBottomDay = DateFormat('d MMM').parse(d);
            var chartBottomWeek = chartBottomDay.weekOfYear;
            if (e.id.length == 6) {
              return week == chartBottomWeek;
            } else {
              return false;
            }
          }).count;
          dotValueList.add(double.tryParse(value)!);
        } else {
          dotValueList.add(0);
        }
      }
    }
    if (currentChart == 2) {
      for (var d in lineChartBottomTitles) {
        if (alertStatistics.where((e) {
          var year = int.tryParse(e.id.substring(0, 4));
          var month = int.tryParse(e.id.substring(4, e.id.length));
          var dotMonth = DateTime(year!, month!);
          if (e.id.length == 6 && month < 12) {
            return DateFormat('MMM').format(dotMonth) == d;
          } else {
            return false;
          }
        }).isNotEmpty) {
          var value = alertStatistics.firstWhere((e) {
            var year = int.tryParse(e.id.substring(0, 4));
            var month = int.tryParse(e.id.substring(4, e.id.length));
            var dotMonth = DateTime(year!, month!);
            return DateFormat('MMM').format(dotMonth) == d;
          }).count;
          dotValueList.add(double.tryParse(value)!);
        } else {
          dotValueList.add(0);
        }
      }
    }
    return dotValueList;
  }

  Widget _buildUsageItem({
    IconData? icon,
    SvgIconData? svgIcon,
    required String title,
    String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SizedBox(
        height: 118,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Center(
                child: svgIcon != null
                    ? SvgIcon(
                        svgIcon,
                        size: 60,
                      )
                    : Icon(
                        icon,
                        size: 60,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 22),
              child: Text(title),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(value!),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMissedAlarm() {
    final List<TableHeader> tableHeaders = [
      TableHeader(
        title: ScreenUtil.t(I18nKey.date)!,
        width:300,
        isConstant: true,
      ),
      TableHeader(title: ScreenUtil.t(I18nKey.device)!, width: 250),
      TableHeader(
          title: ScreenUtil.t(I18nKey.faceRecoUser)!,
          width: 300,
          isConstant: true),
      TableHeader(
          title: ScreenUtil.t(I18nKey.alarm)!, width: 250, isConstant: true),
    ];
    return Stack(
      children: [
        StreamBuilder(
          stream: _dashboardAlert.allData,
          builder:
              (context, AsyncSnapshot<ApiResponse<DashboardModel?>> snapshot) {
            if (snapshot.hasData) {
              List<EventIdModel> event = snapshot.data!.model!.dashboardAlertModel.rows;
              return DynamicTable(
                tableBorder: Border.all(
                  color: AppColor.white,
                ),
                hasBodyData: true,
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
                numberOfRows: 10,
                rowBuilder: (index) => _rowFor(
                  item:event[index],
                ),
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
          stream: _dashboardAlert.allDataState,
          builder: (context, state) {
            if (!state.hasData || state.data == BlocState.fetching) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: JTCircularProgressIndicator(
                  size: 24,
                  strokeWidth: 2.0,
                  color: Theme.of(context).textTheme.button!.color!,
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    ); 
  }

  TableRow _rowFor({required EventIdModel item}) {
    //_streamController.sink.add(_forAlertStatic(item.alert.eventType.code));
    return TableRow(
      children: [
        tableCellText(title:DateFormat(ScreenUtil.t(I18nKey.formatDMY)!).format(DateTime.parse(item.alert.datetime)) ),
        tableCellText(title: item.alert.deviceid.name),
        tableCellText(title: item.alert.userUpdate),
        tableCellText(title: item.alert.eventType.code=='15872'?'RS485_DISCONNECTED':'Tamper on'),
        // FutureBuilder(
        //   future: _forAlertStatic(item.alert.eventType.code),
        //   builder: (context, AsyncSnapshot<String>snapshot) {
        //     if(snapshot.hasData){
        //       return tableCellText(title: snapshot.data);
        //     }else{
        //       return tableCellText(title: '');
        //     }
        //   },
        // ),
        
      ],
    );
  }
  Future<String> _forAlertStatic(String code)async{
    String name='';
    for(var list in alertStatisticList){
      for(var rd in list.top3Event){
        if(code == rd.eventTypeId.code){
            name= rd.eventTypeId.name;
        }
      }
    }
    return name;
  }

  _noticeDialog(DashboardNoticeModel item) {
    return LayoutBuilder(
      builder: (context, size) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          content: SizedBox(
            width: 500,
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  constraints: const BoxConstraints(minHeight: 40),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      item.name,
                      style: const TextStyle(color: AppColor.white),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Html(data: item.description),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(minHeight: 40),
                  decoration: const BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Center(
                                child: Text(
                                  ScreenUtil.t(I18nKey.confirm)!,
                                  style: const TextStyle(color: AppColor.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  fetchData() {
    _dashboardStatus.fetchDashboardStatus(params: {});
    _dashboardAlertStatistic.fetchDashboardAlertStatistic(params: {'group_id': currentChart});
   _dashboardAlert.fetchDashboardAlert(params: {});
    _dashboardNotice.fetchDashboardNotice(params: {});
  }
}

class UsageItem {
  final SvgIconData? svgIcon;
  final IconData? icon;
  final String? title;
  final String? value;
  UsageItem({
    this.svgIcon,
    this.icon,
    this.title,
    this.value,
  });
}
