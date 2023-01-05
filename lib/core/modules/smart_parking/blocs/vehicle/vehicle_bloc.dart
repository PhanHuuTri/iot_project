import 'package:rxdart/rxdart.dart';
import '../../../../base/blocs/block_state.dart';
import '../../../../rest/api_helpers/api_exception.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../models/vehicle_event_model.dart';
import '../../resources/vehicle/vehicle_repository.dart';

class VehicleBloc {
  final _repository = VehicleRepository();
  final BehaviorSubject<ApiResponse<VehicleEventListModel?>> _allDataFetcher =
      BehaviorSubject<ApiResponse<VehicleEventListModel>>();
  final _allDataState = BehaviorSubject<BlocState>();

  Stream<ApiResponse<VehicleEventListModel?>> get allData =>
      _allDataFetcher.stream;
  Stream<BlocState> get allDataState => _allDataState.stream;
  bool _isFetching = false;

  fetchAllData({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository
          .fetchAllData<VehicleEventListModel, EditVehicleModel>(
              params: params!);
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

  Future<VehicleEventModel> fetchDataById(String id) async {
    try {
      // Await response from server.
      final data = await _repository
          .fetchDataById<VehicleEventModel, EditVehicleModel>(id: id);
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }
  Future<NotiDetailModel> fetchDataByNotiId(String id) async {
    try {
      // Await response from server.
      final data = await _repository
          .fetchDataByNotiId<NotiDetailModel, EditNotiDetailModel>(id: id);
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  Future<VehicleEventModel> deleteObject({String? id}) async {
    try {
      // Await response from server.
      final data = await _repository
          .deleteObject<VehicleEventModel, EditVehicleModel>(id: id);
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  Future<VehicleEventModel> editObject({
    EditVehicleModel? editModel,
    String? id,
  }) async {
    try {
      // Await response from server.
      final data =
          await _repository.editObject<VehicleEventModel, EditVehicleModel>(
        editModel: editModel,
        id: id,
      );
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  Future<ListVehicleEventModel> exportSuccess({
    required Map<String, dynamic> params,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.exportSuccess<ListVehicleEventModel>(
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

  Future<ListVehicleEventModel> exportException({
    required Map<String, dynamic> params,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.exportException<ListVehicleEventModel>(
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

  fetchAllVehiclesException({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository
          .fetchAllVehiclesException<VehicleEventListModel, EditVehicleModel>(
              params: params!);
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
  Future<ListVehicleEventModel> exportInOutReport({
    required Map<String, dynamic> params,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.exportInOutReport<ListVehicleEventModel>(
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
