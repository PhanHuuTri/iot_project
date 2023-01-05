import '../../../rest/models/rest_api_response.dart';
import 'face_user_model.dart';

class DoorModel extends BaseModel {
  final String _id;
  final String _name;
  final String _status;
  final EntryDeviceIdModel _entryDeviceId;
  final DoorGroupIdModel _doorGroupId;
  final ExitButtonInputIdModel _exitButtonInputId;
  final RelayOutputIdModel _relayOutputId;

  DoorModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'].toString(),
        _name = json['name'] ?? '',
        _status = json['status'].toString(),
        _entryDeviceId = BaseModel.map<EntryDeviceIdModel>(
          json: json,
          key: 'entry_device_id',
        ),
        _doorGroupId = BaseModel.map<DoorGroupIdModel>(
          json: json,
          key: 'door_group_id',
        ),
        _exitButtonInputId = BaseModel.map<ExitButtonInputIdModel>(
          json: json,
          key: 'exit_button_input_id',
        ),
        _relayOutputId = BaseModel.map<RelayOutputIdModel>(
          json: json,
          key: 'relay_output_id',
        );

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
        'status': _status,
        'entry_device_id': _entryDeviceId.toJson(),
        'door_group_id': _doorGroupId.toJson(),
        'exit_button_input_id': _exitButtonInputId.toJson(),
        'relay_output_id': _relayOutputId.toJson(),
      };

  String get id => _id;
  String get name => _name;
  String get status => _status;
  EntryDeviceIdModel get entryDeviceId => _entryDeviceId;
  DoorGroupIdModel get doorGroupId => _doorGroupId;
  ExitButtonInputIdModel get exitButtonInputId => _exitButtonInputId;
  RelayOutputIdModel get relayOutputId => _relayOutputId;
}

class EntryDeviceIdModel extends BaseModel {
  final int? _id;
  final String _name;
  final List _slaveDevices;

  EntryDeviceIdModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _name = json['name'] ?? '',
        _slaveDevices = json['slave_devices'] ?? [];

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
        'slave_devices': _slaveDevices,
      };

  int? get id => _id;
  String get name => _name;
  List get slaveDevices => _slaveDevices;
}

class DoorGroupIdModel extends BaseModel {
  final String _id;
  final String _name;

  DoorGroupIdModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'].toString(),
        _name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
      };

  String get id => _id;
  String get name => _name;
}

class ExitButtonInputIdModel extends BaseModel {
  final DeviceIdModel _deviceId;
  final int? _inputIndex;
  final String _type;

  ExitButtonInputIdModel.fromJson(Map<String, dynamic> json)
      : _deviceId = BaseModel.map<DeviceIdModel>(
          json: json,
          key: 'device_id',
        ),
        _inputIndex = json['input_index'],
        _type = json['type'] ?? '';

  Map<String, dynamic> toJson() => {
        'device_id': _deviceId.toJson(),
        'input_index': _inputIndex,
        'type': _type,
      };

  DeviceIdModel get deviceId => _deviceId;
  int? get inputIndex => _inputIndex;
  String get type => _type;
}

class RelayOutputIdModel extends BaseModel {
  final DeviceIdModel _deviceId;
  final int? _relayIndex;

  RelayOutputIdModel.fromJson(Map<String, dynamic> json)
      : _deviceId = BaseModel.map<DeviceIdModel>(
          json: json,
          key: 'device_id',
        ),
        _relayIndex = json['relay_index'];

  Map<String, dynamic> toJson() => {
        'device_id': _deviceId.toJson(),
        'relay_index': _relayIndex,
      };

  DeviceIdModel get deviceId => _deviceId;
  int? get relayIndex => _relayIndex;
}

class DeviceIdModel extends BaseModel {
  final int? _id;
  final List _slaveDevices;

  DeviceIdModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _slaveDevices = json['slave_devices'] ?? [];

  Map<String, dynamic> toJson() => {
        'id': _id,
        'slave_devices': _slaveDevices,
      };

