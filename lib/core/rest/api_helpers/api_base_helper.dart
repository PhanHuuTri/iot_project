import 'dart:convert';
import 'dart:io';
import 'package:web_iot/core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/main.dart';
import 'package:http/http.dart' as http;

class ApiBaseHelper {
  Future<ApiResponse<T>> get<T extends BaseModel>({
    required String path,
    Map<String, String>? headers,
  }) async {
    ApiResponse<T> responseJson;
    try {
      final response = await http.get(Uri.parse(path), headers: headers);
      responseJson = _returnResponse<T>(response);
    } on SocketException {
      return ApiResponse(
        null,
        ApiError.fromJson(
          {'error_code': -999, 'error_message': 'No Internet Connection'},
        ),
      );
    }
    return responseJson;
  }

  Future<ApiResponse<T>> post<T extends BaseModel>({
    required String path,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    ApiResponse<T> responseJson;
    try {
      final response = await http.post(
        Uri.parse(path),
        body: body,
        headers: headers,
      );
      responseJson = _returnResponse<T>(response);
    } on SocketException {
      return ApiResponse(
        null,
        ApiError.fromJson(
          {'error_code': -999, 'error_message': 'No Internet Connection'},
        ),
      );
    }
    return responseJson;
  }

  Future<ApiResponse<T>> put<T extends BaseModel>({
    required String path,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    ApiResponse<T> responseJson;
    try {
      final response =
          await http.put(Uri.parse(path), body: body, headers: headers);
      responseJson = _returnResponse<T>(response);
    } on SocketException {
      return ApiResponse(
        null,
        ApiError.fromJson(
          {'error_code': -999, 'error_message': 'No Internet Connection'},
        ),
      );
    }
    return responseJson;
  }
   Future<dynamic> getBool({
    required String path,
    dynamic headers,
  }) async {
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(path), headers: headers);
      responseJson = _returnLogoutResponse(response);
    } on SocketException catch (ex) {
      // ignore: avoid_print
      print(ex);
      return ApiResponse(
        null,
        ApiError.fromJson(
          {'error_code': -999, 'error_message': 'No Internet Connection'},
        ),
      );
    }
    return responseJson;
  }

