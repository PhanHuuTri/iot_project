import 'package:web_iot/config/fake_data.dart';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/screens/layout_template/content_screen.dart';
import 'package:web_iot/screens/modules/dashboard/warning_list.dart';
import 'package:web_iot/widgets/chart/line_chart.dart';
import 'package:web_iot/widgets/chart/pie_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Filters
  final _pageState = PageState();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return PageTemplate(
      route: dashboardRoute,
      name: I18nKey.dashboard,
      pageState: _pageState,
      onUserFetched: (account) => setState(() {}),
      onFetch: () {},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
        child: Wrap(
          spacing: 16,
          runSpacing: 21,
          children: [
            // _buildPieChart(
            //   title: ScreenUtil.t(I18nKey.smartMeeting)!,
            //   child: PieChartJT(
            //     pieChart: meetingChart,
            //   ),
            //   indicator: _buildIndicator(
            //     note: ScreenUtil.t(I18nKey.status)!,
            //     items: meetingChart,
            //   ),
            // ),
            _buildPieChart(
              title: ScreenUtil.t(I18nKey.smartParking)!,
              child: PieChartJT(
                pieChart: parkingChartcar,
              ),
              indicator: _buildIndicator(
                note: ScreenUtil.t(I18nKey.status)!,
                items: parkingChartcar,
              ),
            ),
            _buildPieChart(
              title: ScreenUtil.t(I18nKey.faceRecognition)!,
              child: PieChartJT(
                pieChart: faceChart,
              ),
              indicator: _buildIndicator(
                note: ScreenUtil.t(I18nKey.status)!,
                items: faceChart,
              ),
            ),
            _buildPieChart(
              title: ScreenUtil.t(I18nKey.userManagement)!,
              child: PieChartJT(
                pieChart: occupancyChart,
              ),
              indicator: _buildIndicator(
                note: ScreenUtil.t(I18nKey.status)!,
                items: occupancyChart,
              ),
            ),
            Card(
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context).textTheme.headline6!.color!,
                      width: double.infinity,
                      child: Text(
                        ScreenUtil.t(I18nKey.healthyCheck)!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: _buildIndicator(
                            note: ScreenUtil.t(I18nKey.status)!,
                            items: healthyChart,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 48, 48, 24),
                            child: LineChartJT(
                              chartHeight: 40.0 * (lineChartUnits.length + 1),
                              chartWidth: 100.0 * lineChartTime.length,
                              bottomTitles: lineChartTime,
                              leftTitles: lineChartUnits,
                              dotValueList: peopleHighHeat,
                              bottomTitlesOffset:
                                  Offset(0, lineChartTime.length - 1),
                              leftTitlesOffset:
                                  Offset(0, lineChartTime.length.toDouble()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: Theme.of(context).textTheme.headline6!.color!,
                      width: double.infinity,
                      child: Text(
                        ScreenUtil.t(I18nKey.riskManagement)!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const WarningList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildPieChart({
    required Widget child,
    required String title,
    double? width,
    required Widget indicator,
  }) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints size) {
      final contentWidth = width ?? 550.0;
      final chartWidth = size.maxWidth > contentWidth * 2 + 16
          ? (size.maxWidth / 2) - 16
          : size.maxWidth;

      return Card(
        child: SizedBox(
          width: chartWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                color: Theme.of(context).textTheme.headline6!.color!,
                width: double.infinity,
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontWeight: FontWeight.bold),
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
