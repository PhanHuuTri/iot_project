import 'dart:async';
import 'package:web_iot/core/logger/logger.dart';

import '../../../../constants/api_constants.dart';
import '../../../../helpers/api_helper.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../../../rest/rest_api_handler_data.dart';

class ReportFullSlotApiProvider {
  Future<ApiResponse<T?>> reportFullSlotCar<T extends BaseModel>(
      {Map<String, dynamic>? params}) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.reportFullSlot +
        ApiConstants.car;
    if (params != null && params.isNotEmpty) {
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

  Future<ApiResponse<T?>> reportFullSlotMoto<T extends BaseModel>(
      {Map<String, dynamic>? params}) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.reportFullSlot +
        ApiConstants.moto;
    if (params != null && params.isNotEmpty) {
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

  Future<dynamic> isWarningFullSlotCar() async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.reportFullSlot +
        ApiConstants.isWarning +
        ApiConstants.car;

    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getBool(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<dynamic> isWarningFullSlotMoto<T extends BaseModel>() async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.reportFullSlot +
        ApiConstants.isWarning +
        ApiConstants.moto;

    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getBool(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
}