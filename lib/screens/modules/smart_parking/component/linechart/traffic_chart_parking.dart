import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:web_iot/themes/jt_colors.dart';
import 'package:web_iot/themes/jt_text_style.dart';
import '../../../../../../config/svg_constants.dart';
import '../../../../../../core/modules/smart_parking/models/report_in_out_model.dart';
import '../../../../../../main.dart';
import '../../../../../../widgets/chart/line_chart.dart';

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

  @override
  Widget build(BuildContext context) {
    final List<String> lineChartLeftTitles = [
      '0',
      '5',
      '10',
      '15',
    ];
    final showTimeIndex = (DateTime.now().hour);
    final listReportInOut = widget.snapshot.data!.model!.records.first;
    final List<double> dotValueList = listReportInOut.inOutByHour
        .where((e) => (e.index <= showTimeIndex && e.index > showTimeIndex - 7))
        .toList()
        .map((e) => (_getAmountValue(e)).toDouble())
        .toList();
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
      if (element.index <= showTimeIndex && element.index > showTimeIndex - 7) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      ScreenUtil.t(I18nKey.vehicleTraffic)!,
                      style: JTTextStyle.bodyText2(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      dotValueList.last.toString(),
                      style: JTTextStyle.headline1(),
                    ),
                  ),
                  _buildAmountStatusAnimation(
                    nearest: _nearestAmount,
                    latest: _latestAmount,
                    secondNearest: _secondNearestAmount,
                  ),
                ],
              ),
              Container(
                width: 180,
                decoration: BoxDecoration(
                  color: JTColors.white,
                  border: Border.all(
                    color: const Color(0xffC1F4DA),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                ),
                child: Column(
                  children: _buildIndicatorNote(latestVehicleInOut),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 56, 24),
          child: LineChartJT(
            chartHeight: 80.0 * (lineChartLeftTitles.length + 1),
            chartWidth: 100.0 * lineChartBottomTitles.length,
            leftTitles: lineChartLeftTitles,
            bottomTitles: lineChartBottomTitles,
            leftTitlesOffset: Offset(0, lineChartLeftTitles.length - 1),
            bottomTitlesOffset: Offset(0, lineChartBottomTitles.length - 1),
            chartMarginLeft: 33.5,
            chartMarginBottom: 20.56,
            getLeftTextStyles: (index) {
              switch (index) {
                case 0:
                  return TextStyle(color: JTColors.toastShadow, fontSize: 14);
                case 1:
                  return TextStyle(color: JTColors.primary, fontSize: 14);
                case 2:
                  return TextStyle(color: JTColors.card3, fontSize: 14);
                case 3:
                  return TextStyle(color: JTColors.error, fontSize: 14);
                default:
                  return TextStyle(color: JTColors.toastShadow, fontSize: 14);
              }
            },
            getBottomTextStyles: (index) {
              if (index != lineChartBottomTitles.length - 1) {
                return TextStyle(color: JTColors.toastShadow, fontSize: 14);
              } else {
                return TextStyle(color: JTColors.primary, fontSize: 14);
              }
            },
            dotValueList: dotValueList,
            dotMinimumValue: 5,
            isCurved: false,
            showVerticalLine: false,
            chartBorder: Border.symmetric(
              horizontal: BorderSide(color: JTColors.buttonBackground),
            ),
            tooltipBgColor: JTColors.themePrimary,
            getTooltipItems: (value) {
              return value.map((e) {
                final title = dotValueList[e.spotIndex];
                final itemTime = lineChartBottomTitles[e.spotIndex];
                return LineTooltipItem(
                  listReportInOut.date + '\n',
                  JTTextStyle.bodyText1(
                    color: Colors.white,
                  ).copyWith(fontSize: 11),
                  children: [
                    TextSpan(
                      text: '$title ',
                      style: JTTextStyle.headline2(color: Colors.white),
                    ),
                    TextSpan(
                      text: ScreenUtil.t(I18nKey.vehicle)! + '\n',
                      style: JTTextStyle.bodyText1(
                        color: Colors.white,
                      ).copyWith(fontSize: 16),
                    ),
                    TextSpan(
                      text: itemTime,
                      style: JTTextStyle.bodyText1(
                        color: Colors.white,
                      ).copyWith(fontSize: 16),
                    )
                  ],
                  textAlign: TextAlign.left,
                );
              }).toList();
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                ScreenUtil.t(I18nKey.lastUpdated)! +
                    ': ' +
                    lineChartBottomTitles.last +
                    ' - ' +
                    listReportInOut.date,
                style: const TextStyle(fontSize: 12, color: JTColors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildAmountStatusAnimation({
    required int nearest,
    required int latest,
    required int secondNearest,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                    ? JTColors.primary.withOpacity(0.1)
                    : JTColors.error.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2)
            : JTColors.error.withOpacity(0.2)
        : Colors.grey.withOpacity(0.2);
    final Color downColor = isIncrease != null
        ? isIncrease
            ? JTColors.primary.withOpacity(0.1)
            : secondNearest != nearest
                ? nearest > secondNearest
                    ? JTColors.primary.withOpacity(0.1)
                    : JTColors.error.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2)
        : secondNearest != nearest
            ? nearest > secondNearest
                ? JTColors.primary.withOpacity(0.1)
                : JTColors.error.withOpacity(0.2)
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
                    ? JTColors.primary
                    : JTColors.error
                : Colors.black
            : JTColors.error
        : Colors.black;

    final Color downColor = isIncrease != null
        ? isIncrease
            ? JTColors.primary
            : secondNearest != nearest
                ? nearest > secondNearest
                    ? JTColors.primary
                    : JTColors.error
                : Colors.black
        : secondNearest != nearest
            ? nearest > secondNearest
                ? JTColors.primary
                : JTColors.error
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
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  width: 34,
                  height: 32,
                  decoration: BoxDecoration(
                    color: JTColors.themePrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: SvgIcon(
                    i == 0
                        ? SvgIcons.car
                        : i == 2
                            ? SvgIcons.bicycle
                            : SvgIcons.bike,
                    color: JTColors.white,
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
                        style: JTTextStyle.bodyText1()
                            .copyWith(fontWeight: FontWeight.bold),
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
                        style:
                            JTTextStyle.bodyText1(color: JTColors.primaryText),
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
                  style: textStyle ??
                      JTTextStyle.bodyText1(color: JTColors.primaryText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
