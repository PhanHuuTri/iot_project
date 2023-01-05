import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:web_browser_detect/web_browser_detect.dart';
import 'package:web_iot/main.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import '../../../../core/modules/user_management/blocs/account/account_bloc.dart';
import '../../../../core/base/blocs/block_state.dart';
import '../../../../core/modules/user_management/blocs/role/role_bloc.dart';
import '../../../../core/modules/user_management/models/account_model.dart';
import '../../../../core/modules/user_management/models/role_model.dart';

class EditUserDialog extends StatefulWidget {
  final AccountBloc accountBloc;
  final RoleBloc roleBloc;
  final Function() onFetch;
  final AccountModel accountModel;
  const EditUserDialog({
    Key? key,
    required this.accountBloc,
    required this.onFetch,
    required this.roleBloc,
    required this.accountModel,
  }) : super(key: key);

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final double _dialogMaxWidth = 400;
  late EditAccountModel editModel;
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  String _errorMessage = '';
  bool _processing = false;
  bool _passwordSecure = true;
  bool browser = false;
  bool _showEditPass = false;
  bool _enableEditRole = false;

  @override
  void initState() {
    JTToast.init(context);
    if (Browser.detectOrNull() != null) {
      final browserAgent = Browser.detectOrNull()!.browserAgent.toString();
      if (browserAgent.contains('Edge') == true ||
          browserAgent.contains('Safari') == true) {
        browser = true;
      }
    }
    editModel = EditAccountModel.fromModel(widget.accountModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      const double _commonPadding = 16;
      const double _horizontalPadding = _commonPadding * 2;
      const double _dialogWidth = 696.0;
      const double _dialogHeight = 416.0;
      return AlertDialog(
        scrollable: true,
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _horizontalPadding,
                vertical: 20,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ScreenUtil.t(I18nKey.editInformation)!,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const Divider(thickness: 0.25, height: 0.25),
          ],
        ),
        titleTextStyle: Theme.of(context).textTheme.headline4,
        titlePadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.only(
          top: _commonPadding,
          bottom: _commonPadding / 2,
        ),
        content: SizedBox(
          width: _dialogWidth,
          height: _dialogHeight,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _renderError(
                    contentWidth: _dialogWidth,
                    commonPadding: _commonPadding,
                  ),
                  _renderContent(
                    contentWidth: _dialogWidth,
                    commonPadding: _commonPadding,
                  ),
                ],
              ),
            ),
          ),
        ),
        actionsPadding: EdgeInsets.zero,
        actions: [
          Padding(
            child: _renderActions(contentWidth: _dialogWidth),
            padding: const EdgeInsets.symmetric(
              horizontal: _commonPadding / 2,
              vertical: _commonPadding,
            ),
          ),
        ],
      );
    });
  }

  // Layout
  _renderContent({
    required double contentWidth,
    required double commonPadding,
  }) {
    final normalStyle = Theme.of(context).textTheme.bodyText1;
    final inputWidth = (contentWidth - 16 * 3) / 2;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: commonPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                ScreenUtil.t(I18nKey.personalInformation)!,
                style: normalStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: contentWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: inputWidth,
                        child: _buildInput(
                          initialValue: editModel.fullName,
                          hintText: ScreenUtil.t(I18nKey.fullName),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return ValidatorText.empty(
                                  fieldName: ScreenUtil.t(I18nKey.fullName)!);
                            } else if (value.trim().length > 50) {
                              return ValidatorText.moreThan(
                                  fieldName: ScreenUtil.t(I18nKey.fullName)!,
                                  moreThan: 50);
                            } else if (value.trim().length < 5) {
                              return ValidatorText.atLeast(
                                fieldName: ScreenUtil.t(I18nKey.fullName)!,
                                atLeast: 5,
                              );
                            }
                            return null;
                          },
                          onSaved: (value) =>
                              editModel.fullName = value!.trim(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: inputWidth,
                        child: _buildInput(
                          initialValue: editModel.phoneNumber,
                          keyboardType: TextInputType.phone,
                          hintText: ScreenUtil.t(I18nKey.phoneNumber),
                          validator: (value) {
                            if (value!.isEmpty || value.trim().isEmpty) {
                              return ValidatorText.empty(
                                  fieldName:
                                      ScreenUtil.t(I18nKey.phoneNumber)!);
                            }
                            String pattern =
                                r'^(\+843|\+845|\+847|\+848|\+849|\+841|03|05|07|08|09|01[2|6|8|9])+([0-9]{8})$';
                            RegExp regExp = RegExp(pattern);
                            if (!regExp.hasMatch(value)) {
                              return ScreenUtil.t(I18nKey.invalidPhoneNumber)!;
                            }
                            return null;
                          },
                          onSaved: (value) {
                            editModel.phoneNumber = value!.trim();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: contentWidth,
                child: _buildInput(
                  initialValue: editModel.address,
                  hintText: ScreenUtil.t(I18nKey.address),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return ValidatorText.empty(
                          fieldName: ScreenUtil.t(I18nKey.address)!);
                    } else if (value.trim().length > 300) {
                      return ValidatorText.moreThan(
                        fieldName: ScreenUtil.t(I18nKey.address)!,
                        moreThan: 300,
                      );
                    } else if (value.trim().length < 5) {
                      return ValidatorText.atLeast(
                        fieldName: ScreenUtil.t(I18nKey.address)!,
                        atLeast: 5,
                      );
                    }
                    return null;
                  },
                  onSaved: (value) => editModel.address = value!.trim(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                ScreenUtil.t(I18nKey.loginInformation)!,
                style: normalStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: contentWidth,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: (contentWidth - 16 * 3) * 3 / 4,
                        child: _buildInput(
                          enabled: false,
                          initialValue: editModel.email,
                          hintText: ScreenUtil.t(I18nKey.email),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return ValidatorText.empty(
                                  fieldName: ScreenUtil.t(I18nKey.email)!);
                            }
                            if (!isEmail(value.trim())) {
                              return ValidatorText.invalidFormat(
                                  fieldName: ScreenUtil.t(I18nKey.email)!);
                            }
                            return null;
                          },
                          onSaved: (value) => editModel.email = value!.trim(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Container(
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: InkWell(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: Text(
                                _showEditPass
                                    ? ScreenUtil.t(I18nKey.cancel)!
                                    : ScreenUtil.t(I18nKey.changePassword)!,
                                style: TextStyle(
                                  color: _showEditPass
                                      ? AppColor.error
                                      : AppColor.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _showEditPass = !_showEditPass;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_showEditPass)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: contentWidth,
                  child: _buildInput(
                    initialValue: editModel.password,
                    hintText: ScreenUtil.t(I18nKey.password),
                    isPassword: true,
                    autofillHints: browser
                        ? [AutofillHints.nameSuffix]
                        : [AutofillHints.password],
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return ValidatorText.empty(
                            fieldName: ScreenUtil.t(I18nKey.password)!);
                      } else if (value.trim().length > 50) {
                        return ValidatorText.moreThan(
                          fieldName: ScreenUtil.t(I18nKey.password)!,
                          moreThan: 50,
                        );
                      } else if (value.trim().length < 6) {
                        return ValidatorText.atLeast(
                          fieldName: ScreenUtil.t(I18nKey.password)!,
                          atLeast: 6,
                        );
                      }
                      return null;
                    },
                    onSaved: (value) => editModel.password = value!.trim(),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                ScreenUtil.t(I18nKey.providePermission)!,
                style: normalStyle,
              ),
            ),
            _buildPermission(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                ScreenUtil.t(I18nKey.role)!,
                style: normalStyle,
              ),
            ),
            editModel.permission.isNotEmpty
                ? _buildRoles()
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      ScreenUtil.t(I18nKey.noData)!,
                      style: TextStyle(color: AppColor.dividerColor),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoles() {
    final normalStyle = Theme.of(context).textTheme.bodyText1;
    return StreamBuilder(
        stream: widget.roleBloc.allRole,
        builder: (context, AsyncSnapshot<ListRoleModel> snapshot) {
          return StreamBuilder(
            stream: widget.roleBloc.allDataState,
            builder: (context, state) {
              if (!state.hasData || state.data == BlocState.fetching) {
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
              } else {
                final roles = snapshot.data!.records;
                return LayoutBuilder(builder: (context, size) {
                  final enableRole = roles
                      .where((e) => e.roleType == editModel.permission || e.roleType == 'security_HealthyCheck')
                      .toList();
                  final selectedRole = [];
                  for (var id in editModel.roles) {
                    if (roles.where((e) => e.id == id).isNotEmpty) {
                      selectedRole.add(roles.firstWhere((e) => e.id == id));
                    }
                  }

                  return enableRole.isNotEmpty
                      ? SizedBox(
                          width: size.maxWidth,
                          child: Wrap(
                            spacing: 16.0,
                            runSpacing: 16.0,
                            children: [
                              if (!_enableEditRole)
                                _editRoleField(
                                    title: ScreenUtil.t(I18nKey.edit)!,
                                    onTap: () {
                                      setState(() {
                                        _enableEditRole = !_enableEditRole;
                                      });
                                    }),
                              for (var role in _enableEditRole
                                  ? enableRole
                                  : selectedRole)
                                LayoutBuilder(builder: (context, size) {
                                  final isCheck = editModel.roles
                                      .where((e) => e == role.id)
                                      .isNotEmpty;

                                  return Container(
                                    height: 44,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColor.dividerColor,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 4, 0),
                                      child: checkboxTile(
                                        isBorder: _enableEditRole,
                                        checkColor: _enableEditRole
                                            ? AppColor.white
                                            : AppColor.primary,
                                        activeColor: _enableEditRole
                                            ? AppColor.primary
                                            : AppColor.white,
                                        initialValue: isCheck,
                                        title: role.roleType=='security'?role.name:role.name+' HealThy',
                                        titleStyle: normalStyle,
                                        onChanged: _enableEditRole
                                            ? (newValue) {
                                                setState(() {
                                                  if (isCheck) {
                                                    editModel.roles.removeWhere(
                                                        (e) => e == role.id);
                                                  } else {
                                                    editModel.roles
                                                        .add(role.id);
                                                  }
                                                });
                                              }
                                            : null,
                                      ),
                                    ),
                                  );
                                }),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            ScreenUtil.t(I18nKey.noData)!,
                            style: TextStyle(color: AppColor.dividerColor),
                          ),
                        );
                });
              }
            },
          );
        });
  }

  Widget _editRoleField({
    required String title,
    Function()? onTap,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.dividerColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Icon(
                  Icons.edit_rounded,
                  color: AppColor.primary,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  color: AppColor.primary,
                ),
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget checkboxTile({
    required bool initialValue,
    required String title,
    TextStyle? titleStyle,
    Function(bool?)? onChanged,
    bool titleOnLeft = true,
    bool isBorder = true,
    Color? activeColor,
    Color? checkColor = AppColor.white,
  }) {
    final side = isBorder
        ? BorderSide(
            width: 2,
            color: AppColor.dividerColor,
          )
        : BorderSide.none;
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
            activeColor: activeColor ?? AppColor.primary,
            checkColor: checkColor,
            value: initialValue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: side,
            onChanged: (value) {
              if (onChanged != null) {
                onChanged(!initialValue);
              }
            },
          ),
          if (!titleOnLeft)
            Text(
              title,
              style: const TextStyle(color: AppColor.black),
            ),
        ],
      ),
      onTap: () {
        if (onChanged != null) {
          onChanged(!initialValue);
        }
      },
    );
  }

  Widget _buildInput({
    String? initialValue,
    String? hintText,
    String? Function(String?)? validator,
    Function(String?)? onSaved,
    TextInputType? keyboardType,
    bool isPassword = false,
    Iterable<String>? autofillHints,
    bool enabled = true,
  }) {
    final normalStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
          color: enabled ? AppColor.black : AppColor.dividerColor,
        );
    final disableStyle = Theme.of(context).textTheme.bodyText2;
    return LayoutBuilder(builder: (context, size) {
      return JTTitleTextFormField(
        enabled: enabled,
        titleStyle: disableStyle,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        obscureText: isPassword ? _passwordSecure : false,
        decoration: InputDecoration(
          fillColor: AppColor.secondaryLight,
          hintText: hintText,
          hintStyle: normalStyle.copyWith(
            color: AppColor.hintColor,
            fontWeight: FontWeight.w400,
          ),
          constraints: const BoxConstraints(minHeight: 48),
          suffixIcon: isPassword
              ? ButtonTheme(
                  minWidth: 30,
                  height: 30,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                    child: Icon(
                      _passwordSecure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Theme.of(context).hintColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordSecure = !_passwordSecure;
                      });
                    },
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.secondaryLight,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        initialValue: initialValue,
        style: normalStyle,
        validator: validator,
        onSaved: onSaved,
      );
    });
  }

  Widget _buildPermission() {
    final permissionList = RolePermissions.values.map((e) => e.name).toList();

    List<Map<String, dynamic>> roleSource = [
      {'name': ScreenUtil.t(I18nKey.pick), 'value': '', 'isDefault': true},
    ];

    for (var permission in permissionList) {
      roleSource.add(
        {'name': _displayPermissions(permission), 'value': permission},
      );
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      child: JTDropdownButtonFormField<String>(
        defaultValue: editModel.permission,
        dataSource: roleSource,
        decoration: InputDecoration(
          fillColor: AppColor.secondaryLight,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColor.secondaryLight,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        onChanged: (newValue) {
          setState(() {
            editModel.permission = newValue;
            editModel.roles.clear();
            isDropDown = false;
          });
        },
        onSaved: (newValue) {
          editModel.permission = newValue!;
          isDropDown = false;
        },
        onTap: () {
          isDropDown = true;
        },
        validator: (value) {
          if (editModel.permission.isEmpty) {
            return ValidatorText.empty(
                fieldName: ScreenUtil.t(I18nKey.permission)!);
          }
          return null;
        },
      ),
    );
  }

  String _displayPermissions(String permission) {
    if (permission == 'admin') {
      return ScreenUtil.t(I18nKey.admin)!;
    }
    if (permission == 'security') {
      return ScreenUtil.t(I18nKey.security)!;
    }
    if (permission == 'user') {
      return ScreenUtil.t(I18nKey.user)!;
    } else {
      return '';
    }
  }

  _renderActions({required double contentWidth}) {
    final children = _actions(contentWidth: contentWidth);
    if (contentWidth >= _dialogMaxWidth) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: children,
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  _actions({required double contentWidth}) {
    return <Widget>[
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
      contentWidth >= _dialogMaxWidth
          ? const SizedBox(width: 16)
          : const SizedBox(),
      SizedBox(
        height: 36,
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          child: _processing
              ? JTCircularProgressIndicator(
                  size: 16,
                  strokeWidth: 2.0,
                  color: Theme.of(context).textTheme.button!.color!,
                )
              : Padding(
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
                    _editModel(
                      editModel: editModel,
                      id: widget.accountModel.id,
                    );
                  } else {
                    setState(() {
                      _autovalidate = AutovalidateMode.onUserInteraction;
                    });
                  }
                },
        ),
      ),
    ];
  }

  _renderError({
    required double contentWidth,
    required double commonPadding,
  }) {
    if (_errorMessage.isNotEmpty) {
      return SizedBox(
        height: 50,
        width: contentWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: commonPadding * 2),
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
        ),
      );
    }
    return const SizedBox();
  }

  // Actions
  _editModel({
    required EditAccountModel editModel,
    required String id,
  }) async {
    setState(() {
      _processing = true;
    });
    widget.accountBloc.editObject(editModel: editModel, id: id).then(
      (value) async {
        Navigator.of(context).pop();
        await Future.delayed(const Duration(milliseconds: 400));
        JTToast.successToast(message: ScreenUtil.t(I18nKey.updateSuccess)!);
        widget.onFetch();
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
