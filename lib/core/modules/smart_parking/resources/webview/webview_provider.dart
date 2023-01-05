import 'package:web_iot/core/constants/api_constants.dart';
import 'package:web_iot/core/helpers/api_helper.dart';
import 'package:web_iot/core/rest/models/rest_api_response.dart';
import 'package:web_iot/core/rest/rest_api_handler_data.dart';

class WebViewApiProvider{
  Future<ApiResponse<T?>> fetchToken<T extends BaseModel>({
    required Map<String, dynamic> params,
  }) async {
    var path = ApiConstants.apiDomain +
        ApiConstants.apiVersion +
        ApiConstants.parkingSlotInfo+
        ApiConstants.authparking;
    final token = await ApiHelper.getUserToken();
    final response = await RestApiHandlerData.getData<T>(
      path: path,
      headers: ApiHelper.headers(token),
    );
    return response;
  }
}