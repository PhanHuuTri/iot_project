import 'package:rxdart/rxdart.dart';
import '../../../../base/blocs/block_state.dart';
import '../../../../rest/api_helpers/api_exception.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../models/report_full_slot.dart';
import 'report_full_slot_repository.dart';

class ReportFullSlotBloc {
  final _repository = ReportFullSlotRepository();
  final BehaviorSubject<ApiResponse<ReportFullSlotModel?>> _allDataFetcher =
      BehaviorSubject<ApiResponse<ReportFullSlotModel>>();
  final _allDataState = BehaviorSubject<BlocState>();

  Stream<ApiResponse<ReportFullSlotModel?>> get allData =>
      _allDataFetcher.stream;
  Stream<BlocState> get allDataState => _allDataState.stream;
  bool _isFetching = false;

  reportFullSlotCar({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository.reportFullSlotCar<ReportFullSlotModel>(
          params: params);
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

  reportFullSlotMoto({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository.reportFullSlotMoto<ReportFullSlotModel>(
          params: params);
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

  Future<bool> isWarningFullSlotCar() async {
    final response = await _repository.isWarningFullSlotCar();
    return response['warning'];
  }

  Future<bool> isWarningFullSlotMoto() async {
    final response = await _repository.isWarningFullSlotMoto();
    return response['warning'];
  }

  dispose() {
    _allDataFetcher.close();
    _allDataState.close();
  }
}