import 'package:rxdart/rxdart.dart';
import '../../../../base/blocs/block_state.dart';
import '../../../../rest/api_helpers/api_exception.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../models/event_model.dart';
import '../../resources/event/event_repository.dart';

class EventBloc {
  final _repository = EventRepository();
  final BehaviorSubject<ApiResponse<EventListModel?>> _allDataFetcher =
      BehaviorSubject<ApiResponse<EventListModel>>();
  final _allDataState = BehaviorSubject<BlocState>();

  Stream<ApiResponse<EventListModel?>> get allData => _allDataFetcher.stream;
  Stream<BlocState> get allDataState => _allDataState.stream;
  bool _isFetching = false;

  fetchEventsData({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.fetchEventsData<EventListModel>(params: params!);
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

  fetchOperationData({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.fetchOperationData<EventListModel>(params: params!);
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

  Future<EventListModel> exportEvent({
    required Map<String, dynamic> params,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.exportEvent<EventListModel>(
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

  Future<EventListModel> exportEventOperation({
    required Map<String, dynamic> params,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.exportEventOperation<EventListModel>(
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
