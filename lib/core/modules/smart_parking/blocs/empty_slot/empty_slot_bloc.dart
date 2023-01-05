import 'package:rxdart/rxdart.dart';
import '../../../../base/blocs/block_state.dart';
import '../../../../rest/api_helpers/api_exception.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../models/empty_slot_model.dart';
import '../../resources/empty_slot/empty_slot_repository.dart';

class EmptySlotBloc {
  final _repository = EmptySlotRepository();
  final BehaviorSubject<ApiResponse<ListMotoAndBikeEmptySlotModel?>> _allMotoAndBike =
      BehaviorSubject<ApiResponse<ListMotoAndBikeEmptySlotModel>>();
  final BehaviorSubject<ApiResponse<ListMotoEmptySlotModel?>> _allMotoFetcher =
      BehaviorSubject<ApiResponse<ListMotoEmptySlotModel>>();
  final BehaviorSubject<ApiResponse<ListCarEmptySlotModel?>> _allCarFetcher =
      BehaviorSubject<ApiResponse<ListCarEmptySlotModel>>();
      final BehaviorSubject<ApiResponse<CarEmptySlot?>> _slotCarFetcher =
      BehaviorSubject<ApiResponse<CarEmptySlot>>();
  final _allDataState = BehaviorSubject<BlocState>();

  Stream<ApiResponse<ListMotoEmptySlotModel?>> get allMoto => _allMotoFetcher.stream;
  Stream<ApiResponse<ListCarEmptySlotModel?>> get allCar => _allCarFetcher.stream;
  Stream<ApiResponse<CarEmptySlot?>> get allCarslot => _slotCarFetcher.stream;
  Stream<ApiResponse<ListMotoAndBikeEmptySlotModel?>> get allMotoAndBike => _allMotoAndBike.stream;
  Stream<BlocState> get allDataState => _allDataState.stream;
  bool _isFetching = false;

  fetchAllMotoAndBile({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.fetchAllMotoAndBike<ListMotoAndBikeEmptySlotModel>(params: params!);
      if (_allMotoAndBike.isClosed) return;
      if (data.error != null) {
        // Error exist
        _allMotoAndBike.sink.addError(data.error!);
      } else {
        // Adding response data.
        _allMotoAndBike.sink.add(data);
      }
    } on AppException catch (e) {
      _allMotoAndBike.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }
  fetchAllMoto({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.fetchAllMoto<ListMotoEmptySlotModel>(params: params!);
      if (_allMotoFetcher.isClosed) return;
      if (data.error != null) {
        // Error exist
        _allMotoFetcher.sink.addError(data.error!);
      } else {
        // Adding response data.
        _allMotoFetcher.sink.add(data);
      }
    } on AppException catch (e) {
      _allMotoFetcher.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }

  fetchAllCar({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository.fetchAllCar<ListCarEmptySlotModel>(params: params!);
      if (_allCarFetcher.isClosed) return;
      if (data.error != null) {
        // Error exist
        _allCarFetcher.sink.addError(data.error!);
      } else {
        // Adding response data.
        _allCarFetcher.sink.add(data);
      }
    } on AppException catch (e) {
      _allCarFetcher.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }
  fetchslotCar({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository.fetchslotCar<CarEmptySlot>(params: params!);
      if (_slotCarFetcher.isClosed) return;
      if (data.error != null) {
        // Error exist
        _slotCarFetcher.sink.addError(data.error!);
      } else {
        // Adding response data.
        _slotCarFetcher.sink.add(data);
      }
    } on AppException catch (e) {
      _slotCarFetcher.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }

  dispose() {
    _slotCarFetcher.close();
    _allMotoFetcher.close();
    _allCarFetcher.close();
    _allDataState.close();
  }
}
