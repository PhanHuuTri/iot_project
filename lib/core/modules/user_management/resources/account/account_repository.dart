import 'dart:async';
import 'package:web_iot/core/rest/models/rest_api_response.dart';
import 'account_api_provider.dart';

class AccountRepository {
  final _provider = UserApiProvider();

  Future<ApiResponse<T>>
      createObject<T extends BaseModel, K extends EditBaseModel>({
    required K editModel,
  }) =>
          _provider.createObject<T, K>(
            editModel: editModel,
          );

  Future<ApiResponse<T>>
      deleteObject<T extends BaseModel, K extends EditBaseModel>({
    required String id,
  }) =>
          _provider.deleteAccount<T>(
            id: id,
          );

  Future<ApiResponse<T>>
      editProfile<T extends BaseModel, K extends EditBaseModel>({
    required K editModel,
  }) =>
          _provider.editProfile<T, K>(
            editModel: editModel,
          );

  Future<ApiResponse<T>>
      editObject<T extends BaseModel, K extends EditBaseModel>({
    required K editModel,
    required String id,
  }) =>
          _provider.editAccount<T, K>(
            editModel: editModel,
            id: id,
          );

  Future<ApiResponse<T>>
      fetchAllData<T extends BaseModel, K extends EditBaseModel>({
    required Map<String, dynamic> params,
  }) =>
          _provider.fetchAllAccounts<T>(params: params);

  Future<ApiResponse<T>>
      fetchDataById<T extends BaseModel, K extends EditBaseModel>({
    required String id,
  }) =>
          _provider.fetchAccountById<T>(
            id: id,
          );

  Future<ApiResponse<T>>
      getProfile<T extends BaseModel, K extends EditBaseModel>() =>
          _provider.getProfile<T>();

  Future<ApiResponse<T>>
      userChangePassword<T extends BaseModel, K extends EditBaseModel>(
              {required Map<String, dynamic> params}) =>
          _provider.userChangePassword<T>(
            params: params,
          );
}
