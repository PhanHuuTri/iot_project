import 'dart:async';
import '../../../../rest/models/rest_api_response.dart';
import 'event_api_provider.dart';

class EventRepository {
  final _provider = EventApiProvider();

  Future<ApiResponse<T?>> fetchEventsData<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchEventsData<T>(params: params);

  Future<ApiResponse<T?>> fetchOperationData<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchOperationData<T>(params: params);

  Future<ApiResponse<T?>> exportEvent<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.exportEvent<T>(params: params);

  Future<ApiResponse<T?>> exportEventOperation<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.exportEventOperation<T>(params: params);
}
