import 'dart:async';
import '../../../../constants/api_constants.dart';
import '../../../../helpers/api_helper.dart';
import '../../../../logger/logger.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../../../rest/rest_api_handler_data.dart';

class DoorApiProvider {
  Future<ApiResponse<T?>> fetchAllDoors<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path =
        ApiConstants.apiDomain + ApiConstants.apiVersion + ApiConstants.door;
    if (params.isNotEmpty) {
      var queries = <String>[];
      params.forEach((key, value) => queries.add('$key=$value'));
      path += '?' + queries.join('&');
    }
    logDebug('path: $path');
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> openDoor<T extends BaseModel>({
    required String id,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.door +
        ApiConstants.open +
        '/$id';
    final token = await ApiHelper.getUserToken();
    logDebug('path: $path');
    final response = await RestApiHandlerData.postData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> releaseDoor<T extends BaseModel>({
    required String id,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.door +
        ApiConstants.release +
        '/$id';
    final token = await ApiHelper.getUserToken();
    logDebug('path: $path');
    final response = await RestApiHandlerData.postData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> lockDoor<T extends BaseModel>({
    required String id,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.door +
        ApiConstants.lock +
        '/$id';
    final token = await ApiHelper.getUserToken();
    logDebug('path: $path');
    final response = await RestApiHandlerData.postData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> unlockDoor<T extends BaseModel>({
    required String id,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.door +
        ApiConstants.unlock +
        '/$id';
    final token = await ApiHelper.getUserToken();
    logDebug('path: $path');
    final response = await RestApiHandlerData.postData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> fetchAllUserDoor<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.door 
        +ApiConstants.user;
    if (params.isNotEmpty) {
      var queries = <String>[];
      params.forEach((key, value) => queries.add('$key=$value'));
      path += '?' + queries.join('&');
    }
    logDebug(path);
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
      
    );
    return response;
  }

  Future<ApiResponse<T?>> fetchDoorStatusById<T extends BaseModel>({
    required String id,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.door +
        '/$id';
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> exportDoor<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path =
        ApiConstants.apiDomain + ApiConstants.apiVersion + ApiConstants.door;
    if (params.isNotEmpty) {
      var queries = <String>[];
      params.forEach((key, value) {
        if (value is List<dynamic>) {
          for (var element in value) {
            queries.add('$key=$element');
          }
        } else {
          queries.add('$key=$value');
        }
      });
      path += '?' + queries.join('&');
    }
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
}
