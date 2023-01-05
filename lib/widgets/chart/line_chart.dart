import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:web_iot/config/app_color.dart';
import 'package:web_iot/widgets/joytech_components/jt_incicator.dart';

class LineChartJT extends StatefulWidget {
  final double? chartHeight;
  final double? chartWidth;
  final List<Color>? gradientColors;
  final List<String> leftTitles;
  final List<String> bottomTitles;
  final List<double> dotValueList;
  final int dotMinimumValue;
  final List<LineTooltipItem?> Function(List<LineBarSpot>)? getTooltipItems;
  final Border? chartBorder;
  final bool showHorizontalLine;
  final bool showVerticalLine;
  final FlLine? horizontalLine;
  final FlLine? verticalLine;
  final Offset? leftTitlesOffset;
  final Offset? bottomTitlesOffset;
  final double chartMarginLeft;
  final double chartMarginBottom;
  final TextStyle? Function(int)? getLeftTextStyles;
  final TextStyle? Function(int)? getBottomTextStyles;
  final bool isCurved;
  final Color? lineColor;
  final Color? tooltipBgColor;
  final List<int>? dataDash;
  const LineChartJT({
    Key? key,
    this.chartHeight = 300,
    this.chartWidth = double.infinity,
    this.gradientColors,
    required this.leftTitles,
    required this.bottomTitles,
    required this.dotValueList,
    this.dotMinimumValue = 1000,
    this.getTooltipItems,
    this.chartBorder,
    this.showHorizontalLine = true,
    this.showVerticalLine = true,
    this.horizontalLine,
    this.verticalLine,
    this.leftTitlesOffset,
    this.bottomTitlesOffset,
    this.chartMarginLeft = 0,
    this.chartMarginBottom = 0,
    this.lineColor,
    this.tooltipBgColor,
    this.isCurved = true,
    this.dataDash,
    this.getLeftTextStyles,
    this.getBottomTextStyles,
  }) : super(key: key);
  @override
  _LineChartJTState createState() => _LineChartJTState();
}

class _LineChartJTState extends State<LineChartJT> {
  Widget data(List<String> listTitle) {
    return SizedBox(
      height: widget.chartHeight,
      width: widget.chartWidth,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            getTouchedSpotIndicator:
                (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((spotIndex) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: AppColor.primary,
                    strokeWidth: 1,
                    dashArray: widget.dataDash,
                  ),
                  FlDotData(
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 8,
                        color: AppColor.primary,
                        strokeWidth: 4,
                        strokeColor: AppColor.secondary2,
                      );
                    },
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              tooltipRoundedRadius: 16,
              tooltipPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              tooltipBgColor:
                  widget.tooltipBgColor ?? Theme.of(context).backgroundColor,
              getTooltipItems: widget.getTooltipItems,
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: widget.showHorizontalLine,
            drawVerticalLine: widget.showVerticalLine,
            getDrawingHorizontalLine: (value) {
              return widget.horizontalLine ??
                  FlLine(
                    strokeWidth: 1,
                    color: AppColor.buttonBackground,
                  );
            },
            getDrawingVerticalLine: (value) {
              return widget.verticalLine ??
                  FlLine(
                    strokeWidth: 1,
                    color: AppColor.buttonBackground,
                  );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: SideTitles(showTitles: false),
            topTitles: SideTitles(showTitles: false),
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 16,
              interval: 1,
              margin: widget.chartMarginLeft,
              getTextStyles: (context, value) =>
                  widget.getLeftTextStyles != null
                      ? widget.getLeftTextStyles!(value.toInt())
                      : TextStyle(color: AppColor.dividerColor, fontSize: 12),
              getTitles: (value) {
                for (var leftTitle in listTitle) {
                  if (value.toInt() == listTitle.indexOf(leftTitle)) {
                    return leftTitle;
                  }
                }
                return '';
              },
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 16,
              interval: 1,
              margin: widget.chartMarginBottom,
              getTextStyles: (context, value) =>
                  widget.getBottomTextStyles != null
                      ? widget.getBottomTextStyles!(value.toInt())
                      : TextStyle(color: AppColor.dividerColor, fontSize: 12),
              getTitles: (value) {
                for (var bottomTitle in widget.bottomTitles) {
                  if (value.toInt() ==
                      widget.bottomTitles.indexOf(bottomTitle)) {
                    return bottomTitle;
                  }
                }
                return '';
              },
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: widget.chartBorder ??
                Border.all(color: AppColor.buttonBackground),
          ),
          minX: widget.bottomTitlesOffset != null
              ? widget.bottomTitlesOffset!.dx
              : 0,
          maxX: widget.bottomTitlesOffset != null
              ? widget.bottomTitlesOffset!.dy
              : widget.bottomTitles.length.toDouble(),
          minY:
              widget.leftTitlesOffset != null ? widget.leftTitlesOffset!.dx : 0,
          maxY: widget.leftTitlesOffset != null
              ? widget.leftTitlesOffset!.dy
              : listTitle.length.toDouble(),
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(widget.dotValueList.length, (i) {
                return FlSpot(
                  i.toDouble(),
                  (widget.dotValueList[i] - double.parse(listTitle[0])) /
                      double.parse(listTitle[1]).ceil(),
                );
              }),
              isCurved: widget.isCurved,
              colors: [widget.lineColor ?? Theme.of(context).primaryColor],
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                colors: widget.gradientColors ??
                    [
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      Theme.of(context).primaryColor.withOpacity(0.0),
                    ],
                gradientColorStops: [0.5, 1],
                gradientFrom: const Offset(0, 0),
                gradientTo: const Offset(0, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getlistleftchart(widget.dotValueList),
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        //debugPrint(snapshot.data.toString());
        if (snapshot.hasData) {
          if (snapshot.data!.where((element) => element != '0').isNotEmpty) {
            return data(snapshot.data!);
          } else {
            List<String> TitileChartList = [
              '0',
              '5',
              '10',
              '15',
              '20',
              '25',
              '30',
              '35',
              '40',
              '45',
              '50',
              '55',
              '60'
            ];
            return data(TitileChartList);
          }
        } else if (snapshot.hasError) {
          return JTCircularProgressIndicator(
            size: 24,
            strokeWidth: 2.0,
            color: Theme.of(context).textTheme.button!.color!,
          );
        } else {
          return JTCircularProgressIndicator(
            size: 24,
            strokeWidth: 2.0,
            color: Theme.of(context).textTheme.button!.color!,
          );
        }
      },
    );
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
}
