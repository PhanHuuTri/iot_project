import 'package:flutter/material.dart';
import 'package:web_iot/routes/no_animation_transition_delegate.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/routes/route_path.dart';
import 'package:web_iot/screens/layout_template/component/conflict_lang.dart';
import 'package:web_iot/screens/modules/smart_parking/component/car_park_status.dart';
import 'package:web_iot/screens/not_found/page_not_found_screen.dart';
import 'package:web_iot/screens/onboarding/authentication_screen.dart';
import 'package:web_iot/screens/onboarding/reset_password_screen.dart';
import '../screens/modules/risk_Management/risk_Management_screen.dart';
import '../screens/modules/building_management/building_management_screen.dart';
import '../screens/modules/dashboard/dashboard_screen.dart';
import '../screens/modules/face_recognition/face_recognition_screen.dart';
import '../screens/modules/healthy_check/healthy_check_screen.dart';
import '../screens/modules/occupancy_monitor/occupancy_monitor_screen.dart';
import '../screens/modules/smart_parking/smart_parking_screen.dart';
import '../screens/modules/user_management/userInfo/user_profile_screen.dart';
import '../screens/modules/user_management/user_management_screen.dart';
// import '../screens/modules/smart_meeting/coming_soon_screen.dart';
// import 'package:web_iot/screens/modules/user_management/roles/role_create_screen.dart';
// import '../screens/modules/user_management/roles/role_screen.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  String _routePath = '';

  @override
  AppRoutePath get currentConfiguration => AppRoutePath.routeFrom(_routePath);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      transitionDelegate: NoAnimationTransitionDelegate(),
      pages: [
        _pageFor(_routePath),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the list of pages by setting _selectedBook to null
        notifyListeners();

        return true;
      },
    );
  }

  _pageFor(String route) {
    return MaterialPage(
      key: const ValueKey('BooksListPage'),
      child: _screenFor(route),
    );
  }

  _screenFor(String route) {
    if (route == sideBarRoute || route == dashboardRoute) {
      return const DashboardScreen();
    }
    if (route == userProfileRoute) {
      return const UserProfileScreen();
    }
    //authentication
    if (route == authenticationRoute) {
      return const AuthenticationScreen();
    }
    if (route == conflictLangRoute) {
      return const ConflictLang();
    }
    if (route == resetPasswordRoute) {
      return const ResetPasswordScreen();
    }
    if (route == forgotPasswordRoute) {
      return const AuthenticationScreen(isLogin: false);
    }
    //smart meeting
    // if (route == smartMeetingRoute) {
    //   return const ComingSoonScreen();
    // }
    // if (route == myMeetingRoute) {
    //   return const MyMeetingScreen();
    // }
    // if (route == addMeetingRoute) {
    //   return const AddMeetingScreen();
    // }
    //user management
    if (route == userManagementRoute) {
      return const UserManagementScreen(tab: 0);
    }
    if (route == roleRoute) {
      return const UserManagementScreen(tab: 1);
    }
    if (route == createRoleRoute) {
      return const UserManagementScreen();
    }
    if (route.startsWith(editRoleRoute)) {
      if (route.length > editRoleRoute.length) {
        final id = route.substring(editRoleRoute.length + 1, route.length);
        if (id.isNotEmpty) return UserManagementScreen(id: id);
      }
      return const UserManagementScreen(tab: 1);
    }
    //smart parking
    if (route == smartParkingRoute) {
      return const SmartParkingScreen(tab: 0);
    }
    if (route == carParkStatus) {
      return const SmartParkingScreen(tab: 1);;
    }
    if (route == parkingRoute) {
      return const SmartParkingScreen(tab: 2);
    }
    if (route == reportFullSlotRoute) {
      return const SmartParkingScreen(tab: 3,);
    }
    //face recognition
    if (route == faceRecognitionRoute) {
      return const FaceRecognitionScreen(tab: 0);
    }
    if (route == controllRoute) {
      return const FaceRecognitionScreen(tab: 1);
    }
    if (route == eventRoute) {
      return const FaceRecognitionScreen(tab: 2);
    }
    if (route == userRoute) {
      return const FaceRecognitionScreen(tab: 3);
    }
    if (route == deviceRoute) {
      return const FaceRecognitionScreen(tab: 4);
    }
    if (route == doorRoute) {
      return const FaceRecognitionScreen(tab: 5);
    }
    //healthy
    if (route == healthyCheckRoute) {
      return const HealthyCheckScreen(tab: 0,);
    }
    if(route == healthyCheckDevicesRoute){
      return const HealthyCheckScreen(tab: 1,);
    }
    if(route == healthyCheckHistoryRoute){
      return const HealthyCheckScreen(tab: 2,);
    }
    //other
    if (route == occupancyMonitorRoute) {
      return const OccupancyMonitorScreen();
    }
    if (route == riskManagementRoute) {
      return const RiskManagementScreen();
    }
    if (route == buildingManagementRoute) {
      return const BuildingManagementScreen();
    }

    return PageNotFoundScreen(route);
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _routePath = configuration.name!;
  }

  void navigateTo(String name) {
    _routePath = name;
    notifyListeners();
  }
}
