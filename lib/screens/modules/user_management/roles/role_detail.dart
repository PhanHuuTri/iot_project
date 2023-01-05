import 'package:flutter/material.dart';
import 'package:web_iot/main.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import '../../../../core/modules/user_management/blocs/role/role_bloc.dart';
import '../../../../core/modules/user_management/models/module_model.dart';
import '../../../../core/modules/user_management/models/role_model.dart';

class RoleDetail extends StatefulWidget {
  final RoleBloc roleBloc;
  final RoleModel? roleModel;
  final String route;
  const RoleDetail({
    Key? key,
    required this.roleBloc,
    this.roleModel,
    required this.route,
  }) : super(key: key);

  @override
  _RoleDetailState createState() => _RoleDetailState();
}

class _RoleDetailState extends State<RoleDetail> {
  final _formKey = GlobalKey<FormState>();
  EditRoleModel editModel = EditRoleModel.fromModel(null);
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  String _errorMessage = '';
  bool _processing = false;

  @override
  void initState() {
    JTToast.init(context);
    if (widget.roleModel != null) {
      editModel = EditRoleModel.fromModel(widget.roleModel);
    }
    super.initState();
  }

  final List<String> displayModules = [
    ScreenUtil.t(I18nKey.userManagement)!,
    ScreenUtil.t(I18nKey.smartParking)!,
    ScreenUtil.t(I18nKey.faceRecognition)!,
  ];
  RolePermissions rolePermissions = RolePermissions.admin;
  List<EditModuleModel> emptyPermissions = [];
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      const double _commonPadding = 16;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 8, 0, 7),
              child: SizedBox(
                height: 34,
                child: InkWell(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(19, 0, 13, 0),
                          child: Icon(
                            Icons.arrow_back,
                          ),
                        ),
                        Center(
                          child: Text(
                            ScreenUtil.t(I18nKey.back)!,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _goBack()),
              ),
            ),
            Card(
              color: AppColor.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Form(
                  autovalidateMode: _autovalidate,
                  key: _formKey,
                  onChanged: () {
                    final isValid = _formKey.currentState!.validate();
                    if (_isValid != isValid) {
                      setState(() {
                        _isValid = isValid;
                      });
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _renderError(
                          commonPadding: _commonPadding,
                        ),
                      ),
                      _renderContent(
                        commonPadding: _commonPadding,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Layout
  Widget _renderContent({
    required double commonPadding,
  }) {
    final normalStyle = Theme.of(context).textTheme.bodyText1;
    return StreamBuilder(
        stream: widget.roleBloc.allModule,
        builder: (context, AsyncSnapshot<ModuleListModel> snapshot) {
          if (snapshot.hasData) {
            final modules = snapshot.data?.records.reversed.toList();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: commonPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 305,
                    height: !_isValid ? 47 + 22 : 47,
                    child: JTTitleTextFormField(
                      decoration: InputDecoration(
                        hintText: ScreenUtil.t(I18nKey.roleName),
                        hintStyle: TextStyle(color: AppColor.subTitle),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColor.dividerColor),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      initialValue: editModel.name,
                      style: normalStyle,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return ValidatorText.empty(
                              fieldName: ScreenUtil.t(I18nKey.roleName)!);
                        } else if (value.trim().length > 500) {
                          return ValidatorText.moreThan(
                            fieldName: ScreenUtil.t(I18nKey.roleName)!,
                            moreThan: 500,
                          );
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _errorMessage = '';
                        });
                      },
                      onSaved: (value) => editModel.name = value!.trim(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32, bottom: 20),
                    child: Text(
                      ScreenUtil.t(I18nKey.permission)!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                  LayoutBuilder(builder: (context, size) {
                    if (editModel.roleType.isEmpty) {
                      editModel.roleType = rolePermissions.name;
                    }
                    switch (editModel.roleType) {
                      case 'admin':
                        rolePermissions = RolePermissions.admin;
                        break;
                      case 'security':
                        rolePermissions = RolePermissions.security;
                        break;
                      case 'user':
                        rolePermissions = RolePermissions.user;
                        break;
                      default:
                        rolePermissions = RolePermissions.admin;
                    }

                    return SizedBox(
                      width: size.maxWidth,
                      child: Wrap(
                        spacing: 32.0,
                        runSpacing: 16.0,
                        children: [
                          if (widget.roleModel != null)
                            SizedBox(
                              height: 20,
                              child: radioTile(
                                index: 0,
                                groupValue: rolePermissions,
                                title: _displayRoleName(editModel.roleType),
                                titleStyle: normalStyle,
                              ),
                            ),
                          if (widget.roleModel == null)
                            for (var i = 0; i < 3; i++)
                              SizedBox(
                                height: 20,
                                child: radioTile(
                                  index: i,
                                  groupValue: rolePermissions,
                                  title: _displayRoles(i),
                                  titleStyle: normalStyle,
                                  onChanged: (RolePermissions? value) {
                                    setState(() {
                                      emptyPermissions.clear();
                                      editModel.modules.clear();
                                      rolePermissions = value!;
                                      editModel.roleType = rolePermissions.name;
                                      for (var module in modules!) {
                                        final editModule =
                                            EditModuleModel.fromModel(module);
                                        if (_getPermissions(module.permissions)
                                            .isEmpty) {
                                          emptyPermissions.add(editModule);
                                        } else {
                                          if (emptyPermissions.isNotEmpty) {
                                            emptyPermissions.removeWhere(
                                                (e) => e.id == module.id);
                                          }
                                        }
                                      }
                                    });
                                  },
                                ),
                              ),
                        ],
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 32, bottom: 16),
                    child: Text(
                      ScreenUtil.t(I18nKey.module)!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                  LayoutBuilder(builder: (context, size) {
                    if (modules != null) {
                      modules.removeWhere((e) => e.permissions.where((p) {
                            if (editModel.roleType ==
                                RolePermissions.admin.name) {
                              return p.admin == true;
                            } else if (editModel.roleType ==
                                RolePermissions.security.name) {
                              return p.security == true;
                            } else {
                              return p.user == true;
                            }
                          }).isEmpty);
                    }
                    return SizedBox(
                      width: size.maxWidth,
                      child: Wrap(
                        spacing: 32.0,
                        runSpacing: 16.0,
                        children: [
                          if (modules != null)
                            for (var module in modules)
                              LayoutBuilder(
                                builder: (context, size) {
                                  final selectedModule =
                                      EditModuleModel.fromModel(module);
                                  final isCheck = editModel.modules
                                      .where((e) => e.id == module.id)
                                      .isNotEmpty;

                                  return SizedBox(
                                    height: 20,
                                    child: checkboxTile(
                                      initialValue: isCheck,
                                      title: _displayModules(module.name),
                                      titleStyle: normalStyle,
                                      onChanged: (newValue) {
                                        setState(() {
                                          if (isCheck) {
                                            editModel.modules.removeWhere(
                                                (e) => e.id == module.id);
                                            if (emptyPermissions.isNotEmpty) {
                                              emptyPermissions.removeWhere(
                                                  (e) => e.id == module.id);
                                            }
                                          } else {
                                            _arrangeSelectedModules(
                                              selectedModule: selectedModule,
                                              modules: modules,
                                            );
                                            if (_getPermissions(
                                                    module.permissions)
                                                .isEmpty) {
                                              emptyPermissions
                                                  .add(selectedModule);
                                            } else {
                                              if (emptyPermissions.isNotEmpty) {
                                                emptyPermissions.removeWhere(
                                                    (e) => e.id == module.id);
                                              }
                                            }
                                          }
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                        ],
                      ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 32, bottom: 8),
                    child: Text(
                      ScreenUtil.t(I18nKey.enablePermissions)!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                  LayoutBuilder(builder: (context, size) {
                    final noData = editModel.modules
                            .where((e) => emptyPermissions.contains(e))
                            .length ==
                        editModel.modules.length;
                    return SizedBox(
                      width: size.maxWidth,
                      child: editModel.modules.isNotEmpty
                          ? noData
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    ScreenUtil.t(I18nKey.noData)!,
                                    style:
                                        TextStyle(color: AppColor.dividerColor),
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var m in editModel.modules)
                                      _buildPermissions(
                                        permissions: _getPermissions(modules!
                                            .where((e) => e.id == m.id)
                                            .first
                                            .permissions),
                                        module: m,
                                        titleStyle: normalStyle,
                                      ),
                                  ],
                                )
                          : Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                ScreenUtil.t(I18nKey.selectedOneModule)!,
                                style: TextStyle(color: AppColor.dividerColor),
                              ),
                            ),
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: _buildActions(),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: JTCircularProgressIndicator(
                  size: 24,
                  strokeWidth: 2.0,
                  color: Theme.of(context).textTheme.button!.color!,
                ),
              ),
            );
          }
        });
  }

  Widget checkboxTile({
    required bool initialValue,
    required String title,
    TextStyle? titleStyle,
    Function(bool?)? onChanged,
    bool titleOnLeft = true,
  }) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (titleOnLeft)
            Text(
              title,
              style: const TextStyle(color: AppColor.black),
            ),
          Checkbox(
            splashRadius: 0,
            hoverColor: Colors.transparent,
            activeColor: AppColor.primary,
            value: initialValue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(width: 1),
            onChanged: onChanged,
          ),
          if (!titleOnLeft)
            Text(
              title,
              style: const TextStyle(color: AppColor.black),
            ),
        ],
      ),
      onTap: () {
        onChanged!(!initialValue);
      },
    );
  }

  Widget radioTile({
    required int index,
    required RolePermissions groupValue,
    required String title,
    TextStyle? titleStyle,
    Function(RolePermissions?)? onChanged,
  }) {
    late RolePermissions value;
    if (index == 0) {
      value = RolePermissions.admin;
    } else if (index == 1) {
      value = RolePermissions.security;
    } else {
      value = RolePermissions.user;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(color: AppColor.black),
        ),
        Radio<RolePermissions>(
          value: value,
          activeColor: AppColor.primary,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildPermissions({
    required List<PermissionModel> permissions,
    required EditModuleModel module,
    TextStyle? titleStyle,
  }) {
    return permissions.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayModules(module.name),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColor.dividerColor,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var p in permissions)
                      LayoutBuilder(builder: (context, size) {
                        final ischeck = module.permissions
                            .where((e) => e.permissionCode == p.permissionCode)
                            .isNotEmpty;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: 20,
                            width: size.maxWidth / 2,
                            child: checkboxTile(
                              titleOnLeft: false,
                              initialValue: ischeck,
                              title: _displayPermissions(p.permissionCode),
                              titleStyle: titleStyle,
                              onChanged: (newValue) {
                                setState(() {
                                  if (ischeck) {
                                    module.permissions.removeWhere((e) =>
                                        e.permissionCode == p.permissionCode);
                                  } else {
                                    module.permissions.add(p);
                                  }
                                });
                              },
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  List<PermissionModel> _getPermissions(List<PermissionModel> permissions) {
    final List<PermissionModel> enablePermissions = [];
    if (editModel.roleType == 'admin') {
      enablePermissions
          .addAll(permissions.where((p) => p.admin == true).toList());
    }
    if (editModel.roleType == 'security') {
      enablePermissions
          .addAll(permissions.where((p) => p.security == true).toList());
    }
    if (editModel.roleType == 'user') {
      enablePermissions
          .addAll(permissions.where((p) => p.user == true).toList());
    }

    return enablePermissions;
  }

  Widget _buildActions() {
    return Row(
      children: [
        SizedBox(
          height: 36,
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                ScreenUtil.t(I18nKey.saveChange)!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white),
              ),
            ),
            onPressed: _processing
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (widget.roleModel == null) {
                        _createModel(
                          editModel: editModel,
                        );
                      } else {
                        _confirmEdit(
                          editModel: editModel,
                        );
                      }
                    } else {
                      setState(() {
                        _autovalidate = AutovalidateMode.onUserInteraction;
                      });
                    }
                  },
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          height: 36,
          child: TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).errorColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                ScreenUtil.t(I18nKey.cancel)!,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white),
              ),
            ),
            onPressed: () => _goBack(),
          ),
        ),
      ],
    );
  }

  _arrangeSelectedModules({
    required EditModuleModel selectedModule,
    required List<ModuleModel> modules,
  }) {
    editModel.modules.add(selectedModule);
    final selectedModules = modules
        .where((m) => editModel.modules.where((e) => e.id == m.id).isNotEmpty)
        .toList();

    for (var s in selectedModules) {
      if (editModel.modules.where((e) => e.id == s.id).isNotEmpty) {
        final selectedPermissions =
            editModel.modules.where((e) => e.id == s.id).first.permissions;
        editModel.modules.removeWhere((((e) => e.id == s.id)));
        editModel.modules.add(EditModuleModel.fromModel(s));
        editModel.modules.last.permissions = selectedPermissions;
      } else {
        editModel.modules.add(EditModuleModel.fromModel(s));
      }
    }
  }

  String _displayModules(String moduleName) {
    if (moduleName == 'USER_MANAGEMENT') {
      return ScreenUtil.t(I18nKey.userManagement)!;
    }
    if (moduleName == 'SMART_PARKING') {
      return ScreenUtil.t(I18nKey.smartParking)!;
    }
    if (moduleName == 'FACE_RECOGNITION') {
      return ScreenUtil.t(I18nKey.faceRecognition)!;
    } else {
      return '';
    }
  }

  String _displayRoles(int index) {
    if (index == 0) {
      return ScreenUtil.t(I18nKey.admin)!;
    }
    if (index == 1) {
      return ScreenUtil.t(I18nKey.security)!;
    }
    if (index == 2) {
      return ScreenUtil.t(I18nKey.user)!;
    } else {
      return '';
    }
  }

  String _displayRoleName(String role) {
    if (role == 'admin') {
      return ScreenUtil.t(I18nKey.admin)!;
    }
    if (role == 'security') {
      return ScreenUtil.t(I18nKey.security)!;
    }
    if (role == 'user') {
      return ScreenUtil.t(I18nKey.user)!;
    } else {
      return '';
    }
  }

  String _displayPermissions(String permissionCode) {
    if (permissionCode == 'OZTOMb') {
      return ScreenUtil.t(I18nKey.allRole)!;
    } else if (permissionCode == 'wXEh5Q') {
      return ScreenUtil.t(I18nKey.userManage)!;
    } else if (permissionCode == '7UPcFY') {
      return ScreenUtil.t(I18nKey.roleManage)!;
    } else if (permissionCode == 'sPfd75') {
      return ScreenUtil.t(I18nKey.allRole)!;
    } else if (permissionCode == 'Rnc37D') {
      return ScreenUtil.t(I18nKey.receiveNoti)!;
    } else if (permissionCode == 'C4bNhz') {
      return ScreenUtil.t(I18nKey.exportFile)!;
    } else if (permissionCode == 'TppwEW') {
      return ScreenUtil.t(I18nKey.viewEmptySlot)!;
    } else if (permissionCode == 'Qh0Uu4') {
      return ScreenUtil.t(I18nKey.allRole)!;
    } else if (permissionCode == 'rdjk59') {
      return ScreenUtil.t(I18nKey.receiveNoti)!;
    } else if (permissionCode == '0dfpDX') {
      return ScreenUtil.t(I18nKey.viewEventHistory)!;
    } else if (permissionCode == '2jga5O') {
      return ScreenUtil.t(I18nKey.controlDevice)!;
    } else if (permissionCode == 'dbGQsA') {
      return ScreenUtil.t(I18nKey.viewRooms)!;
    } else {
      return '';
    }
  }

  Widget _renderError({
    required double commonPadding,
  }) {
    if (_errorMessage.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: commonPadding),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: Theme.of(context).errorColor,
              width: 1,
            ),
          ),
          child: Padding(
            child: Text(
              _errorMessage,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).errorColor),
            ),
            padding: EdgeInsets.all(commonPadding),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  // Actions
  _confirmEdit({required EditRoleModel editModel}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final route = widget.roleModel != null
            ? widget.route + '/' + widget.roleModel!.id
            : widget.route;
        if (checkRoute(route) != true) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
        return AlertDialog(
          title: Text(ScreenUtil.t(I18nKey.confirm)! + '!'),
          titleTextStyle: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Colors.black),
          content: Text(
            ScreenUtil.t(I18nKey.confirmEditRole)!,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: [
            SizedBox(
              height: 36,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).errorColor),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    ScreenUtil.t(I18nKey.cancel)!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.white),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            SizedBox(
              height: 36,
              child: TextButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    ScreenUtil.t(I18nKey.yes)!,
                  ),
                ),
                onPressed: () => _editModel(
                  editModel: editModel,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _goBack() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final route = widget.roleModel != null
            ? widget.route + '/' + widget.roleModel!.id
            : widget.route;
        if (checkRoute(route) != true) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
        return AlertDialog(
          title: Text(ScreenUtil.t(I18nKey.confirm)! + '!'),
          titleTextStyle: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Colors.black),
          content: Text(
            ScreenUtil.t(I18nKey.confirmContent)!,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: [
            SizedBox(
              height: 36,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).errorColor),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    ScreenUtil.t(I18nKey.cancel)!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.white),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            SizedBox(
              height: 36,
              child: TextButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    ScreenUtil.t(I18nKey.yes)!,
                  ),
                ),
                onPressed: () => navigateTo(roleRoute),
              ),
            ),
          ],
        );
      },
    );
  }

  _createModel({
    required EditRoleModel editModel,
  }) async {
    setState(() {
      _processing = true;
    });
    widget.roleBloc.createObject(editModel: editModel).then(
      (value) async {
        navigateTo(roleRoute);
        await Future.delayed(const Duration(milliseconds: 400));
        JTToast.successToast(message: ScreenUtil.t(I18nKey.updateSuccess)!);
      },
    ).onError((ApiError error, stackTrace) {
      setState(() {
        _processing = false;
        _errorMessage = showError(error.errorCode, context);
      });
    }).catchError(
      (error, stackTrace) {
        setState(() {
          _processing = false;
          logDebug(error);
          _errorMessage = error.toString();
        });
      },
    );
  }

  _editModel({
    required EditRoleModel editModel,
  }) async {
    setState(() {
      _processing = true;
    });
    widget.roleBloc
        .editObject(editModel: editModel, id: widget.roleModel!.id)
        .then(
      (value) async {
        navigateTo(roleRoute);
        await Future.delayed(const Duration(milliseconds: 400));
        JTToast.successToast(message: ScreenUtil.t(I18nKey.updateSuccess)!);
      },
    ).onError((ApiError error, stackTrace) {
      setState(() {
        _processing = false;
        _errorMessage = showError(error.errorCode, context);
      });
    }).catchError(
      (error, stackTrace) {
        setState(() {
          _processing = false;
          _errorMessage = error.toString();
        });
      },
    );
  }
}
