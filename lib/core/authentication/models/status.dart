import 'package:web_iot/core/rest/models/rest_api_response.dart';

class Status extends BaseModel {
  String status = '';

  Status.fromJson(Map<String, dynamic>? json) {
    status = json?['status'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    return data;
  }
}
