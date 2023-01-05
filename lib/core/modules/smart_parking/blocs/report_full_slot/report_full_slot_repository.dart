import '../../../../rest/models/rest_api_response.dart';
import 'report_full_slot_api_provider.dart';

class ReportFullSlotRepository {
  final _provider = ReportFullSlotApiProvider();

  Future<ApiResponse<T?>> reportFullSlotCar<T extends BaseModel>(
          {Map<String, dynamic>? params}) =>
      _provider.reportFullSlotCar<T>(params: params);

  Future<ApiResponse<T?>> reportFullSlotMoto<T extends BaseModel>(
          {Map<String, dynamic>? params}) =>
      _provider.reportFullSlotMoto<T>(params: params);

  Future<dynamic> isWarningFullSlotCar() => _provider.isWarningFullSlotCar();

  Future<dynamic> isWarningFullSlotMoto() => _provider.isWarningFullSlotMoto();
}