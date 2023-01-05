import '../../../rest/models/rest_api_response.dart';

class DashboardStatusModel extends BaseModel {
  final DashboardUser _dashboardUser;
  final DashboardDevices _dashboardDevices;
  final DashboardDoors _dashboardDoors;
  final DashboardAccessGroups _dashboardAccessGroups;
  final DashboardFingerTempletes _dashboardFingerTempletes;
  final DashboardCards _dashboardCards;
  final DashboardZones _dashboardZones;
  final DashboardFaces _dashboardFaces;

  DashboardStatusModel.fromJson(Map<String, dynamic> json)
      : _dashboardUser = BaseModel.map<DashboardUser>(
          json: json,
          key: 'users',
        ),
        _dashboardDevices = BaseModel.map<DashboardDevices>(
          json: json,
          key: 'devices',
        ),
        _dashboardDoors = BaseModel.map<DashboardDoors>(
          json: json,
          key: 'doors',
        ),
        _dashboardAccessGroups = BaseModel.map<DashboardAccessGroups>(
          json: json,
          key: 'access_groups',
        ),
        _dashboardFingerTempletes = BaseModel.map<DashboardFingerTempletes>(
          json: json,
          key: 'finger_templates',
        ),
        _dashboardCards = BaseModel.map<DashboardCards>(
          json: json,
          key: 'cards',
        ),
        _dashboardZones = BaseModel.map<DashboardZones>(
          json: json,
          key: 'zones',
        ),
        _dashboardFaces = BaseModel.map<DashboardFaces>(
          json: json,
          key: 'faces',
        );

  Map<String, dynamic> toJson() => {
        'users': _dashboardUser.toJson(),
        'devices': _dashboardDevices,
        'doors': _dashboardDoors.toJson(),
        'access_groups': _dashboardAccessGroups.toJson(),
        'finger_templates': _dashboardFingerTempletes.toJson(),
        'cards': _dashboardCards.toJson(),
        'zones': _dashboardZones.toJson(),
        'faces': _dashboardFaces.toJson()
      };

  DashboardUser get dashboardUser => _dashboardUser;
  DashboardDevices get dashboardDevices => _dashboardDevices;
  DashboardDoors get dashboardDoors => _dashboardDoors;
  DashboardAccessGroups get dashboardAccessGroups => _dashboardAccessGroups;
  DashboardFingerTempletes get dashboardFingerTempletes =>
      _dashboardFingerTempletes;
  DashboardCards get dashboardCards => _dashboardCards;
  DashboardZones get dashboardZones => _dashboardZones;
  DashboardFaces get dashboardFaces => _dashboardFaces;
}

class DashboardUser extends BaseModel {
  final String _count;
  final String _maxCount;

  DashboardUser.fromJson(Map<String, dynamic> json)
      : _count = json['count'] ?? '',
        _maxCount = json['max_count'] ?? '';

  Map<String, dynamic> toJson() => {
        'count': _count,
        'max_count': _maxCount,
      };

  String get count => _count;
  String get maxCount => _maxCount;
}

class DashboardDevices extends BaseModel {
  final String _count;
  final String _maxCount;

  DashboardDevices.fromJson(Map<String, dynamic> json)
      : _count = json['count'] ?? '',
        _maxCount = json['max_count'] ?? '';

  Map<String, dynamic> toJson() => {
        'count': _count,
        'max_count': _maxCount,
      };

  String get count => _count;
  String get maxCount => _maxCount;
}

class DashboardDoors extends BaseModel {
  final String _count;
  final String _maxCount;

  DashboardDoors.fromJson(Map<String, dynamic> json)
      : _count = json['count'] ?? '',
        _maxCount = json['max_count'] ?? '';

  Map<String, dynamic> toJson() => {
        'count': _count,
        'max_count': _maxCount,
      };

  String get count => _count;
  String get maxCount => _maxCount;
}

class DashboardAccessGroups extends BaseModel {
  final String _count;
  final String _maxCount;

  DashboardAccessGroups.fromJson(Map<String, dynamic> json)
      : _count = json['count'] ?? '',
        _maxCount = json['max_count'] ?? '';

  Map<String, dynamic> toJson() => {
        'count': _count,
        'max_count': _maxCount,
      };

  String get count => _count;
  String get maxCount => _maxCount;
}

