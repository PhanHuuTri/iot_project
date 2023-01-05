import 'package:validators/validators.dart';
import 'package:web_iot/routes/route_names.dart';
import '../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordForm extends StatefulWidget {
  final AuthenticationState state;

  const ForgotPasswordForm({Key? key, required this.state}) : super(key: key);
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  String? _errorMessage = '';
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: AuthenticationBlocController().authenticationBloc,
      listener: (context, state) {
        if (state is AuthenticationFailure) {
          _showError(state.errorCode);
        } else if (state is ResetPasswordState) {
          navigateTo(resetPasswordRoute);
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
                      Container(
                        constraints: const BoxConstraints(minHeight: 144),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Center(
                                child: TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  autofillHints: const [AutofillHints.email],
                                  decoration: InputDecoration(
                                    prefixIcon: textFieldIcon(
                                      icon: Icons.person_outline_rounded,
                                    ),
                                    hintText:
                                        ScreenUtil.t(I18nKey.emailGetPassword),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        value.trim().isEmpty) {
                                      return ValidatorText.empty(
                                          fieldName:
                                              ScreenUtil.t(I18nKey.email)!);
                                    }
                                    if (!isEmail(value.trim())) {
                                      return ValidatorText.invalidFormat(
                                          fieldName:
                                              ScreenUtil.t(I18nKey.email)!);
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    emailController.text = newValue!;
                                  },
                                  onFieldSubmitted: (value) =>
                                      _forgotPassword(),
                                ),
                              ),
                            ),
                            _buildErrorMessage(),
                          ],
                        ),
                      ),
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
                                  ScreenUtil.t(I18nKey.send)!,
                                  style: TextStyle(
                                      color: Theme.of(context).backgroundColor),
                                ),
                          onPressed: _forgotPassword,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: InkWell(
                          child: Center(
                              child: Text(
                            ScreenUtil.t(I18nKey.backToSignIn)!,
                            style: TextStyle(
                              color: AppColor.authColor,
                            ),
                          )),
                          onTap: () {
                            navigateTo(authenticationRoute);
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

  _forgotPassword() {
    setState(() {
      _errorMessage = '';
    });
    if (widget.state is AuthenticationLoading) return;
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      if (widget.state is AuthenticationFailure) {
        AuthenticationBlocController().authenticationBloc.add(GetLastAccount());
      }
      AuthenticationBlocController().authenticationBloc.add(
            ForgotPassword(email: emailController.text),
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
