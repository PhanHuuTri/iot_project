import 'dart:async';
import '../../../../constants/api_constants.dart';
import '../../../../helpers/api_helper.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../../../rest/rest_api_handler_data.dart';

class EmptySlotApiProvider {
  Future<ApiResponse<T?>> fetchAllCarAndBike<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.parkingSlotInfo;
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
  Future<ApiResponse<T?>> fetchAllMoto<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.emptySlot +
        ApiConstants.moto;
    // if (params.isNotEmpty) {
    //   var queries = <String>[];
    //   params.forEach((key, value) => queries.add('$key=$value'));
    //   path += '?' + queries.join('&');
    // }
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T?>> fetchAllCar<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.emptySlot +
        ApiConstants.car;
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
   Future<ApiResponse<T?>> fetchslotCar<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.parkingSlotInfo +
        ApiConstants.meta;
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
}
