import 'dart:async';
import 'package:web_iot/core/logger/logger.dart';
import '../../../../../core/helpers/api_helper.dart';
import '../../../../../core/rest/models/rest_api_response.dart';
import '../../../../../core/rest/rest_api_handler_data.dart';
import 'dart:convert' as convert;
import '../../../../constants/api_constants.dart';

class NotificationApiProvider {
  Future<ApiResponse<T>> fetchAllNoti<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.notification;
    if (params.isNotEmpty) {
      var queries = <String>[];
      params.forEach((key, value) => queries.add('$key=$value'));
      path += '?' + queries.join('&');
    }
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<bool> updateFcmToken({required Map<String, dynamic> body}) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.fcmToken;
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.updateFcmToken(
      path: path,
      headers: ApiHelper.headers(token),
      body: convert.jsonEncode(body),
    );
    return response;
  }

  Future<ApiResponse<T?>> readNoti<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.notification +
        ApiConstants.read;
    if (params.isNotEmpty) {
      var queries = <String>[];
      params.forEach((key, value) => queries.add('$key=$value'));
      path += '?' + queries.join('&');
    }
    final token = await ApiHelper.getUserToken();
    final body = convert.jsonEncode(params);
    final response = await RestApiHandlerData.putData<T>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> notiUnreadTotal<T extends BaseModel>() async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.notification +
        ApiConstants.unreadTotal;
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> notiReadAll<T extends BaseModel>() async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.notification +
        ApiConstants.read +
        ApiConstants.all;
    final token = await ApiHelper.getUserToken();
    logDebug(path);
    final response = await RestApiHandlerData.putData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
}
