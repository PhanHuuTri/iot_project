import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:web_iot/widgets/joytech_components/jt_incicator.dart';
import '../../../../config/svg_constants.dart';
import '../../../../core/modules/smart_parking/models/report_in_out_model.dart';
import '../../../../main.dart';
import '../../../../widgets/chart/line_chart.dart';

class TrafficChart extends StatefulWidget {
  final AsyncSnapshot<ApiResponse<ListReportInOutModel?>> snapshot;
  const TrafficChart({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  @override
  State<TrafficChart> createState() => _TrafficChartState();
}

class _TrafficChartState extends State<TrafficChart>
    with TickerProviderStateMixin {
  late final AnimationController _upController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  late final AnimationController _downController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );
  //OA: OffsetAnimation
  late Animation<Offset> _upOffsetAnimation = Tween<Offset>(
    begin: const Offset(0, 0),
    end: const Offset(0, -1),
  ).animate(CurvedAnimation(
    parent: _upController,
    curve: Curves.linear,
  ));
  late Animation<Offset> _downOffsetAnimation = Tween<Offset>(
    begin: const Offset(0, 1),
    end: const Offset(0, 0),
  ).animate(CurvedAnimation(
    parent: _downController,
    curve: Curves.linear,
  ));
  int _latestAmount = 0;
  int _nearestAmount = 0;
  int _secondNearestAmount = 0;
  Future<double> _getminivalue(List<double> dotValueList) async {
    double n;
    double max = 0;
    for (double i in dotValueList) {
      if (i > max) max = i;
    }
    n = max / 5;
    return n;
  }

  Future<List<String>> _getlistleftchart(List<double> dotValueList) async {
    double max = 0;
    var n;
    List<String> n1;
    for (double i in dotValueList) {
      if (i > max) max = i;
    }
    n = (max / 5).ceil();
    n1 = <String>["0", "$n", "${n * 2}", "${n * 3}", "${n * 4}", "${n * 5}"];

    return n1;
  }

  Future<List<Object>> _getall(List<double> dotValueList) async {
    final values = await Future.wait(
        [_getlistleftchart(dotValueList), _getminivalue(dotValueList)]);
    return values;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    List<String> lineChartLeftTitles = [];
    final showTimeIndex = DateTime.now().hour;
    final listReportInOut = widget.snapshot.data!.model!.records.first;
    final List<double> dotValueList = [3,5,25,17,18,4,3,7,9,13,15,6];
    // listReportInOut.inOutByHour
    //     .map((e) => (_getAmountValue(e)).toDouble())
    //     .toList();
    // final List<double> datafake =;
    // lineChartLeftTitles=_getlistleftchart(dotValueList);
    // // for(var item in lineChartLeftTitles){
    // //   debugPrint('Bãi đậu xe '+item);
    // // }
    // int mini = _getminivalue(dotValueList).ceil();
    final latestVehicleInOut = listReportInOut.inOutByHour
        .firstWhere((e) => (e.index == showTimeIndex));
    final nearestVehicleInOut = listReportInOut.inOutByHour.firstWhere((e) {
      if (e.index == showTimeIndex - 1) {
        return e.index == showTimeIndex - 1;
      } else {
        return e.index == showTimeIndex;
      }
    });
    final secondNearestVehicleInOut =
        listReportInOut.inOutByHour.firstWhere((e) {
      if (e.index == showTimeIndex - 2) {
        return e.index == showTimeIndex - 2;
      } else if (e.index == showTimeIndex - 1) {
        return e.index == showTimeIndex - 1;
      } else {
        return e.index == showTimeIndex;
      }
    });

    final List<String> lineChartBottomTitles = [];
    for (var element in listReportInOut.inOutByHour) {
      if (element.index <= showTimeIndex ) {
        lineChartBottomTitles.add(element.hours);
      }
    }
    _secondNearestAmount = _getAmountValue(secondNearestVehicleInOut);
    _nearestAmount = _getAmountValue(nearestVehicleInOut);
    _latestAmount = _getAmountValue(latestVehicleInOut);

    _getOffsetAnimation(_latestAmount - _nearestAmount);
    if (_latestAmount != _nearestAmount ||
        _nearestAmount != _secondNearestAmount) {
      if (_upController.value == 0) {
        _upController.forward();
        _downController.forward().whenComplete(() {
          _getOffsetAnimation(_latestAmount - _nearestAmount);
        });
      } else {
        _upController.reverse();
        _downController.reverse().whenComplete(() {
          _getOffsetAnimation(_latestAmount - _nearestAmount);
        });
      }
    }
    Widget lineChart(List<String> listString, double values ){
      return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment : WrapAlignment.center,
                  crossAxisAlignment:WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 170,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              ScreenUtil.t(I18nKey.vehicleTraffic)!,
                              style: textTheme.bodyText2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Text(
                              dotValueList.last.toString(),
                              style: textTheme.headline1!.copyWith(fontSize: 22),
                            ),
                          ),
                          _buildAmountStatusAnimation(
                            nearest: _nearestAmount,
                            latest: _latestAmount,
                            secondNearest: _secondNearestAmount,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 500,
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        border: Border.all(
                          color: const Color(0xffC1F4DA),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _buildIndicatorNote(latestVehicleInOut),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 56, 24),
                child: LineChartJT(
                  chartHeight: 50 * (listString.length + 1),
                  chartWidth: 50.0 * lineChartBottomTitles.length,
                  leftTitles: listString,
                  bottomTitles: lineChartBottomTitles,
                  leftTitlesOffset: Offset(0, listString.length - 1),
                  bottomTitlesOffset:
                      Offset(0, lineChartBottomTitles.length - 1),
                  chartMarginLeft: 33.5,
                  chartMarginBottom: 20.56,
                  getLeftTextStyles: (index) {
                    switch (index) {
                      case 0:
                        return TextStyle(
                            color: AppColor.toastShadow, fontSize: 14);
                      case 1:
                        return TextStyle(color: AppColor.primary, fontSize: 14);
                      case 2:
                        return TextStyle(color: AppColor.card3, fontSize: 14);
                      case 3:
                        return TextStyle(color: AppColor.error, fontSize: 14);
                      default:
                        return TextStyle(
                            color: AppColor.toastShadow, fontSize: 14);
                    }
                  },
                  getBottomTextStyles: (index) {
                    if (index != lineChartBottomTitles.length - 1) {
                      return TextStyle(
                          color: AppColor.toastShadow, fontSize: 14);
                    } else {
                      return TextStyle(color: AppColor.primary, fontSize: 14);
                    }
                  },
                  dotValueList: dotValueList,
                  dotMinimumValue: values.ceil(), 
                  isCurved: false,
                  showVerticalLine: false,
                  chartBorder: Border.symmetric(
                    horizontal: BorderSide(color: AppColor.buttonBackground),
                  ),
                  tooltipBgColor: Theme.of(context).primaryColor,
                  getTooltipItems: (value) {
                    return value.map((e) {
                      final title = dotValueList[e.spotIndex];
                      final itemTime = lineChartBottomTitles[e.spotIndex];
                      return LineTooltipItem(
                        listReportInOut.date + '\n',
                        textTheme.bodyText1!
                            .copyWith(color: Colors.white, fontSize: 11),
                        children: [
                          TextSpan(
                            text: '$title ',
                            style: textTheme.headline2!
                                .copyWith(color: Colors.white),
                          ),
                          TextSpan(
                            text: ScreenUtil.t(I18nKey.vehicle)! + '\n',
                            style: textTheme.bodyText1!
                                .copyWith(color: Colors.white, fontSize: 16),
                          ),
                          TextSpan(
                            text: itemTime,
                            style: textTheme.bodyText1!
                                .copyWith(color: Colors.white, fontSize: 16),
                          )
                        ],
                        textAlign: TextAlign.left,
                      );
                    }).toList();
                  },
                ),
              ),
            ],
          );
        
    }

    return FutureBuilder<List<Object>>(
      future: _getall(dotValueList),
      builder: (context, AsyncSnapshot<List<Object>> snapshot) {
        if (snapshot.hasData) {
          if((snapshot.data![0] as List<String>).where((element) => element!='0').isEmpty){
            List<String> listString= ['0','10','20','30','40'];

            return lineChart(listString,10);
          }
          return lineChart(snapshot.data![0] as List<String>, snapshot.data![1] as double);
        }else if (snapshot.hasError) {
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
      },
    );
  }

  _buildAmountStatusAnimation({
    required int nearest,
    required int latest,
    required int secondNearest,
  }) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Stack(
        children: [
          const Positioned(
            top: -10,
            child: SizedBox(),
          ),
          //up background
          if (latest > nearest)
            _buildAmountBackground(
              isIncrease: true,
              latest: latest,
              nearest: nearest,
              secondNearest: secondNearest,
            ),
          if (latest < nearest)
            _buildAmountBackground(
              isIncrease: false,
              latest: latest,
              nearest: nearest,
              secondNearest: secondNearest,
            ),
          if (latest == nearest)
            _buildAmountBackground(
              latest: latest,
              nearest: nearest,
              secondNearest: secondNearest,
            ),
          //down background
          if (latest > nearest)
            _buildAmountBackground(
              isIncrease: true,
              isForward: false,
              latest: latest,
              nearest: nearest,
              secondNearest: secondNearest,
            ),
          if (latest < nearest)
            _buildAmountBackground(
              isIncrease: false,
              isForward: false,
              latest: latest,
              nearest: nearest,
              secondNearest: secondNearest,
            ),
          if (latest == nearest)
            _buildAmountBackground(
              isForward: false,
              latest: latest,
              nearest: nearest,
              secondNearest: secondNearest,
            ),
          //up content
          if (latest > nearest)
            _buildAmountContent(
              isIncrease: true,
              latest: latest,
              nearest: nearest,
              secondNearest: secondNearest,
            ),
          if (latest < nearest)
            _buildAmountContent(
              isIncrease: false,
              latest: latest,
              nearest: nearest,
              secondNearest: secondNearest,
            ),
          if (latest == nearest)
            _buildAmountContent(
              latest: latest,
              nearest: nearest,
              secondNearest: secondNearest,
            ),
          //down content
          if (latest > nearest)
            _buildAmountContent(
              isIncrease: true,
              isForward: false,
              latest: latest,
              nearest: nearest,
              secondNearest: secondNearest,
            ),
          if (latest < nearest)
            _buildAmountContent(
              isIncrease: false,
              isForward: false,
              latest: latest,
              nearest: nearest,
              secondNearest: secondNearest,
            ),
          if (latest == nearest)
            _buildAmountContent(
              isForward: false,
              latest: latest,
              nearest: nearest,
              secondNearest: secondNearest,
            ),
        ],
      ),
    );
  }

  Widget _buildAmountBackground({
    required int nearest,
    required int latest,
    required int secondNearest,
    bool? isIncrease,
    bool isForward = true,
  }) {
    final Color upColor = isIncrease != null
        ? isIncrease
            ? secondNearest != nearest
                ? nearest > secondNearest
                    ? AppColor.primary.withOpacity(0.1)
                    : AppColor.error.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2)
            : AppColor.error.withOpacity(0.2)
        : Colors.grey.withOpacity(0.2);
    final Color downColor = isIncrease != null
        ? isIncrease
            ? AppColor.primary.withOpacity(0.1)
            : secondNearest != nearest
                ? nearest > secondNearest
                    ? AppColor.primary.withOpacity(0.1)
                    : AppColor.error.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2)
        : secondNearest != nearest
            ? nearest > secondNearest
                ? AppColor.primary.withOpacity(0.1)
                : AppColor.error.withOpacity(0.2)
            : Colors.grey.withOpacity(0.2);
    return isForward
        ? _statusText(
            position: _upOffsetAnimation,
            statusColor: upColor,
            text: '',
          )
        : _statusText(
            position: _downOffsetAnimation,
            statusColor: downColor,
            text: '',
          );
  }

  Widget _buildAmountContent({
    required int nearest,
    required int latest,
    required int secondNearest,
    bool? isIncrease,
    bool isForward = true,
  }) {
    final amount = latest - nearest;
    final Color upColor = isIncrease != null
        ? isIncrease
            ? secondNearest != nearest
                ? nearest > secondNearest
                    ? AppColor.primary
                    : AppColor.error
                : Colors.black
            : AppColor.error
        : Colors.black;

    final Color downColor = isIncrease != null
        ? isIncrease
            ? AppColor.primary
            : secondNearest != nearest
                ? nearest > secondNearest
                    ? AppColor.primary
                    : AppColor.error
                : Colors.black
        : secondNearest != nearest
            ? nearest > secondNearest
                ? AppColor.primary
                : AppColor.error
            : Colors.black;

    final String upText = isIncrease != null
        ? isIncrease
            ? secondNearest != nearest
                ? nearest > secondNearest
                    ? ScreenUtil.t(I18nKey.increase)! +
                        ' $amount ' +
                        ScreenUtil.t(I18nKey.vehicle)!.toLowerCase()
                    : ScreenUtil.t(I18nKey.reduce)! +
                        ' ${-amount} ' +
                        ScreenUtil.t(I18nKey.vehicle)!.toLowerCase()
                : ScreenUtil.t(I18nKey.noChange)!
            : ScreenUtil.t(I18nKey.reduce)! +
                ' ${-amount} ' +
                ScreenUtil.t(I18nKey.vehicle)!.toLowerCase()
        : ScreenUtil.t(I18nKey.noChange)!;

    final String downText = isIncrease != null
        ? isIncrease
            ? ScreenUtil.t(I18nKey.increase)! +
                ' $amount ' +
                ScreenUtil.t(I18nKey.vehicle)!.toLowerCase()
            : secondNearest != nearest
                ? nearest > secondNearest
                    ? ScreenUtil.t(I18nKey.increase)! +
                        ' $amount ' +
                        ScreenUtil.t(I18nKey.vehicle)!.toLowerCase()
                    : ScreenUtil.t(I18nKey.reduce)! +
                        ' ${-amount} ' +
                        ScreenUtil.t(I18nKey.vehicle)!.toLowerCase()
                : ScreenUtil.t(I18nKey.noChange)!
        : ScreenUtil.t(I18nKey.noChange)!;

    return isForward
        ? _statusText(
            position: _upOffsetAnimation,
            statusColor: Colors.transparent,
            text: upText,
            textStyle: TextStyle(
              color: upColor,
            ),
            icon: isIncrease != null
                ? Icon(
                    isIncrease
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: upColor,
                  )
                : null,
          )
        : _statusText(
            position: _downOffsetAnimation,
            statusColor: Colors.transparent,
            text: downText,
            textStyle: TextStyle(
              color: downColor,
            ),
            icon: isIncrease != null
                ? Icon(
                    isIncrease
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: downColor,
                  )
                : null,
          );
  }

  int _getAmountValue(InOutModel model) {
    final value =
        (model.inVehicle.car + model.inVehicle.moto + model.inVehicle.bicycle) -
            (model.outVehicle.car +
                model.outVehicle.moto +
                model.outVehicle.bicycle);
    return value;
  }

  _getOffsetAnimation(int amount) {
    if (_upController.value == 0) {
      if (amount > 0) {
        _upOffsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(0, -1),
        ).animate(CurvedAnimation(
          parent: _upController,
          curve: Curves.linear,
        ));
        _downOffsetAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: _downController,
          curve: Curves.linear,
        ));
      } else {
        _upOffsetAnimation = Tween<Offset>(
          begin: const Offset(0, -1),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: _upController,
          curve: Curves.linear,
        ));
        _downOffsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(0, 1),
        ).animate(CurvedAnimation(
          parent: _downController,
          curve: Curves.linear,
        ));
      }
    } else {
      if (amount > 0) {
        _upOffsetAnimation = Tween<Offset>(
          begin: const Offset(0, -1),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: _upController,
          curve: Curves.linear,
        ));
        _downOffsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(0, 1),
        ).animate(CurvedAnimation(
          parent: _downController,
          curve: Curves.linear,
        ));
      } else {
        _upOffsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(0, -1),
        ).animate(CurvedAnimation(
          parent: _upController,
          curve: Curves.linear,
        ));
        _downOffsetAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: _downController,
          curve: Curves.linear,
        ));
      }
    }
  }

  List<Widget> _buildIndicatorNote(InOutModel item) {
    List<Widget> children = [];
    for (var i = 0; i < 3; i++) {
      int value = 0;
      switch (i) {
        case 0:
          value = (0 + item.inVehicle.car - item.outVehicle.car);
          break;
        case 1:
          value = (0 + item.inVehicle.moto - item.outVehicle.moto);
          break;
        case 2:
          value = (0 + item.inVehicle.bicycle - item.outVehicle.bicycle);
          break;
        default:
      }
      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: SvgIcon(
                    i == 0
                        ? SvgIcons.car
                        : i == 2
                            ? SvgIcons.bicycle
                            : SvgIcons.bike,
                    color: Theme.of(context).backgroundColor,
                    size: 18,
                  ),
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
                        value.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.bold,fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        i == 0
                            ? ScreenUtil.t(I18nKey.car)!
                            : i == 2
                                ? ScreenUtil.t(I18nKey.bicycle)!
                                : ScreenUtil.t(I18nKey.bike)!,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
      if (i < 2) {
        children.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Divider(
            color: Color(0xffC1F4DA),
          ),
        ));
      }
    }
    return children;
  }

  Widget _statusText({
    required Color statusColor,
    required String text,
    TextStyle? textStyle,
    Icon? icon,
    required Animation<Offset> position,
  }) {
    return SlideTransition(
      position: position,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Container(
          constraints: const BoxConstraints(minWidth: 150),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon,
              Center(
                child: Text(
                  text,
                  style: textStyle ?? Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class JcharModel {
  final List<String> values;
  final double mini;
  JcharModel(this.values, this.mini);
}
