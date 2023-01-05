import 'package:rxdart/rxdart.dart';
import '../../../../base/blocs/block_state.dart';
import '../../../../rest/api_helpers/api_exception.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../models/door_model.dart';
import '../../resources/door/door_repository.dart';

class DoorBloc {
  final _repository = DoorRepository();
  final BehaviorSubject<ApiResponse<DoorListModel?>> _allDataFetcher =
      BehaviorSubject<ApiResponse<DoorListModel?>>();
  final BehaviorSubject<ApiResponse<ListDoorControlModel?>>
      _allUserDoorFetcher =
      BehaviorSubject<ApiResponse<ListDoorControlModel?>>();
  final BehaviorSubject<ApiResponse<DoorStatusModel?>> _doorStatusFetcher =
      BehaviorSubject<ApiResponse<DoorStatusModel?>>();
  final _allDataState = BehaviorSubject<BlocState>();

  Stream<ApiResponse<DoorListModel?>> get allData => _allDataFetcher.stream;
  Stream<ApiResponse<ListDoorControlModel?>> get userAllDoor =>
      _allUserDoorFetcher.stream;
  Stream<ApiResponse<DoorStatusModel?>> get doorStatus =>
      _doorStatusFetcher.stream;
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
          await _repository.fetchAllData<DoorListModel>(params: params!);
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

  Future<ListDeviceResponseModel> openDoor({required String id}) async {
    try {
      // Await response from server.
      final data = await _repository.openDoor<ListDeviceResponseModel>(id: id);
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

  Future<ListDeviceResponseModel> releaseDoor({required String id}) async {
    try {
      // Await response from server.
      final data = await _repository.releaseDoor<ListDeviceResponseModel>(id: id);
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

  Future<ListDeviceResponseModel> lockDoor({required String id}) async {
    try {
      // Await response from server.
      final data = await _repository.lockDoor<ListDeviceResponseModel>(id: id);
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

  Future<ListDeviceResponseModel> unlockDoor({required String id}) async {
    try {
      // Await response from server.
      final data =
          await _repository.unlockDoor<ListDeviceResponseModel>(id: id);
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

  fetchAllUserDoor({required Map<String, dynamic> params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository.fetchAllUserDoor<ListDoorControlModel>(
          params: params);
      if (_allUserDoorFetcher.isClosed) return;
      if (data.error != null) {
        // Error exist
        _allUserDoorFetcher.sink.addError(data.error!);
      } else {
        // Adding response data.
        _allUserDoorFetcher.sink.add(data);
      }
    } on AppException catch (e) {
      _allUserDoorFetcher.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }

  fetchDoorStatusById({required String id}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.fetchDoorStatusById<DoorStatusModel>(id: id);
      if (_doorStatusFetcher.isClosed) return;
      if (data.error != null) {
        // Error exist
        _doorStatusFetcher.sink.addError(data.error!);
      } else {
        // Adding response data.
        _doorStatusFetcher.sink.add(data);
      }
    } on AppException catch (e) {
      _doorStatusFetcher.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }

  Future<DoorListModel> exportObject({
    required Map<String, dynamic> params,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.exportObject<DoorListModel>(
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
    _allUserDoorFetcher.close();
    _doorStatusFetcher.close();
    _allDataState.close();
  }
}
