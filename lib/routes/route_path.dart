import 'package:web_iot/main.dart';
import 'package:web_iot/routes/route_names.dart';

class AppRoutePath {
  final String? name;
  final String routeId;
  final bool isUnknown;

  AppRoutePath.home()
      : name = sideBarRoute,
        routeId = '',
        isUnknown = false;
  //authentication
  AppRoutePath.authentication()
      : name = authenticationRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.conflict()
      : name = conflictLangRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.resetPassword()
      : name = resetPasswordRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.forgotPassword()
      : name = forgotPasswordRoute,
        routeId = '',
        isUnknown = false;
  //dashboard
  AppRoutePath.dashboard()
      : name = dashboardRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.userInfo()
      : name = userProfileRoute,
        routeId = '',
        isUnknown = false;
  //smart meeting
  // AppRoutePath.meeting()
  //     : name = smartMeetingRoute,
  //       routeId = '',
  //       isUnknown = false;

  // AppRoutePath.myMeeting()
  //     : name = myMeetingRoute,
  //       routeId = '',
  //       isUnknown = false;

  // AppRoutePath.addMeeting()
  //     : name = addMeetingRoute,
  //       routeId = '',
  //       isUnknown = false;
  //smart parking
  // AppRoutePath.parking()
  //     : name = smartParkingRoute,
  //       routeId = '',
  //       isUnknown = false;
  AppRoutePath.reportFullSlot()
      : name = reportFullSlotRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.carParkStatus()
      : name = carParkStatus,
        routeId = '',
        isUnknown = false;
  AppRoutePath.trafficList()
      : name = smartParkingRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.parkingList()
      : name = parkingRoute,
        routeId = '',
        isUnknown = false;
  //face recognition
  AppRoutePath.faceRecognition()
      : name = faceRecognitionRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.roomControll()
      : name = controllRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.eventList()
      : name = eventRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.userList()
      : name = userRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.deviceList()
      : name = deviceRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.doorList()
      : name = doorRoute,
        routeId = '',
        isUnknown = false;
  //user management
  AppRoutePath.userManagement()
      : name = userManagementRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.roles()
      : name = roleRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.createRoles()
      : name = createRoleRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.editRoles(String id)
      : name = editRoleRoute + id,
        routeId = '',
        isUnknown = false;
//other
  AppRoutePath.healthyCheck()
      : name = healthyCheckRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.healthyCheckDevices()
      : name = healthyCheckDevicesRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.healthyCheckHistory()
      : name = healthyCheckHistoryRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.occupancyMonitor()
      : name = occupancyMonitorRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.riskManagement()
      : name = riskManagementRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.buildingManagement()
      : name = buildingManagementRoute,
        routeId = '',
        isUnknown = false;
  AppRoutePath.unknown()
      : name = null,
        routeId = '',
        isUnknown = true;

  static AppRoutePath routeFrom(String? name) {
    if (name == sideBarRoute) {
      return AppRoutePath.home();
    }
    //authentication
    if (name == authenticationRoute) {
      return AppRoutePath.authentication();
    }
    if (name == conflictLangRoute) {
      return AppRoutePath.conflict();
    }
    if (name == resetPasswordRoute) {
      return AppRoutePath.resetPassword();
    }
    if (name == forgotPasswordRoute) {
      return AppRoutePath.forgotPassword();
    }
    // if (name == smartMeetingRoute) {
    //   return AppRoutePath.meeting();
    // }
    // if (name == myMeetingRoute) {
    //   return AppRoutePath.myMeeting();
    // }
    // if (name == addMeetingRoute) {
    //   return AppRoutePath.addMeeting();
    // }
    //dashboard
    if (name == dashboardRoute) {
      return AppRoutePath.dashboard();
    }
    if (name == userProfileRoute) {
      return AppRoutePath.userInfo();
    }
    //smart parking
    if (name == smartParkingRoute) {
      return AppRoutePath.trafficList();
    }
    if (name == parkingRoute) {
      return AppRoutePath.parkingList();
    }
    //face recognition
    if (name == faceRecognitionRoute) {
      return AppRoutePath.faceRecognition();
    }
    if (name == controllRoute) {
      return AppRoutePath.roomControll();
    }
    if (name == eventRoute) {
      return AppRoutePath.eventList();
    }
    if (name == userRoute) {
      return AppRoutePath.userList();
    }
    if (name == deviceRoute) {
      return AppRoutePath.deviceList();
    }
    if (name == doorRoute) {
      return AppRoutePath.doorList();
    }
    //user management
    if (name == userManagementRoute) {
      return AppRoutePath.userManagement();
    }
    if (name == roleRoute) {
      return AppRoutePath.roles();
    }
    if (name == createRoleRoute) {
      return AppRoutePath.createRoles();
    }
    if (name != null && name.startsWith(editRoleRoute)) {
      if (name.length > editRoleRoute.length) {
        final id = name.substring(editRoleRoute.length, name.length);
        if (id.isNotEmpty) return AppRoutePath.editRoles(id);
      }
      return AppRoutePath.roles();
    }
    //other
    if (name == healthyCheckRoute) {
      return AppRoutePath.healthyCheck();
    }
    if (name == healthyCheckDevicesRoute) {
      return AppRoutePath.healthyCheckDevices();
    }
    if (name == healthyCheckHistoryRoute) {
      return AppRoutePath.healthyCheckHistory();
    }
    if (name == occupancyMonitorRoute) {
      return AppRoutePath.occupancyMonitor();
    }
    if (name == riskManagementRoute) {
      return AppRoutePath.riskManagement();
    }
    if (name == buildingManagementRoute) {
      return AppRoutePath.buildingManagement();
    }
    return AppRoutePath.unknown();
  }
}
