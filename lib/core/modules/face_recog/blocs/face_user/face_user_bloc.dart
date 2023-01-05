import 'package:rxdart/rxdart.dart';
import '../../../../base/blocs/block_state.dart';
import '../../../../rest/api_helpers/api_exception.dart';
import '../../../../rest/models/rest_api_response.dart';
import '../../models/face_user_model.dart';
import '../../resources/face_user/face_user_repository.dart';

class FaceUserBloc {
  final _repository = FaceUserRepository();
  final BehaviorSubject<ApiResponse<FaceUserListModel?>> _allDataFetcher =
      BehaviorSubject<ApiResponse<FaceUserListModel?>>();
  final BehaviorSubject<ApiResponse<ListFaceFaceRoleModel?>> _allRoleFetcher =
      BehaviorSubject<ApiResponse<ListFaceFaceRoleModel?>>();
  final _allDataState = BehaviorSubject<BlocState>();

  Stream<ApiResponse<FaceUserListModel?>> get allData => _allDataFetcher.stream;
  Stream<ApiResponse<ListFaceFaceRoleModel?>> get allRole =>
      _allRoleFetcher.stream;
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
          await _repository.fetchAllData<FaceUserListModel>(params: params!);
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

  fetchAllRoles() async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data = await _repository.fetchAllRoles<ListFaceFaceRoleModel>();
      if (_allRoleFetcher.isClosed) return;
      if (data.error != null) {
        // Error exist
        _allRoleFetcher.sink.addError(data.error!);
      } else {
        // Adding response data.
        _allRoleFetcher.sink.add(data);
      }
    } on AppException catch (e) {
      _allRoleFetcher.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }

  Future<FaceUserModel> editObject({
    required EditFaceRoleModel editModel,
    required String id,
  }) async {
    try {
      // Await response from server.
      final data =
          await _repository.editObject<FaceUserModel, EditFaceRoleModel>(
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

  dispose() {
    _allDataFetcher.close();
    _allDataState.close();
    _allRoleFetcher.close();
  }
}
