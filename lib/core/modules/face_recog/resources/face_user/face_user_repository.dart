import 'dart:async';
import '../../../../rest/models/rest_api_response.dart';
import 'face_user_api_provider.dart';

class FaceUserRepository {
  final _provider = FaceUserApiProvider();

  Future<ApiResponse<T?>> fetchAllData<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchAllFaceUsers<T>(params: params);

  Future<ApiResponse<T?>> fetchAllRoles<T extends BaseModel>() =>
      _provider.fetchAllRoles<T>();

  Future<ApiResponse<T>>
      editObject<T extends BaseModel, K extends EditBaseModel>({
    required K editModel,
    required String id,
  }) =>
          _provider.editFaceRole<T, K>(
            editModel: editModel,
            id: id,
          );
}
