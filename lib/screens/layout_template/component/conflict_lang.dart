import 'dart:ui';
import 'package:web_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_iot/routes/route_names.dart';
import 'package:web_iot/widgets/joytech_components/joytech_components.dart';
import '../../../core/authentication/bloc/authentication/authentication_bloc_public.dart';
import '../../../core/modules/user_management/blocs/account/account_bloc.dart';
import '../../../core/modules/user_management/models/account_model.dart';

class ConflictLang extends StatefulWidget {
  const ConflictLang({Key? key}) : super(key: key);

  @override
  _ConflictLangState createState() => _ConflictLangState();
}

class _ConflictLangState extends State<ConflictLang> {
  late AuthenticationBloc _authenticationBloc;
  Future<AccountModel>? _currentUser;
  final _accountBloc = AccountBloc();
  String _errorMessage = '';

  @override
  void initState() {
    _authenticationBloc = AuthenticationBlocController().authenticationBloc;
    _authenticationBloc.add(AppLoadedup());
    super.initState();
  }

  @override
  void dispose() {
    _accountBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            listener: (BuildContext context, AuthenticationState state) {
              if (state is AppAutheticated) {
                _authenticationBloc.add(GetUserData());
              } else if (state is SetUserData) {
                setState(() {
                  _currentUser = _accountBloc.getProfile().then((value) {
                    value.password = state.currentUser.password;
                    return value;
                  });
                });
              }
            },
            child: FutureBuilder(
              future: _currentUser,
              builder: (
                context,
                AsyncSnapshot<AccountModel> snapshot,
              ) {
                if (snapshot.hasData) {
                  return _buildContent(snapshot);
                }
                return JTCircularProgressIndicator(
                  size: 20,
                  strokeWidth: 1.5,
                  color: Theme.of(context).textTheme.button!.color!,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  _buildContent(AsyncSnapshot<AccountModel> snapshot) {
    ScreenUtil.init(context);
    final List<String> languages = [
      ScreenUtil.t(I18nKey.vietnamese)!,
      ScreenUtil.t(I18nKey.english)!,
      // ScreenUtil.t(I18nKey.thai)!,
    ];
    final appLangIndex =
        supportedLocales.indexOf(App.of(context)!.currentLocale);
    final systemLangIndex = supportedLocales.indexOf(supportedLocales
        .firstWhere((e) => e.languageCode == snapshot.data!.lang));
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(
                  maxWidth: 458,
                  // maxHeight: 400,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.shadow,
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ScreenUtil.t(I18nKey.warning)!,
                          style:
                              Theme.of(context).textTheme.headline5!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ),
                    if (_errorMessage.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: Theme.of(context).errorColor,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _errorMessage,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Theme.of(context).errorColor),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                ScreenUtil.t(I18nKey.currentLanguage)! + ': ',
                              ),
                              Text(
                                languages[appLangIndex],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                ScreenUtil.t(I18nKey.wantToChange)! +
                                    ' ${languages[systemLangIndex]}?',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _actions(snapshot),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _actions(AsyncSnapshot<AccountModel> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          height: 50,
          color: AppColor.authColor,
          child: InkWell(
            child: Center(
              child: Text(
                ScreenUtil.t(I18nKey.confirm)!,
                style: TextStyle(color: Theme.of(context).backgroundColor),
              ),
            ),
            onTap: () {
              if (snapshot.hasData) {
                AuthenticationBlocController().authenticationBloc.add(
                      UserLanguage(lang: snapshot.data!.lang),
                    );
                navigateTo(sideBarRoute);
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Container(
            width: double.infinity,
            height: 50,
            color: Theme.of(context).errorColor,
            child: InkWell(
              child: Center(
                child: Text(
                  ScreenUtil.t(I18nKey.noThanks)!,
                  style: TextStyle(color: Theme.of(context).backgroundColor),
                ),
              ),
              onTap: () {
                if (snapshot.hasData) {
                  final _editModel = EditAccountModel.fromModel(snapshot.data);
                  _editModel.lang = App.of(context)!.currentLocale.languageCode;
                  _changeUserLang(editModel: _editModel);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  _changeUserLang({required EditAccountModel editModel}) {
    _accountBloc.editProfile(editModel: editModel).then(
      (value) {
        AuthenticationBlocController().authenticationBloc.add(
              UserLanguage(lang: value.lang),
            );
        navigateTo(sideBarRoute);
      },
    ).onError((ApiError error, stackTrace) {
      setState(() {
        _errorMessage = showError(error.errorCode, context);
      });
    }).catchError(
      (error, stackTrace) {
        setState(() {
          logDebug(error);
          _errorMessage = error.toString();
        });
      },
    );
  }
}
