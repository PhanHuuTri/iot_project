import 'dart:ui';
import '../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_iot/routes/route_names.dart';
import 'forgot_password_screen.dart';
import 'login_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  final bool isLogin;
  const AuthenticationScreen({Key? key, this.isLogin = true}) : super(key: key);

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool _showLang = false;
  @override
  void initState() {
    AuthenticationBlocController().authenticationBloc.add(AppLoadedup());
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
          child: BlocListener<AuthenticationBloc, AuthenticationState>(
            bloc: AuthenticationBlocController().authenticationBloc,
            listener: (context, state) {
              if (state is AppAutheticated) {
                navigateTo(sideBarRoute);
              }
            },
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              bloc: AuthenticationBlocController().authenticationBloc,
              builder: (BuildContext context, AuthenticationState state) {
                return SafeArea(
                  child: Center(
                    child: Stack(
                      children: [
                        _langField(),
                        Column(
                          children: [
                            const Spacer(),
                            Center(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24),
                                constraints: const BoxConstraints(
                                  maxWidth: 458,
                                  maxHeight: 400,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColor.shadow,
                                      blurRadius: 16,
                                    ),
                                  ],
                                ),
                                child: widget.isLogin
                                    ? _buildForm(
                                        form: LoginForm(state: state),
                                      )
                                    : _buildForm(
                                        form: ForgotPasswordForm(state: state),
                                      ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _buildForm({required Widget form}) {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: Text(
            widget.isLogin
                ? ScreenUtil.t(I18nKey.signInAccount)!
                : ScreenUtil.t(I18nKey.forgotPassword)!,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: form,
        ),
      ],
    );
  }

  Widget _langField() {
    final List<String> languages = [
      ScreenUtil.t(I18nKey.vietnamese)!,
      ScreenUtil.t(I18nKey.english)!,
      // ScreenUtil.t(I18nKey.thai)!,
    ];
    final currentLangIndex =
        supportedLocales.indexOf(App.of(context)!.currentLocale);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 69, 132, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.white.withOpacity(0.7),
                    ),
                    child: InkWell(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.language,
                              size: 20,
                              color: Colors.black,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 11,
                                horizontal: 10,
                              ),
                              child: Text(
                                languages[currentLangIndex],
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ]),
                      onTap: () {
                        setState(() {
                          _showLang = !_showLang;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_showLang)
                    Container(
                      width: 137,
                      height: languages.length * 38.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.white.withOpacity(0.7),
                      ),
                      child: ListView.builder(
                        itemCount: languages.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: Container(
                              height: 38,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: index > 0
                                      ? BorderSide(color: AppColor.dividerColor)
                                      : BorderSide.none,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      languages[index],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    if (currentLangIndex == index)
                                      Icon(
                                        Icons.check,
                                        color: AppColor.authColor,
                                      )
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                App.of(context)!.setLocale(
                                  supportedLocales[index],
                                );
                                _showLang = false;
                              });
                            },
                          );
                        },
                      ),
                    )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
