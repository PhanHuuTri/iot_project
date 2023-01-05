import 'dart:async';
import 'dart:convert' as convert;
import '../../../../constants/api_constants.dart';
import '../../../../helpers/api_helper.dart';
import '../../../../logger/logger.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../../../rest/rest_api_handler_data.dart';

class VehicleApiProvider {
  Future<ApiResponse<T?>> fetchAllVehicles<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path =
        ApiConstants.apiDomain + ApiConstants.apiVersion + 
        ApiConstants.vehicle;
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
  Future<ApiResponse<T?>> exportInOutReport<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.vehicle +
        ApiConstants.all;
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

  Future<ApiResponse<T?>> fetchVehicleById<T extends BaseModel>({
    String? id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.vehicle +
        '/$id';
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
  Future<ApiResponse<T?>> fetchVehicleByNotiId<T extends BaseModel>({
    String? id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.vihiclenoti +
        '/$id';
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> deleteVehicle<T extends BaseModel>({
    String? id,
  }) async {
    final path =
        ApiConstants.apiDomain + ApiConstants.apiVersion + ApiConstants.vehicle;
    final body = convert.jsonEncode({'id': id});
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.deleteData<T>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>>
      editVehicle<T extends BaseModel, K extends EditBaseModel>({
    K? editModel,
    String? id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.vehicle +
        '/$id';
    final body = convert.jsonEncode(EditBaseModel.toEditJson(editModel!));
    final token = await ApiHelper.getUserToken();
    logDebug('path: $path\nbody: $body');
    final response = await RestApiHandlerData.putData<T>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> exportSuccess<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.vehicle +
        ApiConstants.all;
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

  Future<ApiResponse<T?>> exportException<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.abnormalEvent +
        ApiConstants.all;
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

  Future<ApiResponse<T?>> fetchAllVehiclesException<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.abnormalEvent;
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
}
