import 'package:validators/validators.dart';
import 'package:web_iot/routes/route_names.dart';

import '../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_browser_detect/web_browser_detect.dart';

class LoginForm extends StatefulWidget {
  final AuthenticationState state;
  const LoginForm({Key? key, required this.state}) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _passwordSecure = true;
  String? _errorMessage = '';
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  bool _isKeepSession = false;
  bool browser = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  @override
  void initState() {
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
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: AuthenticationBlocController().authenticationBloc,
      listener: (context, state) {
        if (state is AuthenticationFailure) {
          _showError(state.errorCode);
        } else if (state is LoginLastAccount) {
          usernameController.text = state.username;
          setState(() {
            _isKeepSession = state.isKeepSession;
          });
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            padding: constraints.maxWidth < 500
                ? EdgeInsets.zero
                : const EdgeInsets.all(30),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Form(
                  autovalidateMode: _autovalidate,
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: TextFormField(
                          controller: usernameController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            prefixIcon: textFieldIcon(
                              icon: Icons.person_outline_rounded,
                            ),
                            hintText: ScreenUtil.t(I18nKey.email),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ValidatorText.empty(
                                fieldName: ScreenUtil.t(I18nKey.email)!,
                              );
                            }
                            if (!isEmail(value.trim())) {
                              return ValidatorText.invalidFormat(
                                  fieldName: ScreenUtil.t(I18nKey.email)!);
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            usernameController.text = newValue!;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: _passwordSecure,
                          autofillHints: browser
                              ? [AutofillHints.nameSuffix]
                              : [AutofillHints.password],
                          decoration: InputDecoration(
                            prefixIcon: textFieldIcon(
                              icon: Icons.lock_outlined,
                            ),
                            hintText: ScreenUtil.t(I18nKey.password),
                            suffixIcon: ButtonTheme(
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
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ValidatorText.empty(
                                  fieldName: ScreenUtil.t(I18nKey.password)!);
                            }
                            if (value.trim().length > 50) {
                              return ValidatorText.moreThan(
                                fieldName: ScreenUtil.t(I18nKey.password)!,
                                moreThan: 50,
                              );
                            }
                            if (value.trim().length < 6) {
                              return ValidatorText.atLeast(
                                fieldName: ScreenUtil.t(I18nKey.password)!,
                                atLeast: 6,
                              );
                            }
                            return null;
                          },
                          onSaved: (newValue) =>
                              passwordController.text = newValue!,
                          onFieldSubmitted: (value) => _login(),
                        ),
                      ),
                      _buildErrorMessage(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            fixedSize: const Size(double.infinity, 54),
                            padding: const EdgeInsets.all(22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            backgroundColor: AppColor.authColor,
                          ),
                          child: widget.state is AuthenticationLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Theme.of(context)
                                        .buttonTheme
                                        .colorScheme!
                                        .background,
                                  ),
                                )
                              : Text(
                                  ScreenUtil.t(I18nKey.signIn)!,
                                  style: TextStyle(
                                      color: Theme.of(context).backgroundColor),
                                ),
                          onPressed: _login,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: InkWell(
                          child: Center(
                              child: Text(
                            ScreenUtil.t(I18nKey.forgotPassword)! + '?',
                            style: TextStyle(
                              color: AppColor.authColor,
                            ),
                          )),
                          onTap: () {
                            navigateTo(forgotPasswordRoute);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget textFieldIcon({required IconData icon}) {
    return SizedBox(
      width: 60,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).iconTheme.color,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Container(
              width: 1,
              height: 18,
              color: Theme.of(context).iconTheme.color,
            ),
          )
        ],
      ),
    );
  }

  _login() {
    if (widget.state is AuthenticationLoading) return;

    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      setState(() {
        _errorMessage = '';
      });

      if (widget.state is AuthenticationFailure) {
        AuthenticationBlocController().authenticationBloc.add(GetLastAccount());
      }
      AuthenticationBlocController().authenticationBloc.add(
            UserLogin(
              email: usernameController.text,
              password: passwordController.text,
              keepSession: _isKeepSession,
              isMobile: false,
            ),
          );
      AuthenticationBlocController().authenticationBloc.add(
            UserLanguage(lang: App.of(context)!.currentLocale.languageCode),
          );
    } else {
      setState(() {
        _autovalidate = AutovalidateMode.onUserInteraction;
      });
    }
  }

  _buildErrorMessage() {
    return _errorMessage != null && _errorMessage!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: double.infinity,
                minHeight: 24,
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
                  child: Text(
                    showError(_errorMessage!, context),
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).errorColor),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  _showError(String errorCode) async {
    setState(() {
      _errorMessage = errorCode;
    });
  }
}
