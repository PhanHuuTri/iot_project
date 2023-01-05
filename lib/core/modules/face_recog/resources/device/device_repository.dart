import 'dart:async';
import '../../../../rest/models/rest_api_response.dart';
import 'device_api_provider.dart';

class DeviceRepository {
  final _provider = DeviceApiProvider();

  Future<ApiResponse<T?>> fetchAllData<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchAllDevices<T>(params: params);

  Future<ApiResponse<T?>> exportObject<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.exportDevice<T>(params: params);
}
