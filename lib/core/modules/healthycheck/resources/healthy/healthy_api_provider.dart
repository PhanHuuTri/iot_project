import 'dart:async';
import 'package:web_iot/core/authentication/auth.dart';
import 'package:web_iot/core/constants/api_constants.dart';
import 'package:web_iot/core/helpers/api_helper.dart';
import 'package:web_iot/core/logger/logger.dart';
import 'dart:convert' as convert;
import 'package:web_iot/core/rest/models/rest_api_response.dart';
import 'package:web_iot/core/rest/rest_api_handler_data.dart';

class HealthyApiProvider{
  Future<ApiResponse<T>> fetchAllHealthyls<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async{
    var path = 
      ApiConstants.apiDomain + ApiConstants.apiVersion + ApiConstants.roomhealthy;
    if(params.isNotEmpty){
      var queries =<String>[];
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
  Future<ApiResponse<T>> fetchDeviceHealthyls<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async{
    var path = 
      ApiConstants.apiDomain + ApiConstants.apiVersion + ApiConstants.devicehealthy;
    if(params.isNotEmpty){
      var queries =<String>[];
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
  Future<ApiResponse<T>> fetchHistoryHealthyls<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async{
    var path = 
      ApiConstants.apiDomain + ApiConstants.apiVersion + ApiConstants.interactiveHistory;
    if(params.isNotEmpty){
      var queries =<String>[];
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
  Future<ApiResponse<T>> fetchHealthyByHistoryId<T extends BaseModel>({
    required String id,
  }) async{
    final path = ApiConstants.apiDomain + 
        ApiConstants.apiVersion+
        ApiConstants.interactiveHistory+ApiConstants.getOne+
        '/$id';
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
  Future<ApiResponse<T>> fetchDeviceId<T extends BaseModel>({
    required String id,
  }) async{
    final path = ApiConstants.apiDomain + 
        ApiConstants.apiVersion+
        ApiConstants.devicehealthy+
        '/$id';
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
  Future<ApiResponse<T>> fetchHealthyById<T extends BaseModel>({
    required String id,
  }) async{
    final path = ApiConstants.apiDomain + 
        ApiConstants.apiVersion+
        ApiConstants.roomhealthy+
        '/$id';
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
  Future<ApiResponse<T>>
    createObject<T extends BaseModel,K extends EditBaseModel>({
      required K editModel,
    }) async{
      final path =
        ApiConstants.apiDomain + ApiConstants.apiVersion + ApiConstants.roomhealthy;
      final body = convert.jsonEncode(EditBaseModel.toCreateJson(editModel));
      logDebug('path: $path\nbody: $body');
      final token = await ApiHelper.getUserToken();
      final response = await RestApiHandlerData.postData<T>(
        path: path,
        body: body,
        headers:  ApiHelper.headers(token),
      ); 
      return response;
    }
  Future<ApiResponse<T>> deleteHeathyl<T extends BaseModel>({
    required String id,
  }) async{
    final path = ApiConstants.apiDomain + 
        ApiConstants.apiVersion + 
        ApiConstants.roomhealthy + '/$id';
    final token =await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.deleteData<T>(
      path: path,
      body: '',
      headers: ApiHelper.headers(token),
    );
    return response;
  }
  Future<ApiResponse<T>>
      editProfile<T extends BaseModel, K extends EditBaseModel>({
    required K editModel,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.roomhealthy+
        ApiConstants.me;
    final body = convert.jsonEncode(EditBaseModel.toEditInfoJson(editModel));
    logDebug('path: $path\nbody: $body');
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.putData<T>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T>>
      editHealthy<T extends BaseModel, K extends EditBaseModel>({
    required K editModel,
    required String id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.roomhealthy +
        '/$id';
    final body = convert.jsonEncode(EditBaseModel.toEditJson(editModel));
    final token = await ApiHelper.getUserToken();
    logDebug('path: $path\nbody: $body');
    final response = await RestApiHandlerData.putData<T>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T>> getProfile<T extends BaseModel>() async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.roomhealthy +
        ApiConstants.me;
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T>> userChangePassword<T extends BaseModel>(
      {required Map<String, dynamic> params}) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.roomhealthy +
        ApiConstants.me +
        ApiConstants.changePassword;
    final token = await ApiHelper.getUserToken();
    final body = convert.jsonEncode(params);
    logDebug('path: $path\nbody: $body');
    final response = await RestApiHandlerData.putData<T>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
}
