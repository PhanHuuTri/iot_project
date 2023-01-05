import 'package:rxdart/rxdart.dart';
import 'package:web_iot/core/base/blocs/block_state.dart';
import 'package:web_iot/core/modules/smart_parking/models/webview_model.dart';
import 'package:web_iot/core/modules/smart_parking/resources/webview/webview_repository.dart';
import 'package:web_iot/core/rest/api_helpers/api_exception.dart';
import 'package:web_iot/core/rest/models/rest_api_response.dart';

class WebviewBloc{
  final _repository = WebViewRepository();
  final BehaviorSubject<ApiResponse<WebViewModel?>> _dataToken =
      BehaviorSubject<ApiResponse<WebViewModel>>();
  final _allDataState = BehaviorSubject<BlocState>();

  Stream<ApiResponse<WebViewModel?>> get token => _dataToken.stream;
  Stream<BlocState> get allDataState => _allDataState.stream;
  bool _isFetching = false;

  fetchDataToken({Map<String, dynamic>? params}) async {
    if (_isFetching) return;
    _isFetching = true;
    // Start fetching data.
    _allDataState.sink.add(BlocState.fetching);
    try {
      // Await response from server.
      final data =
          await _repository.fetchToken<WebViewModel>(params: params!);
      if (_dataToken .isClosed) return;
      if (data.error != null) {
        // Error exist
        _dataToken.sink.addError(data.error!);
      } else {
        // Adding response data.
        _dataToken.sink.add(data);
      }
    } on AppException catch (e) {
      _dataToken.sink.addError(e);
    }
    // Complete fetching.
    _allDataState.sink.add(BlocState.completed);
    _isFetching = false;
  }
   dispose() {
    _allDataState.close();
  }
}