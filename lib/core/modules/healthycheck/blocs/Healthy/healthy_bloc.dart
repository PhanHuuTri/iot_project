import 'package:rxdart/rxdart.dart';
import 'package:web_iot/core/rest/api_helpers/api_exception.dart';
import 'package:web_iot/core/rest/models/rest_api_response.dart';
import '../../models/healthy_model.dart';
import '../../resources/healthy/heathyl_repository.dart';
import '../../../../base/blocs/block_state.dart';

class HealthyBloc {
  final _repository =HealthyRepository();
  final _allDataFetcher = BehaviorSubject<ApiResponse<HealthylListModel>>();
  final _allDataFetcherDevice = BehaviorSubject<ApiResponse<HealthylDeviceListModel>>();
  final _historyDataFetcher = BehaviorSubject<ApiResponse<HistorylListModel>>();
  final _allDataState = BehaviorSubject<BlocState>();

  Stream<ApiResponse<HealthylListModel>> get allData => _allDataFetcher.stream;
  Stream<BlocState> get allDataState => _allDataState.stream;
  bool _isFetching = false;
  Stream<ApiResponse<HealthylDeviceListModel>> get deviceHeathyl => _allDataFetcherDevice.stream;
  Stream<ApiResponse<HistorylListModel>> get historyData => _historyDataFetcher.stream;

  fetchAllData({required Map<String, dynamic> params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository
          .fetchAllData<HealthylListModel, EditHeathyModel>(params: params);
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
  fetchDeviceData({required Map<String, dynamic> params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository
          .fetchDeviceData<HealthylDeviceListModel, EditHealthylDeviceModel>(params: params);
      if (_allDataFetcherDevice.isClosed) return;
      if (data.error != null) {
        // Error exist
        _allDataFetcherDevice.sink.addError(data.error!);
      } else {
        // Adding response data.
        _allDataFetcherDevice.sink.add(data);
      }
    } on AppException catch (e) {
      _allDataFetcherDevice.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }

  Future<HealthylModel> fetchDataById(String id) async {
    try {
      // Await response from server.
      final data = await _repository
          .fetchDataById<HealthylModel, EditHeathyModel>(id: id);
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

  Future<HealthylModel> deleteObject({required String id}) async {
    try {
      // Await response from server.
      final data = await _repository
          .deleteObject<HealthylModel, EditHeathyModel>(id: id);
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

  Future<HealthylModel> editProfile({
    required EditHeathyModel editModel,
  }) async {
    try {
      // Await response from server.
      final data =
          await _repository.editProfile<HealthylModel, EditHeathyModel>(
        editModel: editModel,
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

  Future<HealthylModel> createObject({
    required EditHeathyModel editModel,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.createObject<HealthylModel, EditHeathyModel>(
        editModel: editModel,
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

  Future<HealthylModel> editObject({
    required EditHeathyModel editModel,
    required String id,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.editObject<HealthylModel, EditHeathyModel>(
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

  Future<HealthylModel> getProfile() async {
    try {
      // Await response from server.
      final data =
          await _repository.getProfile<HealthylModel, EditHeathyModel>();
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

  Future<HealthylModel> userChangePassword(
      {required Map<String, dynamic> params}) async {
    try {
      // Await response from server.
      final data =
          await _repository.userChangePassword<HealthylModel, EditHeathyModel>(
        params: params,
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
  fetchHistoryData({required Map<String, dynamic> params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository
          .fetchHistoryData<HistorylListModel, EditHistoryModel>(params: params);
      if (_historyDataFetcher.isClosed) return;
      if (data.error != null) {
        // Error exist
        _historyDataFetcher.sink.addError(data.error!);
      } else {
        // Adding response data.
        _historyDataFetcher.sink.add(data);
      }
    } on AppException catch (e) {
      _historyDataFetcher.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }
  Future<HistoryModel> fetchDataByHistoryId(String id) async {
    try {
      // Await response from server.
      final data = await _repository
          .fetchDataByHistoryId<HistoryModel, EditHistoryModel>(id: id);
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
  Future<DeviceModelID> fetchDataDeviceId(String id) async {
    try {
      // Await response from server.
      final data = await _repository
          . fetchDeviceId<DeviceModelID>(id: id);
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
  

  dispose() {
    _allDataFetcherDevice.close();
    _historyDataFetcher.close();
    _allDataState.close();
  }
}