class DashboardFingerTempletes extends BaseModel {
  final String _count;
  final String _maxCount;

  DashboardFingerTempletes.fromJson(Map<String, dynamic> json)
      : _count = json['count'] ?? '',
        _maxCount = json['max_count'] ?? '';

  Map<String, dynamic> toJson() => {
        'count': _count,
        'max_count': _maxCount,
      };

  String get count => _count;
  String get maxCount => _maxCount;
}

class DashboardCards extends BaseModel {
  final String _count;
  final String _maxCount;

  DashboardCards.fromJson(Map<String, dynamic> json)
      : _count = json['count'] ?? '',
        _maxCount = json['max_count'] ?? '';

  Map<String, dynamic> toJson() => {
        'count': _count,
        'max_count': _maxCount,
      };

  String get count => _count;
  String get maxCount => _maxCount;
}

class DashboardZones extends BaseModel {
  final String _count;
  final String _maxCount;

  DashboardZones.fromJson(Map<String, dynamic> json)
      : _count = json['count'] ?? '',
        _maxCount = json['max_count'] ?? '';

  Map<String, dynamic> toJson() => {
        'count': _count,
        'max_count': _maxCount,
      };

  String get count => _count;
  String get maxCount => _maxCount;
}

class DashboardFaces extends BaseModel {
  final String _count;
  final String _maxCount;

  DashboardFaces.fromJson(Map<String, dynamic> json)
      : _count = json['count'] ?? '',
        _maxCount = json['max_count'] ?? '';

  Map<String, dynamic> toJson() => {
        'count': _count,
        'max_count': _maxCount,
      };

  String get count => _count;
  String get maxCount => _maxCount;
}
//--------------DashboardAlertStatistic
class DashboardAlertStatisticModel extends BaseModel {
  final String _total;
  final List<AlertStatisticModel> _rows = [];

  DashboardAlertStatisticModel.fromJson(Map<String, dynamic> json)
      : _total = json['total'] ?? '' {
    _rows.addAll(BaseModel.mapList<AlertStatisticModel>(
      json: json,
      key: 'rows',
    ));
  }

  Map<String, dynamic> toJson() => {
        'total': _total,
        'rows': _rows.map((e) => e.toJson()).toList(),
      };

  String get total => _total;
  List<AlertStatisticModel> get rows => _rows;
}

class AlertStatisticModel extends BaseModel {
  final String _id;
  final String _count;
  final List<AlertEventModel> _top3Event = [];

  AlertStatisticModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _count = json['count'] ?? '' {
    _top3Event.addAll(BaseModel.mapList<AlertEventModel>(
      json: json,
      key: 'top3_event',
    ));
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'count': _count,
        'top3_event': _top3Event.map((e) => e.toJson()).toList(),
      };

  String get id => _id;
  String get count => _count;
  List<AlertEventModel> get top3Event => _top3Event;
}

class AlertEventModel extends BaseModel {
  final AlertEventTypeIdModel _eventTypeId;
  final String _count;

  AlertEventModel.fromJson(Map<String, dynamic> json)
      : _eventTypeId = BaseModel.map<AlertEventTypeIdModel>(
          json: json,
          key: 'event_type_id',
        ),
        _count = json['count'] ?? '';

  Map<String, dynamic> toJson() => {
        'event_type_id': _eventTypeId,
        'count': _count,
      };

  AlertEventTypeIdModel get eventTypeId => _eventTypeId;
  String get count => _count;
}


class AlertEventTypeIdModel extends BaseModel {
  final String _code;
  final String _name;

  AlertEventTypeIdModel.fromJson(Map<String, dynamic> json)
      : _code = json['code'] ?? '',
        _name = json['_name'] ?? '';

  Map<String, dynamic> toJson() => {
        'code': _code,
        'name': _name,
      };

  String get code => _code;
  String get name => _name;
}
// ----------------------------DashboardAlert

class DashboardAlertModel extends BaseModel {
  final String _total;
  final List<EventIdModel> _rows = [];

  DashboardAlertModel.fromJson(Map<String, dynamic> json)
     : _total = json['total'] ?? '' {
    _rows.addAll(BaseModel.mapList<EventIdModel>(
      json: json,
      key: 'rows',
    ));
  }
  String get total => _total;
  List<EventIdModel> get rows => _rows;
}
class EventIdModel extends BaseModel{
  final AlertModel _alert;
  final String _status;

