import 'dart:async';
import 'dart:convert' as convert;
import '../../../../constants/api_constants.dart';
import '../../../../helpers/api_helper.dart';
import '../../models/role_model.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../../../rest/rest_api_handler_data.dart';

class RoleApiProvider {
  Future<ApiResponse<RoleListModel>> fetchRoles({
    required Map<String, dynamic> params,
  }) async {
    var path =
        ApiConstants.apiDomain + ApiConstants.apiVersion + ApiConstants.role;
    if (params.isNotEmpty) {
      var queries = <String>[];
      params.forEach((key, value) => queries.add('$key=$value'));
      path += '?' + queries.join('&');
    }
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<RoleListModel>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<T>> fetchModules<T extends BaseModel>() async {
    var path =
        ApiConstants.apiDomain + ApiConstants.apiVersion + ApiConstants.modules;
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<ListRoleModel>> getAllRole({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.role +
        ApiConstants.all;
    if (params.isNotEmpty) {
      var queries = <String>[];
      params.forEach((key, value) => queries.add('$key=$value'));
      path += '?' + queries.join('&');
    }
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<ListRoleModel>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<RoleModel>> fetchRoleById({
    required String id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.role +
        '/$id';
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<RoleModel>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<RoleModel>> deleteRole({
    required String id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.role +
        '/$id';
    const body = '';
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.deleteData<RoleModel>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<RoleModel>> createRole({
    required EditRoleModel editModel,
  }) async {
    final path =
        ApiConstants.apiDomain + ApiConstants.apiVersion + ApiConstants.role;
    final body = convert.jsonEncode(EditBaseModel.toCreateJson(editModel));
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.postData<RoleModel>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }

  Future<ApiResponse<RoleModel>> editRole({
    required EditRoleModel editModel,
    required String id,
  }) async {
    final path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.role +
        '/$id';
    final body = convert.jsonEncode(EditBaseModel.toEditJson(editModel));
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.putData<RoleModel>(
      path: path,
      body: body,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
}
