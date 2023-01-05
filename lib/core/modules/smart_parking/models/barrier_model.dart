import 'package:web_iot/core/rest/models/rest_api_response.dart';

class BarrierModel extends BaseModel{
  final bool _isSuccess;
  final String _message;

  BarrierModel .fromJson(Map<String,dynamic> json)
  :_isSuccess=json['IsSuccess'],
  _message=json['Message'];

  bool get isSuccess=>_isSuccess;
  String get message =>_message;
}
class EditBarrierModel extends EditBaseModel{
  bool isSuccess=false;
  String message='';

  EditBarrierModel.fromModel(BarrierModel? barrier){
    isSuccess=barrier!.isSuccess;
    message=barrier.message;
  }
}