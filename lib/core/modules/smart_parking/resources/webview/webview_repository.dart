import 'package:web_iot/core/modules/smart_parking/resources/webview/webview_provider.dart';
import 'package:web_iot/core/rest/models/rest_api_response.dart';

class WebViewRepository{
  final _provider = WebViewApiProvider();
   Future<ApiResponse<T?>> fetchToken<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) =>
      _provider.fetchToken<T>(params: params);
}