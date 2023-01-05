import 'package:web_iot/core/base/models/common_model.dart';

import '../../../rest/models/rest_api_response.dart';
import 'door_model.dart';

class EventModel extends BaseModel {
  final String _id;
  final String _serverDateTime;
  final String _datetime;
  final String _index;
  final String _userIdName;
  final EventUserIdModel _userId;
  final EventUserGroupIdModel _userGroupId;
  final String _userPhone;
  final String _userEmail;
  final EventDeviceIdModel _deviceId;
  final EventTypeIdModel _eventTypeId;
  final List<DoorModel> _doorModels = [];
  final String _isDst;
  final EventTimeZoneModel _timeZone;
  final String _userUpdateByDevice;
  final String _hint;
  final String _temperature;
  final String _event;

  EventModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'] ?? '',
        _serverDateTime = json['server_datetime'] ?? '',
        _datetime = json['datetime'] ?? '',
        _index = json['index'] ?? '',
        _userIdName = json['user_id_name'] ?? '',
        _userId = BaseModel.map<EventUserIdModel>(
          json: json,
          key: 'user_id',
        ),
        _userGroupId = BaseModel.map<EventUserGroupIdModel>(
          json: json,
          key: 'user_group_id',
        ),
        _userPhone = json['user_phone'] ?? '',
        _userEmail = json['user_email'] ?? '',
        _deviceId = BaseModel.map<EventDeviceIdModel>(
          json: json,
          key: 'device_id',
        ),
        _eventTypeId = BaseModel.map<EventTypeIdModel>(
          json: json,
          key: 'event_type_id',
        ),
        _isDst = json['is_dst'] ?? '',
        _timeZone = BaseModel.map<EventTimeZoneModel>(
          json: json,
          key: 'timezone',
        ),
        _userUpdateByDevice = json['user_update_by_device'] ?? '',
        _hint = json['hint'] ?? '',
        _temperature = json['temperature'] ?? '',
        _event = json['event'] ?? '' {
    _doorModels.addAll(BaseModel.mapList<DoorModel>(
      json: json,
      key: 'door_id',
    ));
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'server_datetime': _serverDateTime,
        'datetime': _datetime,
        'index': _index,
        'user_id_name': _userIdName,
        'user_id': _userId.toJson(),
        'user_group_id': _userGroupId.toJson(),
        'user_phone': _userPhone,
        'user_email': _userEmail,
        'device_id': _deviceId.toJson(),
        'event_type_id': _eventTypeId.toJson(),
        'is_dst': _isDst,
        'timezone': _timeZone.toJson(),
        'user_update_by_device': _userUpdateByDevice,
        'hint': _hint,
        'temperature': _temperature,
        'event': _event,
        'door_id': _doorModels.map((e) => e.toJson()).toList(),
      };

  String get id => _id;
  String get serverDateTime => _serverDateTime;
  String get datetime => _datetime;
  String get index => _index;
  String get userIdName => _userIdName;
  EventUserIdModel get userId => _userId;
  EventUserGroupIdModel get userGroupId => _userGroupId;
  String get userPhone => _userPhone;
  String get userEmail => _userEmail;
  EventDeviceIdModel get deviceId => _deviceId;
  EventTypeIdModel get eventTypeId => _eventTypeId;
  String get isDst => _isDst;
  EventTimeZoneModel get timeZone => _timeZone;
  String get userUpdateByDevice => _userUpdateByDevice;
  String get hint => _hint;
  String get temperature => _temperature;
  String get event => _event;
  List<DoorModel> get doorModels => _doorModels;
}

class EventUserIdModel extends BaseModel {
  final String _userId;
  final String _name;
  final String _photoExists;

  EventUserIdModel.fromJson(Map<String, dynamic> json)
      : _userId = json['user_id'] ?? '',
        _name = json['name'] ?? '',
        _photoExists = json['photo_exists'] ?? '';

  Map<String, dynamic> toJson() => {
        'user_id': _userId,
        'name': _name,
        'photo_exists': _photoExists,
      };

  String get userId => _userId;
  String get name => _name;
  String get photoExists => _photoExists;
}

class EventUserGroupIdModel extends BaseModel {
  final String _id;
  final String _name;

  EventUserGroupIdModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'] ?? '',
        _name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
      };

  String get id => _id;
  String get name => _name;
}

class EventDeviceIdModel extends BaseModel {
  final String _id;
  final String _name;

  EventDeviceIdModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'] ?? '',
        _name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
      };

  String get id => _id;
  String get name => _name;
}

class EventTypeIdModel extends BaseModel {
  final String _code;

  EventTypeIdModel.fromJson(Map<String, dynamic> json)
      : _code = json['code'] ?? '';

  Map<String, dynamic> toJson() => {
        'code': _code,
      };

  String get code => _code;
}

class EventTimeZoneModel extends BaseModel {
  final String _half;
  final String _hour;
  final String _negative;

  EventTimeZoneModel.fromJson(Map<String, dynamic> json)
      : _half = json['half'] ?? '',
        _hour = json['hour'] ?? '',
        _negative = json['negative'] ?? '';

  Map<String, dynamic> toJson() => {
        'half': _half,
        'hour': _hour,
        'negative': _negative,
      };

  String get half => _half;
  String get hour => _hour;
  String get negative => _negative;
}

class EventListModel extends BaseModel {
  List<EventModel> _data = [];
  final String _total;
  Paging _metaData = Paging.fromParkingJson({});

  EventListModel.fromJson(Map<String, dynamic> parsedJson)
      : _total = parsedJson['EventCollection']['total'].toString() {
    List<EventModel> tmp = [];
    for (int i = 0; i < parsedJson['EventCollection']['rows'].length; i++) {
      var result = BaseModel.fromJson<EventModel>(
          parsedJson['EventCollection']['rows'][i]);
      tmp.add(result);
    }
    _data = tmp;
    _metaData = Paging.fromParkingJson(parsedJson);
  }
  List<EventModel> get records => _data;
  String get total => _total;
  Paging get meta => _metaData;
}

class ListEventModel extends BaseModel {
  List<EventModel> _data = [];

  ListEventModel.listDynamic(List<dynamic> list) {
    List<EventModel> tmp = [];
    for (int i = 0; i < list.length; i++) {
      var result = BaseModel.fromJson<EventModel>(list[i]);
      tmp.add(result);
    }
    _data = tmp;
  }

  List<EventModel> get records => _data;
}
