import 'dart:async';
import 'package:web_iot/core/rest/models/rest_api_response.dart';
import 'healthy_api_provider.dart';


class HealthyRepository{
  final _provider = HealthyApiProvider();

  Future<ApiResponse<T>>
    createObject<T extends BaseModel, K extends EditBaseModel>({
      required K editModel,
    })=> 
      _provider.createObject<T,K>(editModel: editModel);

  Future<ApiResponse<T>>
    deleteObject<T extends BaseModel, K extends EditBaseModel>({
      required String id,
    })=>
        _provider.deleteHeathyl<T>(id: id);
  
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
          _provider.editHealthy<T, K>(
            editModel: editModel,
            id: id,
          );

  Future<ApiResponse<T>>
      fetchAllData<T extends BaseModel, K extends EditBaseModel>({
    required Map<String, dynamic> params,
  }) => _provider.fetchAllHealthyls<T>(params: params);

  
  Future<ApiResponse<T>>
      fetchDeviceData<T extends BaseModel, K extends EditBaseModel>({
    required Map<String, dynamic> params,
  }) => _provider.fetchDeviceHealthyls<T>(params: params);


  Future<ApiResponse<T>>
      fetchHistoryData<T extends BaseModel, K extends EditBaseModel>({
    required Map<String, dynamic> params,
  }) => _provider.fetchHistoryHealthyls<T>(params: params);
   Future<ApiResponse<T>>
      fetchDataByHistoryId<T extends BaseModel, K extends EditBaseModel>({
    required String id,
  }) =>
          _provider.fetchHealthyByHistoryId<T>(
            id: id,
          );
     Future<ApiResponse<T>>
       fetchDeviceId<T extends BaseModel>({
    required String id,
  }) =>
          _provider. fetchDeviceId<T>(
            id: id,
          );     

  Future<ApiResponse<T>>
      fetchDataById<T extends BaseModel, K extends EditBaseModel>({
    required String id,
  }) =>
          _provider.fetchHealthyById<T>(
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