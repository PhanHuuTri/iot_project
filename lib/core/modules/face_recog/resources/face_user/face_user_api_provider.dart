import 'dart:async';
import '../../../../constants/api_constants.dart';
import '../../../../helpers/api_helper.dart';
import '../../../../logger/logger.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../../../rest/rest_api_handler_data.dart';
import 'dart:convert' as convert;

class FaceUserApiProvider {
  Future<ApiResponse<T?>> fetchAllFaceUsers<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.faceUser;
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

  Future<ApiResponse<T?>> fetchAllRoles<T extends BaseModel>() async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.accessGroups;

    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T>>
      editFaceRole<T extends BaseModel, K extends EditBaseModel>({
    required K editModel,
    required String id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.faceUser +
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
}
