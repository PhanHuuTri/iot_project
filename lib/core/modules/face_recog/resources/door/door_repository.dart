import 'dart:async';
import '../../../../rest/models/rest_api_response.dart';
import 'door_api_provider.dart';

class DoorRepository {
  final _provider = DoorApiProvider();

  Future<ApiResponse<T?>> fetchAllData<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchAllDoors<T>(params: params);

  Future<ApiResponse<T?>> openDoor<T extends BaseModel>({
    required String id,
  }) =>
      _provider.openDoor<T>(id: id);

  Future<ApiResponse<T?>> releaseDoor<T extends BaseModel>({
    required String id,
  }) =>
      _provider.releaseDoor<T>(id: id);

  Future<ApiResponse<T?>> lockDoor<T extends BaseModel>({
    required String id,
  }) =>
      _provider.lockDoor<T>(id: id);

  Future<ApiResponse<T?>> unlockDoor<T extends BaseModel>({
    required String id,
  }) =>
      _provider.unlockDoor<T>(id: id);

  Future<ApiResponse<T?>> fetchAllUserDoor<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchAllUserDoor<T>(params: params);

  Future<ApiResponse<T?>> fetchDoorStatusById<T extends BaseModel>({
    required String id,
  }) =>
      _provider.fetchDoorStatusById<T>(id: id);

  Future<ApiResponse<T?>> exportObject<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.exportDoor<T>(params: params);
}
