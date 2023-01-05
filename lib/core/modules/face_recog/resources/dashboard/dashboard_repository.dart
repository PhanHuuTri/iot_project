import 'dart:async';
import '../../../../rest/models/rest_api_response.dart';
import 'dashboard_api_provider.dart';

class DashboardRepository {
  final _provider = DashboardApiProvider();

  Future<ApiResponse<T?>> fetchDashboardStatus<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchDashboardStatus<T>(params: params);

  Future<ApiResponse<T?>> fetchDashboardNotice<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchDashboardNotice<T>(params: params);

  Future<ApiResponse<T?>> fetchDashboardAlertStatistic<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchDashboardAlertStatistic<T>(params: params);

  Future<ApiResponse<T?>> fetchDashboardAlert<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchDashboardAlert<T>(params: params);
}
