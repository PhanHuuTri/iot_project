import 'package:rxdart/rxdart.dart';
import '../../../../base/blocs/block_state.dart';
import '../../../../rest/api_helpers/api_exception.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../models/dashboard_model.dart';
import '../../resources/dashboard/dashboard_repository.dart';

class DashboardBloc {
  final _repository = DashboardRepository();
  final BehaviorSubject<ApiResponse<DashboardModel?>> _allDataFetcher =
      BehaviorSubject<ApiResponse<DashboardModel>>();
  final _allDataState = BehaviorSubject<BlocState>();

  Stream<ApiResponse<DashboardModel?>> get allData => _allDataFetcher.stream;
  Stream<BlocState> get allDataState => _allDataState.stream;
  bool _isFetching = false;
  

  fetchDashboardStatus({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.fetchDashboardStatus<DashboardModel>(params: params!);
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

  fetchDashboardAlertStatistic({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.fetchDashboardAlertStatistic<DashboardModel>(params: params!);
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

  fetchDashboardNotice({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.fetchDashboardNotice<DashboardModel>(params: params!);
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

  fetchDashboardAlert({Map<String, dynamic>? params}) async {
    print(params);
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.fetchDashboardAlert<DashboardModel>(params: params!);
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

  dispose() {
    _allDataFetcher.close();
    _allDataState.close();
  }
}
