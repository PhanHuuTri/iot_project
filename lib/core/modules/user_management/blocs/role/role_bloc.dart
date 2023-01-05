import 'package:rxdart/rxdart.dart';
import '../../../../rest/api_helpers/api_exception.dart';
import '../../models/module_model.dart';
import '../../models/role_model.dart';
import '../../resources/role/role_repository.dart';
import '../../../../base/blocs/block_state.dart';

class RoleBloc {
  final _repository = RoleRepository();
  final _allDataFetcher = BehaviorSubject<RoleListModel>();
  final _allDataState = BehaviorSubject<BlocState>();
  final _allRole = BehaviorSubject<ListRoleModel>();
  final _allModuleFetcher = BehaviorSubject<ModuleListModel>();

  Stream<ListRoleModel> get allRole => _allRole.stream;
  Stream<RoleListModel> get allData => _allDataFetcher.stream;
  Stream<BlocState> get allDataState => _allDataState.stream;
  bool _isFetching = false;
  Stream<ModuleListModel> get allModule => _allModuleFetcher.stream;

  fetchAllData({required Map<String, dynamic> params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository.fetchAllData(params: params);
      if (_allDataFetcher.isClosed) return;
      if (data.error != null) {
        // Error exist
        _allDataFetcher.sink.addError(data.error!);
      } else {
        // Adding response data.
        _allDataFetcher.sink.add(data.model!);
      }
    } on AppException catch (e) {
      _allDataFetcher.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }

  Future<RoleModel> fetchDataById(String id) async {
    try {
      // Await response from server.
      final data = await _repository.fetchDataById(id: id);
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model!);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  Future<RoleModel> deleteObject({required String id}) async {
    try {
      // Await response from server.
      final data = await _repository.deleteObject(id: id);
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model!);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  Future<RoleModel> createObject({
    required EditRoleModel editModel,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.createObject(
        editModel: editModel,
      );
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model!);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  Future<RoleModel> editObject({
    required EditRoleModel editModel,
    required String id,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.editObject(
        editModel: editModel,
        id: id,
      );
      if (data.error != null) {
        // Error exist
        return Future.error(data.error!);
      } else {
        // Adding response data.
        return Future.value(data.model!);
      }
    } on AppException catch (e) {
      return Future.error(e);
    }
  }

  getAllRole({required Map<String, dynamic> params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository.getAllRole(params: params);
      if (_allRole.isClosed) return;
      if (data.error != null) {
        // Error exist
        _allRole.sink.addError(data.error!);
      } else {
        // Adding response data.
        _allRole.sink.add(data.model!);
      }
    } on AppException catch (e) {
      _allRole.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }

  getAllModule() async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.fetchModules<ModuleListModel>();
      if (_allModuleFetcher.isClosed) return;
      if (data.error != null) {
        // Error exist
        _allModuleFetcher.sink.addError(data.error!);
      } else {
        // Adding response data.
        _allModuleFetcher.sink.add(data.model!);
      }
    } on AppException catch (e) {
      _allModuleFetcher.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }

  dispose() {
    _allRole.close();
    _allDataFetcher.close();
    _allDataState.close();
    _allModuleFetcher.close();
  }
}
