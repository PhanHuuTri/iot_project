import '../../../rest/models/rest_api_response.dart';

class FaceUserModel extends BaseModel {
  final String _userId;
  final String _name;
  final String _email;
  final String _phone;
  final FaceUserGroupIdModel _userGroupId;
  final int? _fingerprintTemplateCount;
  final int? _faceCount;
  final int? _cardCount;
  final String _startDatetime;
  final String _expiryDatetime;
  final int? _updatedCount;
  final bool _disabled;
  final int? _visualFaceCount;
  final List<FaceRoleModel> _accessGroups = [];

  FaceUserModel.fromJson(Map<String, dynamic> json)
      : _userId = json['user_id'] ?? '',
        _name = json['name'] ?? '',
        _email = json['email'] ?? '',
        _phone = json['phone'] ?? '',
        _userGroupId = BaseModel.map<FaceUserGroupIdModel>(
          json: json,
          key: 'user_group_id',
        ),
        _fingerprintTemplateCount = json['fingerprint_template_count'],
        _faceCount = json['face_count'],
        _cardCount = json['card_count'],
        _startDatetime = json['start_datetime'] ?? '',
        _expiryDatetime = json['expiry_datetime'] ?? '',
        _updatedCount = json['updated_count'],
        _disabled = json['disabled'] ?? false,
        _visualFaceCount = json['visual_face_count'] {
    _accessGroups.addAll(BaseModel.mapList<FaceRoleModel>(
      json: json,
      key: 'access_groups',
    ));
  }

  Map<String, dynamic> toJson() => {
        'user_id': _userId,
        'name': _name,
        'email': _email,
        'phone': _phone,
        'user_group_id': _userGroupId.toJson(),
        'fingerprint_template_count': _fingerprintTemplateCount,
        'face_count': _faceCount,
        'card_count': _cardCount,
        'start_datetime': _startDatetime,
        'expiry_datetime': _expiryDatetime,
        'updated_count': _updatedCount,
        'disabled': _disabled,
        'visual_face_count': _visualFaceCount,
        'access_groups': _accessGroups.map((e) => e.toJson()).toList(),
      };

  String get userId => _userId;
  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  FaceUserGroupIdModel get userGroupId => _userGroupId;
  int? get fingerprintTemplateCount => _fingerprintTemplateCount;
  int? get faceCount => _faceCount;
  int? get cardCount => _cardCount;
  String get startDatetime => _startDatetime;
  String get expiryDatetime => _expiryDatetime;
  int? get updatedCount => _updatedCount;
  bool get disabled => _disabled;
  int? get visualFaceCount => _visualFaceCount;
  List<FaceRoleModel> get accessGroups => _accessGroups;
}

class FaceUserGroupIdModel extends BaseModel {
  final String _id;
  final String _name;

  FaceUserGroupIdModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'].toString(),
        _name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
      };

  String get id => _id;
  String get name => _name;
}

class FaceUserListModel extends BaseModel {
  List<FaceUserModel> _data = [];
  final String _total;

  FaceUserListModel.fromJson(Map<String, dynamic> parsedJson)
      : _total = parsedJson['UserCollection']['total'].toString() {
    List<FaceUserModel> tmp = [];
    for (int i = 0; i < parsedJson['UserCollection']['rows'].length; i++) {
      var result = BaseModel.fromJson<FaceUserModel>(
          parsedJson['UserCollection']['rows'][i]);
      tmp.add(result);
    }
    _data = tmp;
  }
  List<FaceUserModel> get records => _data;
  String get total => _total;
}

class ListFaceUserModel extends BaseModel {
  List<FaceUserModel> _data = [];

  ListFaceUserModel.listDynamic(List<dynamic> list) {
    List<FaceUserModel> tmp = [];
    for (int i = 0; i < list.length; i++) {
      var result = BaseModel.fromJson<FaceUserModel>(list[i]);
      tmp.add(result);
    }
    _data = tmp;
  }

  List<FaceUserModel> get records => _data;
}

class FaceRoleModel extends BaseModel {
  final String _id;
  final String _name;
  final List<FaceUserModel> _users = [];
  final List _userGroups = [];
  final AccessLevelsModel _accessLevels;
  final List _floorLevels = [];

  FaceRoleModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'].toString(),
        _name = json['name'] ?? '',
        _accessLevels = BaseModel.map<AccessLevelsModel>(
          json: json,
          key: 'access_levels',
        ) {
    _users.addAll(BaseModel.mapList<FaceUserModel>(
      json: json,
      key: 'users',
    ));
    _userGroups.addAll(json['user_groups']);
    _floorLevels.addAll(json['floor_levels']);
  }

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
        'users': _users.map((e) => e.toJson()).toList(),
        'user_groups': _userGroups,
        'access_levels': _accessLevels.toJson(),
        'floor_levels': _floorLevels,
      };

  String get id => _id;
  String get name => _name;
  List<FaceUserModel> get users => _users;
  List get userGroups => _userGroups;
  AccessLevelsModel get accessLevels => _accessLevels;
  List get floorLevels => _floorLevels;
}

class AccessLevelsModel extends BaseModel {
  final String _id;
  final String _name;

  AccessLevelsModel.fromJson(Map<String, dynamic> json)
      : _id = json['id'].toString(),
        _name = json['name'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': _id,
        'name': _name,
      };

  String get id => _id;
  String get name => _name;
}

class ListFaceFaceRoleModel extends BaseModel {
  List<FaceRoleModel> _data = [];

  ListFaceFaceRoleModel.fromJson(Map<String, dynamic> parsedJson) {
    List<FaceRoleModel> tmp = [];
    for (int i = 0;
        i < parsedJson['AccessGroupCollection']['rows'].length;
        i++) {
      var result = BaseModel.fromJson<FaceRoleModel>(
          parsedJson['AccessGroupCollection']['rows'][i]);
      tmp.add(result);
    }
    _data = tmp;
  }
  List<FaceRoleModel> get records => _data;
}

class EditFaceRoleModel extends EditBaseModel {
  String id = '';
  String name = '';

  EditFaceRoleModel.fromModel(FaceUserModel? model) {
    id = model!.accessGroups.isNotEmpty ? model.accessGroups.first.id : '';
    name = model.accessGroups.isNotEmpty ? model.accessGroups.first.name : '';
  }

  Map<String, dynamic> toEditJson() {
    Map<String, dynamic> params = {
      "access_groups": [
        {
          "id": id,
          "name": name,
        }
      ]
    };
    return params;
  }
}
