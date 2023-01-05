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

class CreateUserDialog extends StatefulWidget {
  final AccountBloc accountBloc;
  final RoleBloc roleBloc;
  final Function() onFetch;
  const CreateUserDialog({
    Key? key,
    required this.accountBloc,
    required this.onFetch,
    required this.roleBloc,
  }) : super(key: key);

  @override
  _CreateUserDialogState createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final double _dialogMaxWidth = 400;
  EditAccountModel editModel = EditAccountModel.fromModel(null);
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  String _errorMessage = '';
  bool _processing = false;
  bool _passwordSecure = true;
  bool browser = false;

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
    editModel.permission = '';
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
                  ScreenUtil.t(I18nKey.createNewAccount)!,
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
                        width: 324,
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
                        width: 324,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: 324,
                        child: _buildInput(
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
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: 324,
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
                          onSaved: (value) =>
                              editModel.password = value!.trim(),
                        ),
                      ),
                    ),
                  ],
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
                      .where((e) => e.roleType == editModel.permission||e.roleType=='security_HealthyCheck')
                      .toList();
                  // for(var ros in enableRole){
                  //   debugPrint('Role'+ros.roleType);
                  // }
                  return enableRole.isNotEmpty
                      ? SizedBox(
                          width: size.maxWidth,
                          child: Wrap(
                            spacing: 16.0,
                            runSpacing: 16.0,
                            children: [
                              for (var role in enableRole)
                                LayoutBuilder(builder: (context, size) {
                                  final isCheck = editModel.roles
                                      .where((e) => e == role.id)
                                      .isNotEmpty;
                                      //debugPrint('RoleID'+role.id);
                                  return Container(
                                    height: 44,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColor.dividerColor),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 4, 0),
                                      child: checkboxTile(
                                        initialValue: isCheck,
                                        title: role.roleType=='security'?role.name:role.name+' HealThy',
                                        titleStyle: normalStyle,
                                        onChanged: (newValue) {
                                          setState(() {
                                            if (isCheck) {
                                              editModel.roles.removeWhere(
                                                  (e) => e == role.id);
                                            } else {
                                              editModel.roles.add(role.id);
                                            }
                                          });
                                        },
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
            side: BorderSide(
              width: 2,
              color: AppColor.dividerColor,
            ),
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

  Widget _buildInput({
    String? initialValue,
    String? hintText,
    String? Function(String?)? validator,
    Function(String?)? onSaved,
    TextInputType? keyboardType,
    bool isPassword = false,
    Iterable<String>? autofillHints,
  }) {
    final normalStyle = Theme.of(context).textTheme.bodyText1;
    final disableStyle = Theme.of(context).textTheme.bodyText2;
    return LayoutBuilder(builder: (context, size) {
      return JTTitleTextFormField(
        titleStyle: disableStyle,
        keyboardType: keyboardType,
        autofillHints: autofillHints,
        obscureText: isPassword ? _passwordSecure : false,
        decoration: InputDecoration(
          fillColor: AppColor.secondaryLight,
          hintText: hintText,
          hintStyle: normalStyle!.copyWith(
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

    return SizedBox(
      height: 48,
      child: JTDropdownButtonFormField<String>(
        defaultValue: '',
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
    // if (permission == 'security_HealthyCheck') {
    //   return ScreenUtil.t(I18nKey.security)!;
    // }
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
                    _createModel(editModel: editModel);
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
  _createModel({
    required EditAccountModel editModel,
  }) async {
    setState(() {
      _processing = true;
    });
    widget.accountBloc.createObject(editModel: editModel).then(
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
          logDebug(error);
          _errorMessage = error.toString();
        });
      },
    );
  }
}
