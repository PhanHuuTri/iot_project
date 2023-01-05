import 'package:web_iot/core/configuration/api_config.dart';

class ApiConstants {
  static String get apiDomain {
    switch (ApiConfig.client) {
      case ApiClient.me:
        switch (ApiConfig.environment) {
          case ApiEnvironment.development:
            return 'https://adsystem-299304.et.r.appspot.com';
        }
      case ApiClient.local:
        return 'http://localhost:3000';
    }
  }

  static String apiVersion = '/api';
  static String account = '/users';
  static String role = '/roles';
  static String forgotPassword = '/forgot-password';
  static String all = '/all';
  static String me = '/me';
  static String changePassword = '/change-password';
  static String notification = '/notifications';
  static String fcmToken = '/fcm_token';
  static String vehicle = '/vehicleEvent';
  static String vihiclenoti ='/smartParkingNotiDetail';
  static String emptySlot = '/emptySlot';
  static String moto = '/moto';
  static String car = '/car';
  static String reportInOut = '/reportInOut';
  static String modules = '/modules';
  static String door = '/doors';
  static String faceEvent = '/events';
  static String faceDevice = '/FaceRecognition/devices';
  static String faceUser = '/FaceRecognition/users';
  static String faceDashboard = '/FaceRecognition/dashboard';
  static String status = '/status';
  static String alertStatistic = '/alert_statistic';
  static String notices = '/notices';
  static String alerts = '/alerts';
  static String open = '/open';
  static String lock = '/lock';
  static String unlock = '/unlock';
  static String user = '/user';
  static String accessGroups = '/access_groups';
  static String abnormalEvent = '/abnormalEvent';
  static String eventOperation = '/operation';
  static String read = '/read';
  static String release = '/release';
  static String unreadTotal = '/unread/total';
  static String roomhealthy = '/roomHealthyChecks';
  static String devicehealthy = '/cameraDevice';
  static String interactiveHistory ='/interactiveHistory';
  static String getOne ='/getOne';
  static String reportFullSlot = '/reportFullSlot';
  static String isWarning = '/isWarning';
  //call slot car
  static String parkingSlotInfo = '/ParkingSlotInfo';
  static String meta = '/meta';
  //webview
  static String authparking = '/auth-parking';
  //barrier
  static String barrierEvent = '/barrierEvent';
  static String openBarrier = '/openBarrier';
}
