import 'package:flutter/material.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/routes/route_path.dart';

class AppRouteInforParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);
    final name = uri.path;

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
    //dashboard
    if (name == dashboardRoute) {
      return AppRoutePath.dashboard();
    }
    if (name == userProfileRoute) {
      return AppRoutePath.userInfo();
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
    if (name.startsWith(editRoleRoute)) {
      if (name.length > editRoleRoute.length) {
        final id = name.substring(editRoleRoute.length, name.length);
        if (id.isNotEmpty) return AppRoutePath.editRoles(id);
      }
      return AppRoutePath.roles();
    }

    //smart meeting
    // if (name == smartMeetingRoute) {
    //   return AppRoutePath.meeting();
    // }
    // if (name == myMeetingRoute) {
    //   return AppRoutePath.myMeeting();
    // }
    // if (name == addMeetingRoute) {
    //   return AppRoutePath.addMeeting();
    // }
    //smart parking
    if (name == smartParkingRoute) {
      return AppRoutePath.trafficList();
    }
    if (name == carParkStatus) {
      return AppRoutePath.carParkStatus();
    }
    if (name == parkingRoute) {
      return AppRoutePath.parkingList();
    }
    if (name == reportFullSlotRoute) {
      return AppRoutePath.reportFullSlot();
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
    //other
    if (name == healthyCheckRoute) {
      return AppRoutePath.healthyCheck();
    }
    if(name == healthyCheckDevicesRoute){
      return AppRoutePath.healthyCheckDevices();
    }
    if(name == healthyCheckHistoryRoute){
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

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    if (configuration.isUnknown) {
      return const RouteInformation(location: pageNotFoundRoute);
    }
    return RouteInformation(location: configuration.name);
  }
}
