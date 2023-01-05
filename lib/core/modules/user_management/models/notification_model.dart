import '../../../../main.dart';



class NotificationModel extends BaseModel {
  final MultipleLanguagesBodyModel _multipleLanguagesBody;
  final String _category;
  final bool _isValid;
  final bool _read;
  final int _createdTime;
  final String __id;
  final String _title;
  final String _body;
  final String _user;
  final String _createdAt;
  final UserIdHealthyModel _data;

  NotificationModel.fromJson(Map<String, dynamic> json)
      : _multipleLanguagesBody = BaseModel.map<MultipleLanguagesBodyModel>(
            json: json, key: 'multipleLanguagesBody'),
        _category = json['category'] ?? '',
        _isValid = json['isValid'] ?? false,
        _read = json['read'] ?? false,
        _createdTime = json['created_time'],
        __id = json['_id'] ?? '',
        _title = json['title'] ?? '',
        _body = json['body'] ?? '',
        _user = json['user'] ?? '',
        _createdAt = json['createdAt'] ?? '',
        _data = BaseModel.map<UserIdHealthyModel>(
          json: json,
          key: 'data'
        );

  Map<String, dynamic> toJson() => {
        'multipleLanguagesBody': _multipleLanguagesBody.toJson(),
        'category': _category,
        'isValid': _isValid,
        'read': _read,
        'created_time': _createdTime,
        '_id': __id,
        'title': _title,
        'body': _body,
        'user': _user,
        'createdAt': _createdAt,
        'data': _data
      };

  MultipleLanguagesBodyModel get multipleLanguagesBody =>
      _multipleLanguagesBody;
  String get category => _category;
  bool get isValid => _isValid;
  bool get read => _read;
  int get createdTime => _createdTime;
  String get id => __id;
  String get title => _title;
  String get body => _body;
  String get user => _user;
  String get createdAt => _createdAt;
  UserIdHealthyModel get data => _data;
}
class UserIdHealthyModel extends BaseModel{
  final String _idHealthy;
  final String _idParking;
  UserIdHealthyModel.fromJson(Map<String,dynamic> json)
  : _idHealthy=json['idHealthyCheck']??'',
  _idParking=json['idSmartParking']??'';

  Map<String,dynamic> toJson()=>{
    'idHealthyCheck':_idHealthy,
    'idSmartParking':_idParking,
  };
  String get idHealthy => _idHealthy;
  String get idParking => _idParking;
}

class MultipleLanguagesBodyModel extends BaseModel {
  final String _en;
  final String _vi;

  MultipleLanguagesBodyModel.fromJson(Map<String, dynamic> json)
      : _en = json['en'] ?? '',
        _vi = json['vi'] ?? '';

  Map<String, dynamic> toJson() => {
        'en': _en,
        'vi': _vi,
      };
  String get en => _en;
  String get vi => _vi;
}

class UnreadTotalModel extends BaseModel {
  final int _total;

  UnreadTotalModel.fromJson(Map<String, dynamic> json)
      : _total = json['totalUnreadNotifications'] ?? 0;

  Map<String, dynamic> toJson() => {
        'totalUnreadNotifications': _total,
      };
  int get total => _total;
}

class NotificationListModel extends BaseModel {
  List<NotificationModel> _data = [];
  Paging _metaData = Paging.fromJson({});

  NotificationListModel.fromJson(Map<String, dynamic> parsedJson) {
    List<NotificationModel> tmp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      var result = BaseModel.fromJson<NotificationModel>(parsedJson['data'][i]);
      tmp.add(result);
    }
    _data = tmp;
    _metaData = Paging.fromJson(parsedJson['meta_data']);
  }

  List<NotificationModel> get records => _data;
  Paging get meta => _metaData;
}