  int? get id => _id;
  List get plateNumber => _slaveDevices;
}

class DoorListModel extends BaseModel {
  List<DoorModel> _data = [];
  final String _total;

  DoorListModel.fromJson(Map<String, dynamic> parsedJson)
      : _total = parsedJson['DoorCollection']['total'].toString() {
    List<DoorModel> tmp = [];
    for (int i = 0; i < parsedJson['DoorCollection']['rows'].length; i++) {
      var result = BaseModel.fromJson<DoorModel>(
          parsedJson['DoorCollection']['rows'][i]);
      tmp.add(result);
    }
    _data = tmp;
  }
  List<DoorModel> get records => _data;
  String get total => _total;
}

class ListDoorModel extends BaseModel {
  List<DoorModel> _data = [];

  ListDoorModel.listDynamic(List<dynamic> list) {
    List<DoorModel> tmp = [];
    for (int i = 0; i < list.length; i++) {
      var result = BaseModel.fromJson<DoorModel>(list[i]);
      tmp.add(result);
    }
    _data = tmp;
  }

  List<DoorModel> get records => _data;
}

class ListDeviceResponseModel extends BaseModel {
  final List<DeviceResponseModel> _data = [];
  final String _result;

  ListDeviceResponseModel.fromJson(Map<String, dynamic> parsedJson)
      : _result = parsedJson['DeviceResponse']['result'] {
    _data.addAll(BaseModel.mapList<DeviceResponseModel>(
      json: parsedJson['DeviceResponse'],
      key: 'rows',
    ));
  }
  List<DeviceResponseModel> get records => _data;
  String get result => _result;
}

class DeviceResponseModel extends BaseModel {
  final String _id;
  final String _code;

  DeviceResponseModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _code = json['code'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': _id,
        'code': _code,
      };

  String get id => _id;
  String get code => _code;
}

class ListDoorControlModel extends BaseModel {
  final List<DoorControlModel> _data = [];

  ListDoorControlModel.fromJson(Map<String, dynamic> parsedJson) {
    _data.addAll(BaseModel.mapList<DoorControlModel>(
      json: parsedJson['AccessibleUserCollection'] ?? {},
      key: 'rows',
    ));
  }
  List<DoorControlModel> get records => _data;
}

class DoorControlModel extends BaseModel {
  final AccessGroupModel _accessGroup;
  final FaceUserModel _user;
  final DoorModel _door;
  final ScheduleModel _schedule;

  DoorControlModel.fromJson(Map<String, dynamic> json)
      : _accessGroup = BaseModel.map<AccessGroupModel>(
          json: json,
          key: 'access_group',
        ),
        _user = BaseModel.map<FaceUserModel>(
          json: json,
          key: 'user',
        ),
        _door = BaseModel.map<DoorModel>(
          json: json,
          key: 'door',
        ),
        _schedule = BaseModel.map<ScheduleModel>(
          json: json,
          key: 'schedule',
        );

  Map<String, dynamic> toJson() => {
        'access_group': _accessGroup.toJson(),
        'user': _user.toJson(),
        'door': _door.toJson(),
        'schedule': _schedule.toJson(),
      };

  AccessGroupModel get accessGroup => _accessGroup;
  FaceUserModel get user => _user;
  DoorModel get door => _door;
  ScheduleModel get schedule => _schedule;
}

class AccessGroupModel extends BaseModel {
  final String _id;
  final String _name;

  AccessGroupModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'] ?? '',
        _name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
      };

  String get id => _id;
  String get name => _name;
}

class ScheduleModel extends BaseModel {
  final String _id;
  final String _name;

  ScheduleModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'] ?? '',
        _name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
      };

  String get id => _id;
  String get name => _name;
}

class DoorStatusModel extends BaseModel {
  final String _id;
  final String _status;

  DoorStatusModel.fromJson(Map<String, dynamic> json)
      : _id = json['Door']['id'] ?? '',
        _status = json['Door']['status'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': _id,
        'status': _status,
      };

  String get id => _id;
  String get status => _status;
}
