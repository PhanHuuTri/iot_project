import 'package:web_iot/core/modules/smart_parking/blocs/barrier_bloc/barrier_bloc.dart';
import 'package:web_iot/core/modules/smart_parking/blocs/report_in_out/report_in_out_bloc.dart';
import 'package:web_iot/core/modules/smart_parking/blocs/webview/viebview_bloc.dart';
import 'package:web_iot/core/modules/smart_parking/models/webview_model.dart';
import 'package:web_iot/screens/modules/smart_parking/component/car_park_status.dart';
import '../../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import '../../../core/modules/smart_parking/blocs/empty_slot/empty_slot_bloc.dart';
import '../../../core/modules/smart_parking/blocs/vehicle/vehicle_bloc.dart';
import '../../../core/modules/user_management/models/account_model.dart';
import '../../../main.dart';
import '../../../routes/route_names.dart';
import '../../../widgets/joytech_components/joytech_components.dart';
import '../../layout_template/content_screen.dart';
import 'component/traffic_list.dart';
import 'component/parking_list.dart';
import 'package:flutter/material.dart';

class SmartParkingScreen extends StatefulWidget {
  final int tab;
  const SmartParkingScreen({Key? key, required this.tab}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SmartParkingScreenState();
}

class _SmartParkingScreenState extends State<SmartParkingScreen> {
  // Filters
  final _pageState = PageState();
  final _keywordController = TextEditingController();
  final _parkingFilter = ParkingFilterController();
  final _vehicleBloc = VehicleBloc();
  final _webviewBloc = WebviewBloc();
  final _barrierBloc = BarrierBloc();
  final _motoEmptySlotBloc = EmptySlotBloc();
  final _carEmptySlotBloc = EmptySlotBloc();
  final _carSlotBloc = EmptySlotBloc();
  final _carAndBikeSlotBloc = EmptySlotBloc();
  final _reportInOutBloc = ReportInOutBloc();
  final _now = DateTime.now();
  int _limit = 5;
  List<List<String>> listPermissionCodes = [];
  final VehicleBloc _vehicleExceptionBloc = VehicleBloc();

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    _fetchDataOnPage();
    _fetchTokenWebView();
    _fetchDataCarAndBike();
    super.initState();
  }