  Future<ApiResponse<List<T>>> putList<T extends BaseModel>({
    required String path,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    ApiResponse<List<T>> responseJson;
    try {
      final response =
          await http.put(Uri.parse(path), body: body, headers: headers);
      responseJson = _returnListResponse<T>(response);
    } on SocketException {
      return ApiResponse(
        null,
        ApiError.fromJson(
          {'error_code': -999, 'error_message': 'No Internet Connection'},
        ),
      );
    }
    return responseJson;
  }

  Future<ApiResponse<T>> delete<T extends BaseModel>({
    required String path,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    ApiResponse<T> apiResponse;
    try {
      final uri = Uri.parse(path);
      final request = http.Request("DELETE", uri);
      request.headers.addAll(headers ?? {});
      request.body = body;
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      apiResponse = _returnDeleteResponse<T>(response.statusCode, responseBody);
    } on SocketException {
      return ApiResponse(
        null,
        ApiError.fromJson(
          {'error_code': -999, 'error_message': 'No Internet Connection'},
        ),
      );
    }
    return apiResponse;
  }

  Future<bool> updateFcmToken({
    required String path,
    dynamic body,
    Map<String, String>? headers,
  }) async {
    // ignore: prefer_typing_uninitialized_variables
    var responseJson;
    try {
      // logDebug('body: $body');
      final response = await http.post(
        Uri.parse(path),
        body: body,
        headers: headers,
      );
      // logDebug(response.body.toString());
      if (response.statusCode == 200) {
        responseJson = true;
      } else {
        responseJson = false;
      }
    } on SocketException {
      return false;
    }
    return responseJson;
  }

  Future<dynamic> login({
    required String path,
    dynamic body,
    dynamic headers,
  }) async {
    dynamic token;
    try {
      final response =
          await http.post(Uri.parse(path), body: body, headers: headers);
      token = _returnLoginResponse(response);
    } on SocketException catch (ex) {
      // ignore: avoid_print
      print(ex);
      return ApiResponse(
        null,
        ApiError.fromJson(
          {'error_code': -999, 'error_message': 'No Internet Connection'},
        ),
      );
    }
    return token;
  }
  

  Future<dynamic> logout({
    required String path,
    dynamic body,
    dynamic headers,
  }) async {
    dynamic responseJson;
    try {
      final response =
          await http.post(Uri.parse(path), body: body, headers: headers);
      responseJson = _returnLogoutResponse(response);
    } on SocketException catch (ex) {
      // ignore: avoid_print
      print(ex);
      return ApiResponse(
        null,
        ApiError.fromJson(
          {'error_code': -999, 'error_message': 'No Internet Connection'},
        ),
      );
    }
    return responseJson;
  }

  Future<ApiResponse<List<T>>> getList<T extends BaseModel>({
    required String path,
    Map<String, String>? headers,
  }) async {
    ApiResponse<List<T>> responseJson;
    try {
      final response = await http.get(Uri.parse(path), headers: headers);
      responseJson = _returnListResponse<T>(response);
    } on SocketException {
      return ApiResponse(
        null,
        ApiError.fromJson(
          {'error_code': -999, 'error_message': 'No Internet Connection'},
        ),
      );
    }
    return responseJson;
  }

  ApiResponse<T> _returnResponse<T extends BaseModel>(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseJson = json.decode(response.body.toString());
      if (responseJson is Map<String, dynamic>) {
        return ApiResponse(BaseModel.fromJson<T>(responseJson), null);
      }
      if (responseJson is List<dynamic>) {
        return ApiResponse(BaseModel.listDynamic<T>(responseJson), null);
      }
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      var parsedJson = json.decode(response.body.toString());
      ApiError _error;
      if (parsedJson is String) {
        _error = ApiError.fromJson(
          {'error_code': response.statusCode, 'error_message': parsedJson},
        );
      } else if (parsedJson is Map<String, dynamic>) {
        _error = ApiError.fromJson(parsedJson);
      } else {
        _error = ApiError.fromJson(
          {
            'error_code': response.statusCode,
            'error_message': parsedJson.toString(),
          },
        );
      }
      if (_error.errorMessage == 'token expired') {
        // Unauthenticated
        AuthenticationBlocController().authenticationBloc.add(TokenExpired());
      }
      return ApiResponse(null, ApiError.fromJson(parsedJson));
    }
    return ApiResponse(
      null,
      ApiError.fromJson(
        {
          'error_code': response.statusCode,
          'error_message': 'Error occured while Communication with Server'
        },
      ),
    );
  }

  ApiResponse<T> _returnDeleteResponse<T extends BaseModel>(
      int statusCode, String body) {
    if (statusCode == 200) {
      var responseJson = json.decode(body);
      return ApiResponse(BaseModel.fromJson<T>(responseJson), null);
    } else if (statusCode >= 400 && statusCode < 500) {
      var parsedJson = json.decode(body.toString());
      ApiError _error;
      if (parsedJson is String) {
        _error = ApiError.fromJson(
          {'error_code': statusCode, 'error_message': parsedJson},
        );
      } else if (parsedJson is Map<String, dynamic>) {
        _error = ApiError.fromJson(parsedJson);
      } else {
        _error = ApiError.fromJson(
          {
            'error_code': statusCode,
            'error_message': parsedJson.toString(),
          },
        );
      }
      if (_error.errorMessage == 'token expired') {
        // Unauthenticated
        AuthenticationBlocController().authenticationBloc.add(TokenExpired());
      }
      return ApiResponse(null, ApiError.fromJson(parsedJson));
    }
    return ApiResponse(
      null,
      ApiError.fromJson(
        {
          'error_code': statusCode,
          'error_message': 'Error occured while Communication with Server'
        },
      ),
    );
  }

  _returnLoginResponse(http.Response response) {
    if (response.statusCode == 200) {
      var token = response.headers['x-auth-token'];
      var map = json.decode(response.body.toString());
      var id = map['_id'] ?? '';
      return {'token': token, 'id': id};
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      return json.decode(response.body.toString());
    }
    return ApiResponse(
      null,
      ApiError.fromJson(
        {
          'error_code': response.statusCode,
          'error_message': 'Error occured while Communication with Server'
        },
      ),
    );
  }

  _returnLogoutResponse(http.Response response) {
    if (response.statusCode == 200) {
      var map = json.decode(response.body.toString());
      return map;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      return json.decode(response.body.toString());
    }
    return ApiResponse(
      null,
      ApiError.fromJson(
        {
          'error_code': response.statusCode,
          'error_message': 'Error occured while Communication with Server'
        },
      ),
    );
  }

  ApiResponse<List<T>> _returnListResponse<T extends BaseModel>(
      http.Response response) {
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body.toString());
      List<T> _list = [];
      if (responseJson is List<dynamic>) {
        for (var parsedJson in responseJson) {
          if (parsedJson is Map<String, dynamic>) {
            _list.add(BaseModel.fromJson<T>(parsedJson));
          }
        }
      }
      return ApiResponse(_list, null);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      var parsedJson = json.decode(response.body.toString());
      ApiError _error;
      if (parsedJson is String) {
        _error = ApiError.fromJson(
          {'error_code': response.statusCode, 'error_message': parsedJson},
        );
      } else if (parsedJson is Map<String, dynamic>) {
        _error = ApiError.fromJson(parsedJson);
      } else {
        _error = ApiError.fromJson(
          {
            'error_code': response.statusCode,
            'error_message': parsedJson.toString(),
          },
        );
      }
      if (_error.errorMessage == 'token expired') {
        // Unauthenticated
        AuthenticationBlocController().authenticationBloc.add(TokenExpired());
      }
      return ApiResponse(null, ApiError.fromJson(parsedJson));
    }
    return ApiResponse(
      null,
      ApiError.fromJson(
        {
          'error_code': response.statusCode,
          'error_message': 'Error occured while Communication with Server'
        },
      ),
    );
  }
}
