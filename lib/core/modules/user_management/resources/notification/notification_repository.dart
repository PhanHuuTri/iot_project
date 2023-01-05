import 'dart:async';
import '../../../../../core/rest/models/rest_api_response.dart';
import 'notification_api_provider.dart';

class NotificationRepository {
  final _provider = NotificationApiProvider();

  Future<ApiResponse<T>> fetchAllData<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchAllNoti<T>(params: params);

  Future<bool> updateFcmToken({
    required Map<String, dynamic> body,
  }) =>
      _provider.updateFcmToken(body: body);

  Future<ApiResponse<T?>> readNoti<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.readNoti<T>(params: params);

  Future<ApiResponse<T?>> notiUnreadTotal<T extends BaseModel>() =>
      _provider.notiUnreadTotal<T>();

  Future<ApiResponse<T?>> notiReadAll<T extends BaseModel>() =>
      _provider.notiReadAll<T>();
}
