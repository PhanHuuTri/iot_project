import 'package:web_iot/core/rest/models/rest_api_response.dart';

class WebViewModel extends BaseModel{
  final String _data;

  WebViewModel.fromJson(Map<String,dynamic> json)
  :_data=json['data'];

  String get data =>_data;
}