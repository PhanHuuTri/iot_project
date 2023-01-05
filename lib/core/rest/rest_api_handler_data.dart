import 'package:web_iot/core/rest/api_helpers/api_base_helper.dart';
import 'package:web_iot/core/rest/models/rest_api_response.dart';

class RestApiHandlerData {
  static final ApiBaseHelper _apiBaseHelper = ApiBaseHelper();
  static Future<ApiResponse<T>> getData<T extends BaseModel>({
    required String path,
    Map<String, String>? headers,
  }) async {
    final response = await _apiBaseHelper.get<T>(
      path: path,
      headers: headers,
      
    );
    return response;
  }

  static Future<ApiResponse<T>> postData<T extends BaseModel>({
    required String path,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    final response = await _apiBaseHelper.post<T>(
      path: path,
      body: body,
      headers: headers,
    );
    return response;
  }

  static Future<ApiResponse<T>> putData<T extends BaseModel>({
    required String path,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    final response = await _apiBaseHelper.put<T>(
      path: path,
      body: body,
      headers: headers,
    );
    return response;
  }

  static Future<ApiResponse<List<T>>> putListData<T extends BaseModel>({
    required String path,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    final response = await _apiBaseHelper.putList<T>(
      path: path,
      body: body,
      headers: headers,
    );
    return response;
  }


  static Future<ApiResponse<T>> deleteData<T extends BaseModel>({
    required String path,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    final response = await _apiBaseHelper.delete<T>(
      path: path,
      body: body,
      headers: headers,
    );
    return response;
  }
  static Future getBool({
    required String path,
    Map<String, String>? headers,
  }) async {
    final response = await _apiBaseHelper.getBool(
      path: path,
      headers: headers,
    );
    return response;
  }

  static Future<bool> updateFcmToken({
    required String path,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    final response = await _apiBaseHelper.updateFcmToken(
      path: path,
      body: body,
      headers: headers,
    );
    return response;
  }

  static login({
    required String path,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    final response = await _apiBaseHelper.login(
      path: path,
      body: body,
      headers: headers,
    );
    return response;
  }

  static Future logout({
    required String path,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    final response = await _apiBaseHelper.logout(
      path: path,
      body: body,
      headers: headers,
    );
    return response;
  }

  static Future<ApiResponse<List<T>>> getListData<T extends BaseModel>({
    required String path,
    Map<String, String>? headers,
  }) async {
    final response = await _apiBaseHelper.getList<T>(
      path: path,
      headers: headers,
    );
    return response;
  }
}