  EventIdModel.fromJson(Map<String,dynamic> json)
  : 
   _alert = BaseModel.map<AlertModel>(
   json: json, key: 'event_id'),
  _status=json['status']??'';

  Map<String,dynamic> toJson()=>{
    'event_id':_alert,
    'status':_status
  };
   AlertModel get alert => _alert;
  String get status =>_status;
}
class AlertModel extends BaseModel{
  final String _id;
  final String _dateTime;
  final String _index;
  final DeviceAlert _idDevice;
  final EventTypeAlert _eventTypeId;
  final String _userupdate;

  AlertModel.fromJson(Map<String,dynamic> json)
  : _id=json['id'],
  _dateTime=json['datetime'],
  _index =json['index'],
  _idDevice = BaseModel.map<DeviceAlert>(
    json: json,
    key: 'device_id',
  ),
  _eventTypeId = BaseModel.map<EventTypeAlert>(
    json: json,
    key: 'event_type_id'
  ),
  _userupdate=json['user_update_by_device'];

  Map<String,dynamic> toJson()=> {
    'id':_id,
    'datetime':_dateTime,
    'index': _index,
    'device_id':_idDevice,
    'event_type_id':_eventTypeId,
    'user_update_by_device':_userupdate
  };
  String get id => _id;
  String get datetime => _dateTime;
  String get index => _index;
  DeviceAlert get deviceid => _idDevice;
  EventTypeAlert get eventType => _eventTypeId;
  String get userUpdate => _userupdate;
}
class DeviceAlert extends BaseModel{
  final String _id;
  final String _name;

  DeviceAlert.fromJson(Map<String, dynamic> json)
      : _id = json['id'] ?? '',
        _name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
      };

  String get id => _id;
  String get name => _name;
}
class EventTypeAlert extends BaseModel{
  final String _code;
  EventTypeAlert.fromJson(Map<String, dynamic> json)
      :  _code = json['code'] ?? '';

  Map<String, dynamic> toJson() => {
        'code': _code,
      };

  String get code => _code;
}
//--------------------------------------------------
class DashboardNoticeModel extends BaseModel {
  final String _registeredDate;
  final String _name;
  final String _id;
  final String _description;

  DashboardNoticeModel.fromJson(Map<String, dynamic> json)
      : _registeredDate = json['registered_date'] ?? '',
        _name = json['name'] ?? '',
        _id = json['id'] ?? '',
        _description = json['description'] ?? '';

  Map<String, dynamic> toJson() => {
        'registered_date': _registeredDate,
        'name': _name,
        'id': _id,
        'description': _description,
      };

  String get registeredDate => _registeredDate;
  String get name => _name;
  String get id => _id;
  String get description => _description;
}



//---------------------------------Dashboard
class DashboardModel extends BaseModel {
  final DashboardStatusModel _dashboardStatusModel;
  final DashboardAlertStatisticModel _dashboardAlertStatisticModel;
  final List<DashboardNoticeModel> _dashboardNoticeModel = [];
  final DashboardAlertModel _dashboardAlertModel;
  DashboardModel.fromJson(Map<String, dynamic> json)
      : _dashboardStatusModel = BaseModel.map<DashboardStatusModel>(
          json: json,
          key: 'BiostarStatus',
        ),
        _dashboardAlertStatisticModel =
            BaseModel.map<DashboardAlertStatisticModel>(
          json: json,
          key: 'AlertStatisticCollection',
        ),
        _dashboardAlertModel = BaseModel.map<DashboardAlertModel>(
          json: json,
          key: 'AlertCollection',
        ) {
    _dashboardNoticeModel.addAll(BaseModel.mapList<DashboardNoticeModel>(
      json: json['NoticeCollection'] ?? {},
      key: 'rows',
    ));
  }

  DashboardStatusModel get dashboardStatusModel => _dashboardStatusModel;
  DashboardAlertStatisticModel get dashboardAlertStatisticModel =>
      _dashboardAlertStatisticModel;
  List<DashboardNoticeModel> get dashboardNoticeModel => _dashboardNoticeModel;
  DashboardAlertModel get dashboardAlertModel => _dashboardAlertModel;
}
