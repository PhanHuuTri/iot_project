import 'package:rxdart/rxdart.dart';
import '../../../../base/blocs/block_state.dart';
import '../../../../rest/api_helpers/api_exception.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../models/device_model.dart';
import '../../resources/device/device_repository.dart';

class DeviceBloc {
  final _repository = DeviceRepository();
  final BehaviorSubject<ApiResponse<DeviceListModel?>> _allDataFetcher =
      BehaviorSubject<ApiResponse<DeviceListModel>>();
  final _allDataState = BehaviorSubject<BlocState>();

  Stream<ApiResponse<DeviceListModel?>> get allData => _allDataFetcher.stream;
  Stream<BlocState> get allDataState => _allDataState.stream;
  bool _isFetching = false;

  fetchAllData({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.fetchAllData<DeviceListModel>(params: params!);
      if (_allDataFetcher.isClosed) return;
      if (data.error != null) {
        // Error exist
        _allDataFetcher.sink.addError(data.error!);
      } else {
        // Adding response data.
        _allDataFetcher.sink.add(data);
      }
    } on AppException catch (e) {
      _allDataFetcher.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }

  Future<DeviceListModel> exportObject({
    required Map<String, dynamic> params,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.exportObject<DeviceListModel>(
        params: params,
      );
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      }
      return data.model!;
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  dispose() {
    _allDataFetcher.close();
    _allDataState.close();
  }
}
