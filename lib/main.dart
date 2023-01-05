import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:web_iot/screens/modules/healthy_check/modelDialog/dialogfilterevenhistory.dart';
import 'package:web_iot/screens/modules/healthy_check/modelDialog/filter_model.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import '../locator.dart';
import '../routes/app_route_information_parser.dart';
import '../routes/app_router_delegate.dart';
import '../scroll_behavior.dart';
import '../utils/app_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:tiengviet/tiengviet.dart';
import 'config/svg_constants.dart';
import 'config/theme_data.dart';
import '../core/configuration/api_config.dart';
// Controller
export 'core/authentication/bloc/authentication_bloc_controller.dart';
// Models
export '../core/rest/models/rest_api_response.dart';
export '../core/base/models/common_model.dart';
// Logger
export '../core/logger/logger.dart';
// Preferences
import 'package:shared_preferences/shared_preferences.dart';
import 'core/modules/face_recog/blocs/door/door_bloc.dart';
import 'core/modules/user_management/models/account_model.dart';
import 'locales/i18n.dart';
export 'utils/screen_util.dart';
export 'locales/i18n_key.dart';
export 'config/app_color.dart';
export 'config/validator_text.dart';
//webview
import 'package:web_iot/screens/modules/smart_parking/websub/register_web_webview.dart';

Future<SharedPreferences> prefs = SharedPreferences.getInstance();
// Page index
int mainIndex = 1;
int  userManagementIndex = 1;
int roleIndex = 1;
int faceUserTabIndex = 1;
int faceDeviceTabIndex = 1;
int faceDoorTabIndex = 1;

// Page tab
int smartParkingTab = 0;
int parkingListPage = 1;
int parkingReportIndex = 0;
int healthyhistoryPage=1;
int healthydevicePage=1;
int faceRecognitionTab = 0;
int parkSelectedList = 0;
int parkSelecttabbasment = 0;
int roomControlSelectedTab = 0;

int newNoti = 0;
String deviceOS = '';
String deviceId = '';
//Page search
String userManagementSearchString = '';
String roleSearchString = '';
String parkingListSearchString = '';
String healthyListSearchString = '';
String faceUserSearchString = '';
String? currentFcmToken;
String currentRoomId = '';
bool isAdmin=false;
// healthy
//FilterEventHistory filter;
List<FilterEvent> eventHealthy=[];


final doorStatusBloc = DoorBloc();

enum RolePermissions { admin, security, user }
bool isDropDown = false;
bool showNoti = false;
GlobalKey globalKey = GlobalKey();

navigateTo(String route) async {
  locator<AppRouterDelegate>().navigateTo(route);
  debugPrint(route);
  // if (route == smartMeetingRoute) {
  //   const url = 'http://115.79.31.126:5555/Fusion/WebClient/Default.aspx';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
}

checkRoute(String route) {
  if (route.isNotEmpty &&
      locator<AppRouterDelegate>().currentConfiguration.name != null) {
    return locator<AppRouterDelegate>().currentConfiguration.name == route;
  } else {
    return true;
  }
}

final List<Locale> supportedLocales = <Locale>[
  const Locale('vi'),
  const Locale('en'),
  // const Locale('th'),
];

void main() async {
 WebView.platform = WebWebViewPlatform();
  registerWebViewWebImplementation();
  WidgetsFlutterBinding.ensureInitialized();
  await loadVersion();
  setupLocator();
  getDeviceInfo();
  runApp(
    ChangeNotifierProvider<AppStateNotifier>(
      create: (_) => AppStateNotifier(),
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
  static _AppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>();
}

class _AppState extends State<App> {
  final AppRouteInforParser _routeInfoParser = AppRouteInforParser();
  Locale currentLocale = supportedLocales[0];

  void setLocale(Locale value) {
    setState(() {
      currentLocale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) {
        return MaterialApp.router(
          title: 'Smart Building',
          debugShowCheckedModeBanner: false,
          theme: ThemeConfig.lightTheme,
          darkTheme: ThemeConfig.darkTheme,
          themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routeInformationParser: _routeInfoParser,
          routerDelegate: locator<AppRouterDelegate>(),
          builder: (context, child) => child!,
          scrollBehavior: MyCustomScrollBehavior(),
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            I18n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: supportedLocales,
          locale: currentLocale,
        );
      },
    );
  }
}

loadVersion() async {
  await rootBundle
      .loadString('assets/deploy_version.txt')
      .then((value) => ApiConfig.version = value);
}

searchCompare(String original, String containing) {
  return TiengViet.parse(original.toLowerCase())
      .contains(TiengViet.parse(containing.toLowerCase()));
}

String getPermission(AccountModel currentUser) {
  if (currentUser.isSuperadmin) {
    return 'Super Admin';
  } else if (currentUser.isAdmin) {
    return 'Admin';
  } else if (currentUser.isSecurity) {
    return 'Security';
  } else {
    return 'User';
  }
}

getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
  deviceOS = webBrowserInfo.browserName.name;
  deviceId = webBrowserInfo.vendor! +
      ' ' +
      webBrowserInfo.userAgent! +
      ' ' +
      webBrowserInfo.hardwareConcurrency.toString();
}
