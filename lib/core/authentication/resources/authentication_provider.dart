import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_iot/core/constants/api_constants.dart';
import 'package:web_iot/core/helpers/api_helper.dart';
import 'package:web_iot/core/rest/rest_api_handler_data.dart';
import 'package:web_iot/main.dart';

import '../models/status.dart';

class AuthenticationProvider {
  loginWithEmailAndPassword(dynamic body) async {
    final url = ApiConstants.apiDomain + ApiConstants.apiVersion + '/login';
    final response = await RestApiHandlerData.login(
      path: url,
      body: body,
      headers: ApiHelper.headers(null),
    );
    return response;
  }

  signUpWithEmailAndPassword(dynamic body) async {
    return null;
  }

  getUserData(String id) async {
    final url = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.account +
        '/$id';
    final SharedPreferences sharedPreferences = await prefs;
    var token = sharedPreferences.getString('authtoken') ?? '';
    logDebug('token: $token');
    final response = await RestApiHandlerData.getData(
      path: url,
      headers: {
        'x-auth-token': token,
      },
    );
    logDebug(response);
    return response;
  }

  signOut(dynamic body) async {
    final url = ApiConstants.apiDomain + ApiConstants.apiVersion + '/logout';
    final SharedPreferences sharedPreferences = await prefs;
    var token = sharedPreferences.getString('authtoken') ?? '';
    final response = await RestApiHandlerData.logout(
      path: url,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  resetPassword(dynamic body) async {
    final url = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.forgotPassword +
        '/reset-token';
    final response = await RestApiHandlerData.putData<Status>(
      path: url,
      body: body,
      headers: ApiHelper.headers(null),
    );
    return response;
  }

  forgotPassword(dynamic body) async {
    final url = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.forgotPassword;
    final response = await RestApiHandlerData.postData<Status>(
      path: url,
      body: body,
      headers: ApiHelper.headers(null),
    );
    return response;
  }

  removeFcmToken(dynamic body) async {
    final url = ApiConstants.apiDomain + ApiConstants.apiVersion + '/fcm_token';
    final response = await RestApiHandlerData.deleteData<Status>(
      path: url,
      body: body,
      headers: ApiHelper.headers(null),
    );
    return response;
  }
}
