import '../../../../main.dart';

class ModuleModel extends BaseModel {
  final int? _updatedTime;
  final String _id;
  final int? _createdTime;
  final String _name;
  final String _displayName;
  final List<PermissionModel> _permissions = [];
  ModuleModel.fromJson(Map<String, dynamic> json)
      : _updatedTime = json['updated_time'],
        _id = json['_id'] ?? '',
        _createdTime = json['created_time'],
        _name = json['name'] ?? '',
        _displayName = json['display_name'] ?? '' {
    _permissions.addAll(BaseModel.mapList<PermissionModel>(
      json: json,
      key: 'permissions',
    ));
  }
  Map<String, dynamic> toJson() => {
        'updated_time': _updatedTime,
        '_id': _id,
        'created_time': _createdTime,
        'name': _name,
        'display_name': _displayName,
        'permissions': _permissions.map((e) => e.toJson()).toList(),
      };

  int? get updatedTime => _updatedTime;
  String get id => _id;
  int? get createdTime => _createdTime;
  String get name => _name;
  String get displayName => _displayName;
  List<PermissionModel> get permissions => _permissions;
}

class EditModuleModel extends EditBaseModel {
  String id = '';
  String name = '';
  String displayName = '';
  List<PermissionModel> permissions = [];

  EditModuleModel.fromModel(ModuleModel? model) {
    id = model?.id ?? '';
    name = model?.name ?? '';
    displayName = model?.displayName ?? '';
    permissions = model?.permissions.toList() ?? [];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'displayName': displayName,
        'permissions': permissions.map((e) => e.toJson()).toList(),
      };

  Map<String, dynamic> toCreateJson() => {
        '_id': id,
        'name': name,
        'display_name': displayName,
        'permissions': permissions.map((e) => e.toJson()).toList(),
      };

  Map<String, dynamic> toEditJson() => {
        '_id': id,
        'name': name,
        'display_name': displayName,
        'permissions': permissions.map((e) => e.toJson()).toList(),
      };
}

class PermissionModel extends BaseModel {
  final bool _admin;
  final bool _user;
  final bool _security;
  final bool _allRoles;
  final String _id;
  final String _name;
  final String _description;
  final String _permissionCode;

  PermissionModel.fromJson(Map<String, dynamic> json)
      : _admin = json['admin'] ?? false,
        _user = json['user'] ?? false,
        _security = json['security'] ?? false,
        _allRoles = json['allRoles'] ?? false,
        _id = json['_id'] ?? '',
        _name = json['name'] ?? '',
        _description = json['_description'] ?? '',
        _permissionCode = json['permission_code'] ?? '';

  Map<String, dynamic> toJson() => {
        'admin': _admin,
        'user': _user,
        'security': _security,
        'all_roles': _allRoles,
        '_id': _id,
        'name': _name,
        'description': _description,
        'permission_code': _permissionCode
      };

  bool get admin => _admin;
  bool get user => _user;
  bool get security => _security;
  bool get allRoles => _allRoles;
  String get id => _id;
  String get name => _name;
  String get description => _description;
  String get permissionCode => _permissionCode;
}

class ListModuleModel extends BaseModel {
  List<ModuleModel> _data = [];

  ListModuleModel.listDynamic(List<dynamic> list) {
    List<ModuleModel> tmp = [];
    for (int i = 0; i < list.length; i++) {
      var result = BaseModel.fromJson<ModuleModel>(list[i]);
      tmp.add(result);
    }
    _data = tmp;
  }

  List<ModuleModel> get records => _data;
}

class ModuleListModel extends BaseModel {
  List<ModuleModel> _data = [];

  ModuleListModel.fromJson(Map<String, dynamic> parsedJson) {
    List<ModuleModel> tmp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      var result = BaseModel.fromJson<ModuleModel>(parsedJson['data'][i]);
      tmp.add(result);
    }
    _data = tmp;
  }

  List<ModuleModel> get records => _data;
}
