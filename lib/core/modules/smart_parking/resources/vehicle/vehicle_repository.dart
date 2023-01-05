import 'dart:async';
import '../../../../rest/models/rest_api_response.dart';
import 'vehicle_api_provider.dart';

class VehicleRepository {
  final _provider = VehicleApiProvider();

  Future<ApiResponse<T?>> exportInOutReport<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.exportInOutReport<T>(params: params);

  Future<ApiResponse<T?>>
      deleteObject<T extends BaseModel, K extends EditBaseModel>({
    String? id,
  }) =>
          _provider.deleteVehicle<T>(
            id: id,
          );

  Future<ApiResponse<T?>>
      editObject<T extends BaseModel, K extends EditBaseModel>({
    K? editModel,
    String? id,
  }) =>
          _provider.editVehicle<T, K>(
            editModel: editModel,
            id: id,
          );

  Future<ApiResponse<T?>>
      fetchAllData<T extends BaseModel, K extends EditBaseModel>({
    required Map<String, dynamic> params,
  }) =>
          _provider.fetchAllVehicles<T>(params: params);

  Future<ApiResponse<T?>>
      fetchDataById<T extends BaseModel, K extends EditBaseModel>({
    String? id,
  }) =>
          _provider.fetchVehicleById<T>(
            id: id,
          );
Future<ApiResponse<T?>>
      fetchDataByNotiId<T extends BaseModel, K extends EditBaseModel>({
    String? id,
  }) =>
          _provider.fetchVehicleByNotiId<T>(
            id: id,
          );
  Future<ApiResponse<T?>> exportSuccess<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.exportSuccess<T>(params: params);

  Future<ApiResponse<T?>> exportException<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.exportException<T>(params: params);

  Future<ApiResponse<T?>>
      fetchAllVehiclesException<T extends BaseModel, K extends EditBaseModel>({
    required Map<String, dynamic> params,
  }) =>
          _provider.fetchAllVehiclesException<T>(params: params);
}
