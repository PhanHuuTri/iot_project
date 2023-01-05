import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:web_iot/config/fake_data.dart';
import 'package:web_iot/config/svg_constants.dart';

class PieChartJT extends StatefulWidget {
  final List<ChartItemData> pieChart;
  final double? chartWidth;
  final double? chartHeight;

  const PieChartJT({
    Key? key,
    required this.pieChart,
    this.chartWidth,
    this.chartHeight,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartJTState();
}

class PieChartJTState extends State<PieChartJT> {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.chartHeight ?? 250,
      width: widget.chartWidth ?? double.infinity,
      color: Colors.white,
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          
          PieChartData(
            pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            }),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 2,
            centerSpaceRadius: 30,
            sections: showingSections(),
          ),
          swapAnimationDuration:const Duration(milliseconds: 5000),
        ),
        
      ),
    
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget.pieChart.length, (i) {
      final isTouched = i == touchedIndex;
      final radius = isTouched ? 85.0 : 80.0;
      final item = widget.pieChart[i];
      return PieChartSectionData(
        color: item.color,
        value: item.value / item.total!,
        title: '',
        //title: '${item.value}\n${item.title}',
        radius: radius,
        titleStyle: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Theme.of(context).backgroundColor),
      );
    });
  }
}

class Badge extends StatelessWidget {
  final IconData? icon;
  final SvgIconData? svgIcon;
  final double size;
  final Color borderColor;

  const Badge({
    Key? key,
    required this.size,
    required this.borderColor,
    this.icon,
    this.svgIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      child: Center(
        child: svgIcon != null
            ? SvgIcon(
                svgIcon!,
                size: 20,
              )
            : Icon(
                icon ?? Icons.report_gmailerrorred_outlined,
                size: 20,
              ),
      ),
    );
  }
}
