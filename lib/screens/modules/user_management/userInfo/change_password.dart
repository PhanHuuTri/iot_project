import 'package:flutter/material.dart';
import 'package:web_browser_detect/web_browser_detect.dart';
import '../../../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import '../../../../core/modules/user_management/blocs/account/account_bloc.dart';
import '../../../../core/modules/user_management/models/account_model.dart';
import '../../../../main.dart';
import '../../../../widgets/debouncer/debouncer.dart';
import '../../../../widgets/joytech_components/joytech_components.dart';

class ChangePassword extends StatefulWidget {
  final AccountModel currentUser;
  const ChangePassword({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final checkController = TextEditingController();
  final _key = GlobalKey<FormState>();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  final _accountBloc = AccountBloc();
  late Debouncer _debouncer;
  String _errorMessage = '';
  bool browser = false;
  bool _oldPasswordSecure = true;
  bool _newPasswordSecure = true;
  bool _checkPasswordSecure = true;

  @override
  void initState() {
    _debouncer = Debouncer(delayTime: const Duration(milliseconds: 500));
    if (Browser.detectOrNull() != null) {
      final browserAgent = Browser.detectOrNull()!.browserAgent.toString();
      if (browserAgent.contains('Edge') == true ||
          browserAgent.contains('Safari') == true) {
        browser = true;
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _accountBloc.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double _commonPadding = 16;
    const double _horizontalPadding = _commonPadding * 2;
    const double _dialogWidth = 500.0;
    final normalStyle = Theme.of(context).textTheme.bodyText1;

    return LayoutBuilder(builder: (context, size) {
      return AlertDialog(
        scrollable: true,
        title: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  _horizontalPadding, 32, _horizontalPadding, 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ScreenUtil.t(I18nKey.changePassword)!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
        titleTextStyle: Theme.of(context).textTheme.headline4,
        titlePadding: EdgeInsets.zero,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: _horizontalPadding),
        content: SizedBox(
          width: _dialogWidth,
          child: Form(
            autovalidateMode: _autovalidate,
            key: _key,
            child: Column(
              children: [
                _buildErrorMessage(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: JTTitleTextFormField(
                    controller: oldPasswordController,
                    style: normalStyle,
                    obscureText: _oldPasswordSecure,
                    autofillHints: browser
                        ? [AutofillHints.nameSuffix]
                        : [AutofillHints.password],
                    decoration: InputDecoration(
                      hintText: ScreenUtil.t(I18nKey.oldPassword),
                      suffixIcon: ButtonTheme(
                        minWidth: 30,
                        height: 30,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          child: Icon(
                            _oldPasswordSecure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Theme.of(context).hintColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _oldPasswordSecure = !_oldPasswordSecure;
                            });
                          },
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return ValidatorText.empty(
                            fieldName: ScreenUtil.t(I18nKey.oldPassword)!);
                      }
                      if (value.trim() != widget.currentUser.password) {
                        return ScreenUtil.t(I18nKey.incorrectPassword)!;
                      }
                      return null;
                    },
                    onSaved: (value) =>
                        oldPasswordController.text = value!.trim(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: JTTitleTextFormField(
                    controller: newPasswordController,
                    style: normalStyle,
                    obscureText: _newPasswordSecure,
                    autofillHints: browser
                        ? [AutofillHints.nameSuffix]
                        : [AutofillHints.password],
                    decoration: InputDecoration(
                      hintText: ScreenUtil.t(I18nKey.newPassword),
                      suffixIcon: ButtonTheme(
                        minWidth: 30,
                        height: 30,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          child: Icon(
                            _newPasswordSecure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Theme.of(context).hintColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _newPasswordSecure = !_newPasswordSecure;
                            });
                          },
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return ValidatorText.empty(
                            fieldName: ScreenUtil.t(I18nKey.newPassword)!);
                      } else if (value.trim().length > 50) {
                        return ValidatorText.moreThan(
                          fieldName: ScreenUtil.t(I18nKey.newPassword)!,
                          moreThan: 50,
                        );
                      } else if (oldPasswordController.text ==
                          newPasswordController.text) {
                        return ScreenUtil.t(
                            I18nKey.newPasswordIsTheSameAsYourOldPassword)!;
                      } else if (value.trim().length < 6) {
                        return ValidatorText.atLeast(
                          fieldName: ScreenUtil.t(I18nKey.newPassword)!,
                          atLeast: 6,
                        );
                      }
                      return null;
                    },
                    onSaved: (value) =>
                        newPasswordController.text = value!.trim(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: JTTitleTextFormField(
                    controller: checkController,
                    style: normalStyle,
                    obscureText: _checkPasswordSecure,
                    autofillHints: browser
                        ? [AutofillHints.nameSuffix]
                        : [AutofillHints.password],
                    decoration: InputDecoration(
                      hintText: ScreenUtil.t(I18nKey.reEnterNewPassword),
                      suffixIcon: ButtonTheme(
                        minWidth: 30,
                        height: 30,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.transparent,
                          ),
                          child: Icon(
                            _checkPasswordSecure
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Theme.of(context).hintColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _checkPasswordSecure = !_checkPasswordSecure;
                            });
                          },
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return ValidatorText.empty(
                            fieldName: ScreenUtil.t(I18nKey.field)!);
                      } else if (value.trim().length > 50) {
                        return ValidatorText.moreThan(
                          fieldName: ScreenUtil.t(I18nKey.field)!,
                          moreThan: 50,
                        );
                      } else if (checkController.text !=
                          newPasswordController.text) {
                        return ScreenUtil.t(I18nKey.passwordDoesNotMatch)!;
                      }
                      return null;
                    },
                    onSaved: (value) => checkController.text = value!.trim(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
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
          const SizedBox(width: 16),
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
              onPressed: () async {
                if (_key.currentState!.validate()) {
                  _key.currentState!.save();
                  _returnToLogin(
                    oldPass: oldPasswordController.text,
                    newPass: newPasswordController.text,
                  );
                } else {
                  setState(() {
                    _autovalidate = AutovalidateMode.onUserInteraction;
                  });
                }
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildErrorMessage() {
    return _errorMessage.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
                minHeight: 40,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(
                    color: Theme.of(context).errorColor,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10.0),
                  child: Text(
                    _errorMessage,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).errorColor),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  _returnToLogin({required String oldPass, required String newPass}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(ScreenUtil.t(I18nKey.updatePassSuccess)!),
          titleTextStyle: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(color: Colors.black),
          content: Text(
            ScreenUtil.t(I18nKey.pleaseLoginAgain)!,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: [
            Center(
              child: SizedBox(
                height: 36,
                child: TextButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      ScreenUtil.t(I18nKey.ok)!,
                    ),
                  ),
                  onPressed: () => _changePass(
                    oldPass: oldPass,
                    newPass: newPass,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _changePass({required String oldPass, required String newPass}) {
    _accountBloc
        .userChangePassword(
          params: {
            'password': oldPass,
            'newPassword': newPass,
          },
        )
        .then((value) => _debouncer.debounce(afterDuration: () {
              showNoti = false;
              AuthenticationBlocController()
                  .authenticationBloc
                  .add(UserLogOut());
            }))
        .onError((ApiError error, stackTrace) {
          setState(() {
            _errorMessage = showError(error.errorCode, context);
          });
        })
        .catchError((error, stackTrace) {
          setState(() {
            _errorMessage = error.toString();
          });
        });
  }
}
