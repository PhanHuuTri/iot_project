import '../../models/role_model.dart';
import '../../../../rest/models/rest_api_response.dart';
import 'role_api_provider.dart';

class RoleRepository {
  final _provider = RoleApiProvider();

  Future<ApiResponse<RoleModel>> createObject({
    required EditRoleModel editModel,
  }) =>
      _provider.createRole(editModel: editModel);

  Future<ApiResponse<RoleModel>> deleteObject({
    required String id,
  }) =>
      _provider.deleteRole(id: id);

  Future<ApiResponse<RoleModel>> editObject({
    required EditRoleModel editModel,
    required String id,
  }) =>
      _provider.editRole(
        editModel: editModel,
        id: id,
      );

  Future<ApiResponse<RoleListModel>> fetchAllData({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchRoles(params: params);

  Future<ApiResponse<ListRoleModel>> getAllRole({
    required Map<String, dynamic> params,
  }) =>
      _provider.getAllRole(params: params);

  Future<ApiResponse<RoleModel>> fetchDataById({
    required String id,
  }) =>
      _provider.fetchRoleById(id: id);

  Future<ApiResponse<T>> fetchModules<T extends BaseModel>() =>
      _provider.fetchModules<T>();
}
