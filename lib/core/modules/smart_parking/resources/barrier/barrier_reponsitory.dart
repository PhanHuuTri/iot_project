import 'package:web_iot/core/modules/smart_parking/resources/barrier/barrier_provider.dart';
import 'package:web_iot/core/rest/models/rest_api_response.dart';

class BarrierRespository{
  final _provider = BarrierProvider();
  Future<ApiResponse<T?>>
    openBarrier<T extends BaseModel, K extends EditBaseModel>({
      required String id,
    })=>
        _provider.fetchOpenBarrier<T>(id: id);
}