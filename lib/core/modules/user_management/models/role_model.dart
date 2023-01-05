import '../../../../main.dart';
import 'module_model.dart';

class RoleModel extends BaseModel {
  final List<ModuleModel> _modules = [];
  final String _roleType;
  final int? _updatedTime;
  final String _id;
  final int? _createdTime;
  final String _name;
  final String _userUpdated;
  final String _userCreated;

  RoleModel.fromJson(Map<String, dynamic> json)
      : _roleType = json['role_type'] ?? '',
        _updatedTime = json['updated_time'],
        _id = json['_id'] ?? '',
        _createdTime = json['created_time'],
        _name = json['name'] ?? '',
        _userUpdated = json['user_updated'] ?? '',
        _userCreated = json['user_created'] ?? '' {
    _modules.addAll(BaseModel.mapList<ModuleModel>(
      json: json,
      key: 'modules',
    ));
  }

  Map<String, dynamic> toJson() => {
        'modules': _modules.map((e) => e.toJson()).toList(),
        'role_type': _roleType,
        'updated_time': _updatedTime,
        '_id': _id,
        'created_time': _createdTime,
        'name': _name,
        'user_updated': _userUpdated,
        'user_created': _userCreated,
      };

  List<ModuleModel> get modules => _modules;
  String get roleType => _roleType;
  int? get updatedTime => _updatedTime;
  String get id => _id;
  int? get createdTime => _createdTime;
  String get name => _name;
  String get userUpdated => _userUpdated;
  String get userCreated => _userCreated;
}

class EditRoleModel extends EditBaseModel {
  String id = '';
  String roleType = '';
  String name = '';
  List<EditModuleModel> modules = [];

  EditRoleModel.fromModel(RoleModel? model) {
    name = model?.name ?? '';
    roleType = model?.roleType ?? '';
    modules =
        model?.modules.map((e) => EditModuleModel.fromModel(e)).toList() ?? [];
  }

  Map<String, dynamic> toCreateJson() => {
        'modules': modules.map((e) {
          return e.toCreateJson();
        }).toList(),
        'role_type': roleType,
        'name': name,
      };

  Map<String, dynamic> toEditJson() => {
        'modules': modules.map((e) {
          return e.toEditJson();
        }).toList(),
        'role_type': roleType,
        'name': name,
      };
}

class ListRoleModel extends BaseModel {
  List<RoleModel> _data = [];

  ListRoleModel.listDynamic(List<dynamic> list) {
    List<RoleModel> tmp = [];
    for (int i = 0; i < list.length; i++) {
      var result = BaseModel.fromJson<RoleModel>(list[i]);
      tmp.add(result);
    }
    _data = tmp;
  }

  List<RoleModel> get records => _data;
}

class RoleListModel extends BaseModel {
  List<RoleModel> _data = [];
  Paging _metaData = Paging.fromJson({});

  RoleListModel.fromJson(Map<String, dynamic> parsedJson) {
    List<RoleModel> tmp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      var result = BaseModel.fromJson<RoleModel>(parsedJson['data'][i]);
      tmp.add(result);
    }
    _data = tmp;
    _metaData = Paging.fromJson(parsedJson['meta_data']);
  }

  List<RoleModel> get records => _data;
  Paging get meta => _metaData;
}
