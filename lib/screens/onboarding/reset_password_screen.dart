import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_browser_detect/web_browser_detect.dart';
import 'package:web_iot/routes/route_names.dart';
import '../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final tokenController = TextEditingController();
  final passwordController = TextEditingController();
  bool _passwordSecure = true;
  String? _errorMessage = '';
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  bool browser = false;
  String email = '';

  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(GetLastAccount());
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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Theme.of(context).toggleableActiveColor.withOpacity(0.2),
              BlendMode.overlay,
            ),
            image: const AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    constraints:
                        const BoxConstraints(maxWidth: 458, maxHeight: 400),
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.shadow,
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                          child: Text(
                            ScreenUtil.t(I18nKey.resetPassword)!,
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildContent(),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: AuthenticationBlocController().authenticationBloc,
      listener: (context, state) {
        if (state is AuthenticationFailure) {
          _showError(state.errorCode);
        } else if (state is LoginLastAccount) {
          setState(() {
            email = state.forgotPasswordEmail!;
          });
        } else if (state is ForgotPasswordState) {
          navigateTo(authenticationRoute);
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
                        child: Row(
                          children: [
                            Text(ScreenUtil.t(I18nKey.resetContent)! + ' '),
                            Text(
                              email,
                              style: TextStyle(color: AppColor.toastShadow),
                            ),
                          ],
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
                            hintText: ScreenUtil.t(I18nKey.newPassword),
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
                          onFieldSubmitted: (value) => _resetPassword(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: TextFormField(
                          controller: tokenController,
                          decoration: InputDecoration(
                            hintText: ScreenUtil.t(I18nKey.resetId),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ValidatorText.empty(
                                  fieldName: ScreenUtil.t(I18nKey.resetId)!);
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            tokenController.text = newValue!;
                          },
                          onFieldSubmitted: (value) => _resetPassword(),
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
                          child: Text(
                            ScreenUtil.t(I18nKey.resetPassword)!,
                            style: TextStyle(
                                color: Theme.of(context).backgroundColor),
                          ),
                          onPressed: _resetPassword,
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

  _resetPassword() {
    setState(() {
      _errorMessage = '';
    });
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      AuthenticationBlocController().authenticationBloc.add(GetLastAccount());
      AuthenticationBlocController().authenticationBloc.add(
            ResetPassword(
              email: email,
              password: passwordController.text,
              resetToken: tokenController.text,
            ),
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