  @override
  void dispose() {
    _carAndBikeSlotBloc.dispose();
    _barrierBloc.dispose();
    _webviewBloc.dispose();
    _vehicleBloc.dispose();
    _carEmptySlotBloc.dispose();
    _motoEmptySlotBloc.dispose();
    _reportInOutBloc.dispose();
    _vehicleExceptionBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      route: smartParkingRoute,
      name: I18nKey.smartParking,
      pageState: _pageState,
      onUserFetched: (account) => setState(() {}),
      onFetch: () => _fetchDataOnPage(),
      child: FutureBuilder(
        future: _pageState.currentUser,
        builder: (context, AsyncSnapshot<AccountModel> snapshot) => PageContent(
          userSnapshot: snapshot,
          pageState: _pageState,
          onFetch: () => _fetchDataOnPage(),
          route: smartParkingRoute,
          child: StreamBuilder(
            stream: _webviewBloc.token,
            builder: (context,
                AsyncSnapshot<ApiResponse<WebViewModel?>> snapshottoken) {
              //debugPrint("Token data"+snapshottoken.data!.model!.data);
              if (snapshottoken.hasData) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: LayoutBuilder(builder: (context, constraints) {
                    ScreenUtil.init(context);
                    final List<String> tabs = [
                      ScreenUtil.t(I18nKey.vehicleTraffic)!,
                      ScreenUtil.t(I18nKey.carParkStatus)!,
                      ScreenUtil.t(I18nKey.statisticreport)!,
                      'Trang web',
                    ];
                    if (snapshot.hasData) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: SizedBox(
                                height: 40,
                                child: JTTabMenu(
                                  tabs: tabs,
                                  currentTab: widget.tab,
                                  changeTab: _changeTab,
                                  token: snapshottoken.data!.model!.data,
                                ),
                              ),
                            ),
                            widget.tab == 0
                                ? TrafficList(
                                    changeTab: (tab) {
                                      setState(() {
                                        _changeTab(tab);
                                        final now = DateTime.now();
                                        final startDate = DateTime(now.year,
                                            now.month, now.day - 1, 0, 0);
                                        final endDate = startDate.add(
                                            const Duration(
                                                hours: 23, minutes: 59));
                                        _fetchParkingListData(
                                          1,
                                          _limit,
                                          '',
                                          from:
                                              startDate.millisecondsSinceEpoch,
                                          to: endDate.millisecondsSinceEpoch,
                                        );
                                      });
                                    },
                                    onFetch: _fetchDataOnPage,
                                    motoEmptySlotBloc: _motoEmptySlotBloc,
                                    carEmptySlotBloc: _carEmptySlotBloc,
                                    reportInOutBloc: _reportInOutBloc,
                                    carslotBloc: _carSlotBloc,
                                  )
                                : widget.tab == 1
                                    ? CarParkStatus(
                                        motoEmptySlotBloc: _motoEmptySlotBloc,
                                        carEmptySlotBloc: _carEmptySlotBloc,
                                        reportInOutBloc: _reportInOutBloc,
                                        changeTab: _changeTab,
                                        fetchBarrier:
                                            _barrierBloc.fetchOpenBarrier,
                                        barrierBloc: _barrierBloc,
                                        carAndBikeEmptySlotBloc:
                                            _carAndBikeSlotBloc, fetchCarAndBike: _fetchDataCarAndBike,
                                      )
                                    : ParkingList(
                                        changeTab: _changeTab,
                                        keyword: _keywordController,
                                        parkingFilter: _parkingFilter,
                                        onStatusChanged: (values) {
                                          setState(() => _parkingFilter
                                              .selectedStatus = values);
                                        },
                                        onUpdateTimeChanged: (value) {
                                          _parkingFilter.selectedUpdateTime =
                                              value;
                                        },
                                        onFilterCleared: () {
                                          setState(() {
                                            _parkingFilter.selectedStatus = [];
                                            _parkingFilter.selectedUpdateTime =
                                                '';
                                          });
                                        },
                                        vehicleBloc: _vehicleBloc,
                                        fetchParkingListData:
                                            _fetchParkingListData,
                                        vehicleExceptionBloc:
                                            _vehicleExceptionBloc,
                                        fetchParkingExceptionData:
                                            _fetchParkingExceptionData,
                                        route: smartParkingRoute,
                                        currentUser: snapshot.data!,
                                      ),
                            //: js.context.callMethod('open', [url]);
                            // ReportFullSlot(
                            //     changeTab: _changeTab,
                            //     route: reportFullSlotRoute,
                            //     currentUser: snapshot.data!, fetchToken:  _fetchTokenWebView,
                            //     webviewBloc: _webviewBloc,
                            //   ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
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
                  alignment: Alignment.center,
                  child: JTCircularProgressIndicator(
                    size: 20,
                    strokeWidth: 1.5,
                    color: AppColor.primary,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _changeTab(int tab) {
    if (tab == 0) {
      navigateTo(smartParkingRoute);
    } else if (tab == 1) {
      navigateTo(carParkStatus);
    } else if (tab == 2) {
      navigateTo(parkingRoute);
    } else if (tab == 3) {
      navigateTo(reportFullSlotRoute);
    }
  }

  _fetchIdBarrier(String id) {
    _barrierBloc.fetchOpenBarrier(id);
  }

  _fetchParkingListData(
    int page,
    int limit,
    String search, {
    required int from,
    required int to,
  }) {
    parkingListPage = page;
    final fromDate = from / 1000;
    final toDate = to / 1000;
    _limit = limit;
    parkingListSearchString = search;
    Map<String, dynamic> params = {
      'fromDate': fromDate,
      'toDate': toDate,
      'limit': _limit,
      'page': parkingListPage,
      'plateNumber': parkingListSearchString
    };
    _vehicleBloc.fetchAllData(params: params);
  }

  _fetchParkingExceptionData(
    int page, {
    required int from,
    required int to,
  }) {
    parkingListPage = page;
    final fromDate = from / 1000;
    final toDate = to / 1000;
    parkingListSearchString = _keywordController.text;
    Map<String, dynamic> params = {
      'fromDate': fromDate,
      'toDate': toDate,
      'limit': _limit,
      'page': parkingListPage,
      'plateNumber': parkingListSearchString
    };
    _vehicleExceptionBloc.fetchAllVehiclesException(params: params);
  }

  _fetchTokenWebView() {
    _webviewBloc.fetchDataToken(params: {});
  }

  _fetchDataCarAndBike() {
    _carAndBikeSlotBloc.fetchAllMotoAndBile(params: {});
  }

  _fetchDataOnPage({
    int? from,
    int? to,
  }) {
    final initFrom = _now.toUtc();
    final initTo = initFrom.add(const Duration(days: 1));
    final fromDate = from ?? initFrom.millisecondsSinceEpoch ~/ 1000;
    final toDate = to ?? initTo.millisecondsSinceEpoch ~/ 1000;
    //time have fake date
    // const fromDate = 1635206400;
    // const toDate = 1635267600;
    Map<String, dynamic> params = {
      'fromDate': fromDate,
      'toDate': toDate,
    };
    _carSlotBloc.fetchslotCar(params: {});
    _reportInOutBloc.fetchAllData(params: params);
    _motoEmptySlotBloc.fetchAllMoto(params: {});
    _carEmptySlotBloc.fetchAllCar(params: {});
  }
}

class ParkingFilterController {
  List<String> selectedStatus = [];
  String selectedUpdateTime = '';

  bool get hasFilter =>
      selectedStatus.isNotEmpty || selectedUpdateTime.isNotEmpty;
}
