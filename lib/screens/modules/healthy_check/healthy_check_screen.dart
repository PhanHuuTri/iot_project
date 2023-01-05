import 'package:web_iot/core/modules/user_management/blocs/account/account_bloc.dart';
import 'package:web_iot/core/modules/user_management/models/account_model.dart';
import 'package:web_iot/screens/modules/healthy_check/tab_healthycheck/healthy_device.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
//import 'package:web_iot/screens/modules/healthy_check/tab_healthycheck/healthy_list.dart';
import '../../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/screens/layout_template/content_screen.dart';
import 'package:web_iot/widgets/errors/error_message_text.dart';
import 'package:web_iot/config/svg_constants.dart';
import '../../../core/modules/healthycheck/blocs/Healthy/healthy_bloc.dart';
import 'package:web_iot/screens/modules/healthy_check/tab_healthycheck/healthy_history.dart';

class HealthyCheckScreen extends StatefulWidget {
  final int tab;
  final String? id;
  const HealthyCheckScreen({Key? key,required this.tab, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HealthyCheckScreenState();
}

class _HealthyCheckScreenState extends State<HealthyCheckScreen> {
  // Filters
  final _pageState = PageState();
  //final _keywordListController = TextEditingController();
  final _keywordHistoryListController = TextEditingController();
  final _keywordDeviceListController = TextEditingController();
  final _healthyBloc = HealthyBloc();
  final int _limit = 10;
  List<List<String>> listPermissionCodes = [];
  final _accountBloc = AccountBloc();

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
    super.initState();
  }
  @override
  void dispose() {
    _healthyBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      route: healthyCheckRoute,
      name:I18nKey.healthyCheck,
      subName: _getSubName(),
      pageState: _pageState,
      onUserFetched: (account) => setState(() {}),
      onFetch: () =>  _fetchUserDataOnPage,
      child: FutureBuilder(
        future: _pageState.currentUser,
        builder: (context, AsyncSnapshot<AccountModel> snapshot) => PageContent(
           userSnapshot: snapshot,
            pageState: _pageState,
            onFetch: () => _fetchUserDataOnPage,
            route: healthyCheckRoute,
            child: LayoutBuilder(builder: (context, constraints) {
              ScreenUtil.init(context);
              final List<String> tabs = [
                ScreenUtil.t(I18nKey.device)!,
                ScreenUtil.t(I18nKey.history)!
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
                            changeTab: _changeTab, token: '',
                          ),
                        ),
                      ),
                      widget.tab == 0
                          // ? HealthyList(
                          //     keyword: _keywordListController,
                          //     healthyBloc: _healthyBloc,
                          //     fetchHealthyListData: _fetchHealthyListData,
                          //     route: healthyCheckRoute,
                          //     currentUser: snapshot.data!,
                          //   )
                            ? DeviceListHealthyl(
                              changeTab: _changeTab,
                              keyword: _keywordDeviceListController,
                              healthylBloc: _healthyBloc,
                              fetchDeviceListData: _fetchHealthyDeviceListData,
                              route: healthyCheckRoute,
                              currentUser: snapshot.data!,
                            )
                            :HealthyHistory(
                              keyword: _keywordHistoryListController,
                              healthyBloc: _healthyBloc,
                              fetchHistoryData: _fetchHistoryListData,
                              route: healthyCheckRoute,
                              currentUser: snapshot.data!,
                            ),
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
          ),
      ),
    );
  } 
  Widget errmessage(){
    return ErrorMessageText(
        svgIcon: SvgIcons.healthyCheck,
        message: 'coming soon',
      );
  }
   _changeTab(int tab) {
    if (tab == 0) {
      navigateTo(healthyCheckRoute);
    } else if(tab==1){
      navigateTo(healthyCheckDevicesRoute);
    } 
  }
  
  _fetchHealthyDeviceListData(
    int page,
    String  healthydeviceSearchString, {
    int? limit
  }) {
    healthydevicePage =page;
    healthydeviceSearchString = _keywordDeviceListController.text;
    Map<String, dynamic> params = {
      'limit': limit ?? _limit,
      'page': healthydevicePage,
      'name': healthydeviceSearchString,
    };
    _healthyBloc.fetchDeviceData(params: params);
  }
  _fetchHistoryListData(
    int page,
    String mask,String high ,{
    required int from,
    required int to,
  }) {
    healthyhistoryPage = page;
    Map<String, dynamic> params = {
      'limit':5,
      'fromDate': from,
      'toDate': to,
      'page': healthyhistoryPage,
      'mask':mask,
      'highTemperature':high,
    };
    _healthyBloc.fetchHistoryData(params: params);
  }

  _fetchUserDataOnPage(int page, {int? limit}) {
    userManagementIndex = page;
    Map<String, dynamic> params = {
      'limit': limit ?? _limit,
      'page': userManagementIndex,
      'search_string': '',
    };
    _accountBloc.fetchAllData(params: params);
  }
  String? _getSubName() {
    if (widget.tab != null) {
      if (widget.tab == 1) {
        return I18nKey.history;
      }
      return null;
    } else {
      if (widget.id != null) {
        return I18nKey.edit;
      } else {
        return I18nKey.createNew;
      }
    }
  }
}
