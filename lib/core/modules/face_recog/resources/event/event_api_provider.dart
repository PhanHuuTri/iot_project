import 'dart:async';
import '../../../../constants/api_constants.dart';
import '../../../../helpers/api_helper.dart';
import '../../../../logger/logger.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../../../rest/rest_api_handler_data.dart';

class EventApiProvider {
  Future<ApiResponse<T?>> fetchEventsData<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.faceEvent;
    if (params.isNotEmpty) {
      var queries = <String>[];
      params.forEach((key, value) {
        if (value is List) {
          for (var element in value) {
            queries.add('$key=$element');
          }
        } else {
          queries.add('$key=$value');
        }
      });
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

  Future<ApiResponse<T?>> fetchOperationData<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.faceEvent +
        ApiConstants.eventOperation;
    if (params.isNotEmpty) {
      var queries = <String>[];
      params.forEach((key, value) {
        if (value is List) {
          for (var element in value) {
            queries.add('$key=$element');
          }
        } else {
          queries.add('$key=$value');
        }
      });
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

  Future<ApiResponse<T?>> exportEvent<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.faceEvent;
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

  Future<ApiResponse<T?>> exportEventOperation<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.faceEvent +
        ApiConstants.eventOperation;
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
