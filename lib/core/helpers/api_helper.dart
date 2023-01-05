import 'package:web_iot/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper { 
  static Future<String?> getUserToken() async {
    final SharedPreferences sharedPreferences = await prefs;
    if (sharedPreferences.getString('authtoken') != null) {
      return sharedPreferences.getString('authtoken');
    }
    return '';
  }

  static Map<String, String> headers(String? token) {
    Map<String, String> params = {
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      params['x-auth-token'] = token;
      if (currentFcmToken != null && currentFcmToken!.isNotEmpty) {
        params['fcmToken'] = currentFcmToken!;
      }
    }
    if (deviceOS.isNotEmpty) {
      params['deviceOS'] = deviceOS;
    }
    if (deviceId.isNotEmpty) {
      params['deviceId'] = deviceId;
    }
    return params;
  }

  static Map<String, String> downloadHeaders(String? token) {
    Map<String, String> params = {
      'Content-Type': 'application/octet-stream',
      'Accept': 'application/octet-stream',
    };
    if (token != null && token.isNotEmpty) {
      params['x-auth-token'] = token;
      if (currentFcmToken != null && currentFcmToken!.isNotEmpty) {
        params['fcmToken'] = currentFcmToken!;
      }
    }
    if (deviceOS.isNotEmpty) {
      params['deviceOS'] = deviceOS;
    }
    if (deviceId.isNotEmpty) {
      params['deviceId'] = deviceId;
    }
    return params;
  }
}
