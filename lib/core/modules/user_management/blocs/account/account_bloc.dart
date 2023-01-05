import 'package:rxdart/rxdart.dart';
import 'package:web_iot/core/rest/api_helpers/api_exception.dart';
import 'package:web_iot/core/rest/models/rest_api_response.dart';
import '../../models/account_model.dart';
import '../../resources/account/account_repository.dart';
import '../../../../base/blocs/block_state.dart';

class AccountBloc {
  final _repository = AccountRepository();
  final _allDataFetcher = BehaviorSubject<ApiResponse<AccountListModel>>();
  final _allDataState = BehaviorSubject<BlocState>();

  Stream<ApiResponse<AccountListModel>> get allData => _allDataFetcher.stream;
  Stream<BlocState> get allDataState => _allDataState.stream;
  bool _isFetching = false;

  fetchAllData({required Map<String, dynamic> params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository
          .fetchAllData<AccountListModel, EditAccountModel>(params: params);
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

  Future<AccountModel> fetchDataById(String id) async {
    try {
      // Await response from server.
      final data = await _repository
          .fetchDataById<AccountModel, EditAccountModel>(id: id);
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

  Future<AccountModel> deleteObject({required String id}) async {
    try {
      // Await response from server.
      final data = await _repository
          .deleteObject<AccountModel, EditAccountModel>(id: id);
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

  Future<AccountModel> editProfile({
    required EditAccountModel editModel,
  }) async {
    try {
      // Await response from server.
      final data =
          await _repository.editProfile<AccountModel, EditAccountModel>(
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

  Future<AccountModel> createObject({
    required EditAccountModel editModel,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.createObject<AccountModel, EditAccountModel>(
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

  Future<AccountModel> editObject({
    required EditAccountModel editModel,
    required String id,
  }) async {
    try {
      // Await response from server.
      final data = await _repository.editObject<AccountModel, EditAccountModel>(
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

  Future<AccountModel> getProfile() async {
    try {
      // Await response from server.
      final data =
          await _repository.getProfile<AccountModel, EditAccountModel>();
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

  Future<AccountModel> userChangePassword(
      {required Map<String, dynamic> params}) async {
    try {
      // Await response from server.
      final data =
          await _repository.userChangePassword<AccountModel, EditAccountModel>(
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

  dispose() {
    _allDataFetcher.close();
    _allDataState.close();
  }
}
