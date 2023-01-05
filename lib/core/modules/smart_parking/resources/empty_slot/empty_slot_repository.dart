import 'dart:async';
import '../../../../rest/models/rest_api_response.dart';
import 'empty_slot_api_provider.dart';

class EmptySlotRepository {
  final _provider = EmptySlotApiProvider();
  Future<ApiResponse<T?>> fetchAllMotoAndBike<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchAllCarAndBike<T>(params: params);

  Future<ApiResponse<T?>> fetchAllMoto<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchAllMoto<T>(params: params);

  Future<ApiResponse<T?>> fetchAllCar<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchAllCar<T>(params: params);
  
  Future<ApiResponse<T?>> fetchslotCar<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchslotCar<T>(params: params);
}
