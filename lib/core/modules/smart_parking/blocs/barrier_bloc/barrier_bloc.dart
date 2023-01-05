import 'package:rxdart/rxdart.dart';
import 'package:web_iot/core/base/blocs/block_state.dart';
import 'package:web_iot/core/modules/smart_parking/models/barrier_model.dart';
import 'package:web_iot/core/modules/smart_parking/resources/barrier/barrier_reponsitory.dart';
import 'package:web_iot/core/rest/api_helpers/api_exception.dart';
import 'package:web_iot/core/rest/models/rest_api_response.dart';

class BarrierBloc{
  final _repository = BarrierRespository();
  final BehaviorSubject<ApiResponse<BarrierModel?>> _openBarrier =
      BehaviorSubject<ApiResponse<BarrierModel>>();
  final _allDataState = BehaviorSubject<BlocState>();

  Stream<ApiResponse<BarrierModel?>> get barrier => _openBarrier.stream;
  Stream<BlocState> get allDataState => _allDataState.stream;
  bool _isFetching = false;

   fetchOpenBarrier(String id) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.openBarrier<BarrierModel,EditBarrierModel>(id: id);
      if (_openBarrier.isClosed) return;
      if (data.error != null) {
        // Error exist
        _openBarrier.sink.addError(data.error!);
      } else {
        // Adding response data.
        _openBarrier.sink.add(data);
      }
    } on AppException catch (e) {
      _openBarrier.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }
   dispose() {
    _allDataState.close();
  }
}