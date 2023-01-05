import 'package:web_iot/core/modules/user_management/models/module_model.dart';
import 'package:web_iot/main.dart';

import 'role_model.dart';

class AccountModel extends BaseModel {
  final List<ModuleModel> _modules = [];
  final bool _admin;
  final bool _security;
  final bool _superadmin;
  final String _lang;
  final String __id;
  final List<RoleModel> _roles = [];
  final int _createdTime;
  final String _fullName;
  final String _email;
  final String _phoneNumber;
  final String _gender;
  final String _address;
  String _password;

  AccountModel.fromJson(Map<String, dynamic> json)
      : _admin = json['admin'] ?? false,
        _security = json['security'] ?? false,
        _superadmin = json['superadmin'] ?? false,
        _lang = json['lang'] ?? '',
        __id = json['_id'] ?? '',
        _password = '',
        _createdTime = json['created_time'],
        _fullName = json['fullname'] ?? '',
        _email = json['email'] ?? '',
        _phoneNumber = json['phone_number'] ?? '',
        _gender = json['gender'] ?? '',
        _address = json['address'] ?? '' {
    _roles.addAll(BaseModel.mapList<RoleModel>(
      json: json,
      key: 'roles',
    ));
    _modules.addAll(BaseModel.mapList<ModuleModel>(
      json: json,
      key: 'modules',
    ));
  }

  Map<String, dynamic> toJson() => {
        'modules': _modules.map((e) => e.toJson()).toList(),
        'admin': _admin,
        'security': _security,
        'superadmin': _superadmin,
        'lang': _lang,
        '_id': __id,
        'roles': _roles.map((e) => e.toJson()).toList(),
        'created_time': _createdTime,
        'fullname': _fullName,
        'email': _email,
        'phone_number': _phoneNumber,
        'gender': _gender,
        'address': _address,
      };

  List<ModuleModel> get modules => _modules;
  bool get isAdmin => _admin;
  bool get isSecurity => _security;
  bool get isSuperadmin => _superadmin;
  String get lang => _lang;
  String get id => __id;
  List<RoleModel> get roles => _roles;
  int get createdTime => _createdTime;
  String get fullName => _fullName;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get gender => _gender;
  String get address => _address;
  String get password => _password;
  set password(value) {
    _password = value;
  }
}

class EditAccountModel extends EditBaseModel {
  String id = ''; // For editing
  String lang = '';
  String email = '';
  String fullName = '';
  String password = '';
  String address = '';
  String phoneNumber = '';
  String gender = '';
  String permission = '';
  List<String> roles = [];
  bool admin = false;
  bool security = false;

  EditAccountModel.fromModel(AccountModel? account) {
    id = account?.id ?? '';
    lang = account?.lang ?? '';
    email = account?.email ?? '';
    fullName = account?.fullName ?? '';
    password = '';
    address = account?.address ?? '';
    phoneNumber = account?.phoneNumber ?? '';
    gender = account?.gender ?? '';
    permission = account?.isAdmin == true
        ? 'admin'
        : account?.isSecurity == true
            ? 'security'
            : 'user';
    admin = account?.isAdmin ?? false;
    security = account?.isSecurity ?? false;
    roles = account?.roles.map((e) => e.id).toList() ?? [];
  }

  Map<String, dynamic> toEditInfoJson() {
    Map<String, dynamic> params = {
      'admin': admin,
      'fullname': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'address': address,
    };
    if (lang.isNotEmpty) {
      params['lang'] = lang;
    }
    return params;
  }

  Map<String, dynamic> toCreateJson() {
    Map<String, dynamic> params = {
      'fullname': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'address': address,
      'password': password,
    };
    if (permission.isNotEmpty) {
      if (permission == 'admin') {
        params['admin'] = true;
        params['security'] = false;
      }
      if (permission == 'security') {
        params['security'] = true;
        params['admin'] = false;
      }
      if (permission == 'user') {
        params['admin'] = false;
        params['security'] = false;
      }
    }
    if (roles.isNotEmpty) {
      params['roles'] = roles;
    }
    return params;
  }

  Map<String, dynamic> toEditJson() {
    Map<String, dynamic> params = {
      'admin': admin,
      'security': security,
      'fullname': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'gender': gender,
      'address': address,
      'roles': roles,
    };
    if (lang.isNotEmpty) {
      params['lang'] = lang;
    }
    if (password.isNotEmpty) {
      params['password'] = password;
    }
    if (permission.isNotEmpty) {
      if (permission == 'admin') {
        params['admin'] = true;
        params['security'] = false;
      }
      if (permission == 'security') {
        params['security'] = true;
        params['admin'] = false;
      }
      if (permission == 'user') {
        params['admin'] = false;
        params['security'] = false;
      }
    } else {
      params['admin'] = false;
      params['security'] = false;
    }
    return params;
  }
}

class AccountListModel extends BaseModel {
  List<AccountModel> _data = [];
  Paging _metaData = Paging.fromJson({});

  AccountListModel.fromJson(Map<String, dynamic> parsedJson) {
    List<AccountModel> tmp = [];
    for (int i = 0; i < parsedJson['data'].length; i++) {
      var result = BaseModel.fromJson<AccountModel>(parsedJson['data'][i]);
      tmp.add(result);
    }
    _data = tmp;
    _metaData = Paging.fromJson(parsedJson['meta_data']);
  }

  List<AccountModel> get records => _data;
  Paging get meta => _metaData;
}
