import 'package:universal_html/html.dart';
import 'package:web_iot/core/modules/user_management/models/account_model.dart';

import '../../../base/models/common_model.dart';
import '../../../rest/models/rest_api_response.dart';

class VehicleEventModel extends BaseModel {
  final String _eventId;
  final String _eventType;
  final String _cardName;
  final String _plateNumber;
  final String _dateTimeIn;
  final String _dateTimeOut;
  final String _moneys;
  final String _cardGroupId;
  final String _cardGroupName;
  final String _vehicleGroupId;
  final String _vehicleGroupName;
  final String _customerName;
  final String _customerID;
  final String _customerGroupID;
  final String _customerGroupName;

  VehicleEventModel.fromJson(Map<String, dynamic> json)
      : _eventId = json['EventID'] ?? '',
        _eventType = json['EventType'] ?? '',
        _cardName = json['CardName'] ?? '',
        _plateNumber = json['PlateNumber'] ?? '',
        _dateTimeIn = json['DateTimeIn'] ?? '',
        _dateTimeOut = json['DateTimeOut'] ?? '',
        _moneys = json['Moneys'] ?? '',
        _cardGroupId = json['CardGroupId'] ?? '',
        _cardGroupName = json['CardGroupName'] ?? '',
        _vehicleGroupId = json['VehicleGroupID'] ?? '',
        _vehicleGroupName = json['VehicleGroupName'] ?? '',
        _customerName = json['CustomerName'] ?? '',
        _customerID = json['CustomerID'] ?? '',
        _customerGroupID = json['CustomerGroupID'] ?? '',
        _customerGroupName = json['CustomerGroupName'] ?? '';

  Map<String, dynamic> toJson() => {
        'EventID': _eventId,
        'EventType': _eventType,
        'CardName': _cardName,
        'PlateNumber': _plateNumber,
        'DateTimeIn': _dateTimeIn,
        'DateTimeOut': _dateTimeOut,
        'Moneys': _moneys,
        'CardGroupId': _cardGroupId,
        'CardGroupName': _cardGroupName,
        'VehicleGroupID': _vehicleGroupId,
        'VehicleGroupName': _vehicleGroupName,
        'CustomerName': _customerName,
        'CustomerID': _customerID,
        'CustomerGroupID': _customerGroupID,
        'CustomerGroupName': _customerGroupName,
      };

  String get eventId => _eventId;
  String get eventType => _eventType;
  String get cardName => _cardName;
  String get plateNumber => _plateNumber;
  String get dateTimeIn => _dateTimeIn;
  String get dateTimeOut => _dateTimeOut;
  String get moneys => _moneys;
  String get cardGroupId => _cardGroupId;
  String get cardGroupName => _cardGroupName;
  String get vehicleGroupId => _vehicleGroupId;
  String get vehicleGroupName => _vehicleGroupName;
  String get customerName => _customerName;
  String get customerID => _customerID;
  String get customerGroupID => _customerGroupID;
  String get customerGroupName => _customerGroupName;
}

class EditVehicleModel extends EditBaseModel {
  String eventId = '';
  String cardName = '';
  String plateNumber = '';
  String dateTimeIn = '';
  String dateTimeOut = '';
  String moneys = '';
  String cardGroupId = '';
  String cardGroupName = '';
  String vehicleGroupId = '';
  String customerName = '';
  String customerGroupID = '';
  String customerGroupName = '';

  EditVehicleModel.fromModel(VehicleEventModel? vehicle) {
    eventId = vehicle?.eventId ?? '';
    cardName = vehicle?.cardName ?? '';
    plateNumber = vehicle?.plateNumber ?? '';
    dateTimeIn = vehicle?.dateTimeIn ?? '';
    dateTimeOut = vehicle?.dateTimeOut ?? '';
    moneys = vehicle?.moneys ?? '';
    cardGroupId = vehicle?.cardGroupId ?? '';
    cardGroupName = vehicle?.cardGroupName ?? '';
    vehicleGroupId = vehicle?.vehicleGroupId ?? '';
    customerName = vehicle?.customerName ?? '';
    customerGroupID = vehicle?.customerGroupID ?? '';
    customerGroupName = vehicle?.customerGroupName ?? '';
  }

  Map<String, dynamic> toEditJson() {
    Map<String, dynamic> params = {
      'EventID': eventId,
      'CardName': cardName,
      'PlateNumber': plateNumber,
      'DateTimeIn': dateTimeIn,
      'DateTimeOut': dateTimeOut,
      'Moneys': moneys,
      'CardGroupId': cardGroupId,
      'CardGroupName': cardGroupName,
      'VehicleGroupID': vehicleGroupId,
      'CustomerName': customerName,
      'CustomerGroupID': customerGroupID,
      'CustomerGroupName': customerGroupName,
    };

    return params;
  }
}

class VehicleEventListModel extends BaseModel {
  List<VehicleEventModel> _data = [];
  Paging _metaData = Paging.fromParkingJson({});

  VehicleEventListModel.fromJson(Map<String, dynamic> parsedJson) {
    List<VehicleEventModel> tmp = [];
    if (parsedJson['ReportInOut_data'] != null) {
      for (int i = 0; i < parsedJson['ReportInOut_data'].length; i++) {
        var result = BaseModel.fromJson<VehicleEventModel>(
            parsedJson['ReportInOut_data'][i]);
        tmp.add(result);
      }
      _data = tmp;
    }
    _metaData = Paging.fromParkingJson(parsedJson);
  }

  List<VehicleEventModel> get records => _data;
  Paging get meta => _metaData;
}

class ListVehicleEventModel extends BaseModel {
  List<VehicleEventModel> _data = [];

  ListVehicleEventModel.listDynamic(List<dynamic> list) {
    List<VehicleEventModel> tmp = [];
    for (int i = 0; i < list.length; i++) {
      var result = BaseModel.fromJson<VehicleEventModel>(list[i]);
      tmp.add(result);
    }
    _data = tmp;
  }

  List<VehicleEventModel> get records => _data;
}

class NotiDetailModel extends BaseModel {
  final String _id;
  final LanguageModel _body;
  NotiDetailModel.fromJson(Map<String, dynamic> json)
      : _id = json['_id'],
        _body = BaseModel.map<LanguageModel>(json: json,key: 'body');

  Map<String,dynamic> toJson()=>{
    '_id':_id,
    'body':_body
  };

  String get id => _id;
  LanguageModel get body => _body;
}
class EditNotiDetailModel extends EditBaseModel{
  String id='';
  String en='';
  String vi='';
  EditNotiDetailModel.fromJson(NotiDetailModel? noti){
    id = noti?.id ?? '';
    en = noti?.body.en??'';
     vi=noti?.body.vi??'';
  }
}

class LanguageModel extends BaseModel {
  final String _en;
  final String _vi;
  LanguageModel.fromJson(Map<String, dynamic> json)
      : _en = json['en'],
        _vi = json['vi'];
  Map<String, dynamic> toJson() => {'en': _en, 'vi': _vi};


  String get en =>_en;
  String get vi => _vi;
}
