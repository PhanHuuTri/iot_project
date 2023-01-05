import 'dart:async';
import '../../../../rest/models/rest_api_response.dart';
import 'report_in_out_api_provider.dart';


class ReportInOutRepository {
  final _provider = ReportInOutApiProvider();
  Future<ApiResponse<T?>>
      fetchAllData<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
          _provider.fetchReportInOut<T>(params: params);
}
