import '../../../rest/models/rest_api_response.dart';

class DeviceModel extends BaseModel {
  final int _id;
  final String _name;
  final DeviceTypeIdModel _deviceTypeId;
  final int _status;
  final DeviceRs485Model _deviceRs485;
  final DeviceGroupIdModel _deviceGroupId;
  final DeviceVersionModel _deviceVersion;
  final DeviceLanModel _lan;
  final TnaModel _tna;
  final List _slaveDevices;
  final int _packetVersion;
  final int _supportOccupancy;

  DeviceModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _name = json['name'] ?? '',
        _deviceTypeId = BaseModel.map<DeviceTypeIdModel>(
          json: json,
          key: 'device_type_id',
        ),
        _status = json['status'],
        _deviceRs485 = BaseModel.map<DeviceRs485Model>(
          json: json,
          key: 'rs485',
        ),
        _deviceGroupId = BaseModel.map<DeviceGroupIdModel>(
          json: json,
          key: 'device_group_id',
        ),
        _deviceVersion = BaseModel.map<DeviceVersionModel>(
          json: json,
          key: 'version',
        ),
        _lan = BaseModel.map<DeviceLanModel>(
          json: json,
          key: 'lan',
        ),
        _tna = BaseModel.map<TnaModel>(
          json: json,
          key: 'tna',
        ),
        _slaveDevices = json['slave_devices'] ?? [],
        _packetVersion = json['packet_version'],
        _supportOccupancy = json['support_occupancy'];

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
        'device_type_id': _deviceTypeId.toJson(),
        'status': _status,
        'rs485': _deviceRs485.toJson(),
        'device_group_id': _deviceGroupId.toJson(),
        'version': _deviceVersion.toJson(),
        'lan': _lan.toJson(),
        'tna': _tna.toJson(),
        'slave_devices': _slaveDevices,
        'packet_version': _packetVersion,
        'support_occupancy': _supportOccupancy,
      };

  int get id => _id;
  String get name => _name;
  DeviceTypeIdModel get deviceTypeId => _deviceTypeId;
  int get status => _status;
  DeviceRs485Model get deviceRs485 => _deviceRs485;
  DeviceGroupIdModel get deviceGroupId => _deviceGroupId;
  DeviceVersionModel get deviceVersion => _deviceVersion;
  DeviceLanModel get lan => _lan;
  TnaModel get tna => _tna;
  List get slaveDevices => _slaveDevices;
  int get packetVersion => _packetVersion;
  int get supportOccupancy => _supportOccupancy;
}

class DeviceTypeIdModel extends BaseModel {
  final int _id;

  DeviceTypeIdModel.fromJson(Map<String, dynamic> json) : _id = json['id'];

  Map<String, dynamic> toJson() => {
        'id': _id,
      };

  int get id => _id;
}

class DeviceRs485Model extends BaseModel {
  final String _mode;
  final List _channels;
  final String _parentRs485Info;

  DeviceRs485Model.fromJson(Map<String, dynamic> json)
      : _mode = json['mode'] ?? '',
        _channels = json['channels'] ?? [],
        _parentRs485Info = json['parent_rs485_info'] ?? '';

  Map<String, dynamic> toJson() => {
        'mode': _mode,
        'channels': _channels,
        'parent_rs485_info': _parentRs485Info,
      };

  String get mode => _mode;
  List get channels => _channels;
  String get parentRs485Info => _parentRs485Info;
}

class DeviceGroupIdModel extends BaseModel {
  final int _id;
  final String _name;

  DeviceGroupIdModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
      };

  int get id => _id;
  String get name => _name;
}

class DeviceVersionModel extends BaseModel {
  final String _firmware;
  final String _productName;

  DeviceVersionModel.fromJson(Map<String, dynamic> json)
      : _firmware = json['firmware'] ?? '',
        _productName = json['product_name'] ?? '';

  Map<String, dynamic> toJson() => {
        'firmware': _firmware,
        'product_name': _productName,
      };

  String get firmware => _firmware;
  String get productName => _productName;
}

class DeviceLanModel extends BaseModel {
  final String _ip;
  final String _connectionMode;

  DeviceLanModel.fromJson(Map<String, dynamic> json)
      : _ip = json['ip'] ?? '',
        _connectionMode = json['connection_mode'] ?? '';

  Map<String, dynamic> toJson() => {
        'ip': _ip,
        'connection_mode': _connectionMode,
      };

  String get ip => _ip;
  String get connectionMode => _connectionMode;
}

class TnaModel extends BaseModel {
  final String _mode;
  final String _required;
  final String _fixedCode;
  final List<TnaKeyModel> _tnaKeys = [];

  TnaModel.fromJson(Map<String, dynamic> json)
      : _mode = json['mode'] ?? '',
        _required = json['required'] ?? '',
        _fixedCode = json['fixed_code'] ?? '' {
    _tnaKeys.addAll(BaseModel.mapList<TnaKeyModel>(
      json: json,
      key: 'tna_keys',
    ));
  }

  Map<String, dynamic> toJson() => {
        'mode': _mode,
        'required': _required,
        'fixed_code': _fixedCode,
        'tna_keys': _tnaKeys.map((e) => e.toJson()).toList(),
      };

  String get mode => _mode;
  String get required => _required;
  String get fixedCode => _fixedCode;
  List<TnaKeyModel> get tnaKeys => _tnaKeys;
}

class TnaKeyModel extends BaseModel {
  final String _enabled;
  final String _label;
  final String _icon;

  TnaKeyModel.fromJson(Map<String, dynamic> json)
      : _enabled = json['enabled'] ?? '',
        _label = json['label'] ?? '',
        _icon = json['icon'] ?? '';

  Map<String, dynamic> toJson() => {
        'enabled': _enabled,
        'label': _label,
        'icon': _icon,
      };

  String get enabled => _enabled;
  String get label => _label;
  String get icon => _icon;
}

class DeviceListModel extends BaseModel {
  List<DeviceModel> _data = [];
  final String _total;

  DeviceListModel.fromJson(Map<String, dynamic> parsedJson)
      : _total = parsedJson['DeviceCollection']['total'].toString() {
    List<DeviceModel> tmp = [];
    for (int i = 0; i < parsedJson['DeviceCollection']['rows'].length; i++) {
      var result = BaseModel.fromJson<DeviceModel>(
          parsedJson['DeviceCollection']['rows'][i]);
      tmp.add(result);
    }
    _data = tmp;
  }
  List<DeviceModel> get records => _data;
  String get total => _total;
}

class ListDeviceModel extends BaseModel {
  List<DeviceModel> _data = [];

  ListDeviceModel.listDynamic(List<dynamic> list) {
    List<DeviceModel> tmp = [];
    for (int i = 0; i < list.length; i++) {
      var result = BaseModel.fromJson<DeviceModel>(list[i]);
      tmp.add(result);
    }
    _data = tmp;
  }

  List<DeviceModel> get records => _data;
}
