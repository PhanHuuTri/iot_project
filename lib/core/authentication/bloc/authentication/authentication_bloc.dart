import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_iot/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../modules/user_management/blocs/account/account_bloc.dart';
import '../../../modules/user_management/models/account_model.dart';
import '../../models/token.dart';
import '../../models/user_data.dart';
import '../../resources/authentication_repository.dart';
import 'authentication_bloc_public.dart';
import 'dart:convert' as convert;

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial());
  final AuthenticationRepository authenticationService =
      AuthenticationRepository();
  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    final SharedPreferences sharedPreferences = await prefs;
    if (event is AppLoadedup) {
      yield* _mapAppSignUpLoadedState(event);
    }

    if (event is UserSignUp) {
      yield* _mapUserSignUpToState(event);
    }

    if (event is UserLogin) {
      yield* _mapUserLoginState(event);
    }

    if (event is ResetPassword) {
      try {
        final data = await authenticationService.resetPassword(
          event.email,
          event.password,
          event.resetToken,
        );
        if (data is ApiResponse) {
          if (data.error == null) {
            sharedPreferences.remove('forgot_password_email');
            yield ForgotPasswordState();
          } else {
            yield AuthenticationFailure(
              message: data.error!.errorMessage,
              errorCode: data.error!.errorCode,
            );
          }
        } else {
          if (data["error_message"] == null) {
            yield ForgotPasswordState();
          } else {
            yield AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            );
          }
        }
      } on Error catch (e) {
        yield AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        );
      }
    }

    if (event is ForgotPassword) {
      try {
        final data = await authenticationService.forgotPassword(event.email);
        if (data is ApiResponse) {
          if (data.error == null) {
            sharedPreferences.setString('forgot_password_email', event.email);
            yield ResetPasswordState();
          } else {
            yield AuthenticationFailure(
              message: data.error!.errorMessage,
              errorCode: data.error!.errorCode,
            );
          }
        } else {
          if (data["error_message"] == null) {
            yield ResetPasswordState();
          } else {
            yield AuthenticationFailure(
              message: data["error_message"],
              errorCode: data["error_code"].toString(),
            );
          }
        }
      } on Error catch (e) {
        yield AuthenticationFailure(
          message: e.toString(),
          errorCode: '',
        );
      }
    }

    if (event is UserLanguage) {
      yield* _mapUserLanguageState(event);
    }

    if (event is UserLogOut) {
      await authenticationService.signOut({'fcmToken': currentFcmToken});
      _cleanupCache();
      yield UserLogoutState();
    }
    if (event is GetUserData) {
      final token = sharedPreferences.getString('authtoken');
      if (token == null || token.isEmpty) {
        _cleanupCache();
        yield AuthenticationStart();
      } else {
        yield* _mapGetUserDataState(event, token);
      }
    }

    if (event is TokenExpired) {
      _cleanupCache();
      yield UserTokenExpired();
    }

    if (event is GetLastAccount) {
      final username = sharedPreferences.getString('last_username') ?? '';
      final keepSession = sharedPreferences.getBool('keep_session') ?? false;
      final forgotPasswordEmail =
          sharedPreferences.getString('forgot_password_email') ?? '';
      yield LoginLastAccount(
        username: username,
        isKeepSession: keepSession,
        forgotPasswordEmail: forgotPasswordEmail,
      );
    }
  }

  Stream<AuthenticationState> _mapAppSignUpLoadedState(
      AppLoadedup event) async* {
    yield AuthenticationLoading();
    try {
      final SharedPreferences sharedPreferences = await prefs;
      if (sharedPreferences.getString('authtoken') != null) {
        yield AppAutheticated();
      } else {
        yield AuthenticationStart();
      }
    } on Error catch (e) {
      yield AuthenticationFailure(
        message: e.toString(),
        errorCode: '',
      );
    }
  }

  Stream<AuthenticationState> _mapUserLanguageState(UserLanguage event) async* {
    yield AuthenticationLoading();
    try {
      final SharedPreferences sharedPreferences = await prefs;
      if (sharedPreferences.getString('authtoken') != null) {
        sharedPreferences.setString('last_lang', event.lang);
        yield AppAutheticated();
      } else {
        yield AuthenticationStart();
      }
    } on Error catch (e) {
      yield AuthenticationFailure(
        message: e.toString(),
        errorCode: '',
      );
    }
  }

  Stream<AuthenticationState> _mapUserSignUpToState(UserSignUp event) async* {
    final SharedPreferences sharedPreferences = await prefs;
    yield AuthenticationLoading();
    try {
      final data = await authenticationService.signUpWithEmailAndPassword(
          event.email, event.password);

      if (data["error"] == null) {
        final currentUser = UserData.fromJson(data);
        if (currentUser.id > 0) {
          sharedPreferences.setString('authtoken', currentUser.token);
          yield AppAutheticated();
        } else {
          yield AuthenticationNotAuthenticated();
        }
      } else {
        yield AuthenticationFailure(
          message: data["error_message"],
          errorCode: data["error_code"].toString(),
        );
      }
    } on Error catch (e) {
      yield AuthenticationFailure(
        message: e.toString(),
        errorCode: '',
      );
    }
  }

  Stream<AuthenticationState> _mapUserLoginState(UserLogin event) async* {
    final SharedPreferences sharedPreferences = await prefs;
    yield AuthenticationLoading();
    try {
      final data = await authenticationService.loginWithEmailAndPassword(
        event.email,
        event.password,
        event.isMobile,
      );
      if (data["error_message"] == null) {
        final currentUser = Token.fromJson(data);
        if (currentUser.id.isNotEmpty) {
          final _now = DateTime.now().millisecondsSinceEpoch;
          sharedPreferences.setString('authtoken', currentUser.token);
          sharedPreferences.setString('last_username', event.email);
          sharedPreferences.setString('last_userpassword', event.password);
          sharedPreferences.setBool('keep_session', event.keepSession);
          sharedPreferences.setInt('login_time', _now);
          yield AppAutheticated();
        } else {
          yield AuthenticationNotAuthenticated();
        }
      } else {
        yield AuthenticationFailure(
          message: data["error_message"],
          errorCode: data["error_code"].toString(),
          
        );
      }
    } on Error catch (e) {
      yield AuthenticationFailure(
        message: e.toString(),
        errorCode: '',
      );
    }
  }

  Stream<AuthenticationState> _mapGetUserDataState(
      GetUserData event, String id) async* {
    final SharedPreferences sharedPreferences = await prefs;
    await sharedPreferences.reload();
    // Expire local if the time is over 24h
    final _keepSesstion = sharedPreferences.getBool('keep_session') ?? false;
    var _isExpired = false;
    if (!_keepSesstion) {
      final _loginTime = sharedPreferences.getInt('login_time');
      const _aDay = 24 * 60 * 60 * 1000;
      if (_loginTime == null) {
        _isExpired = true;
      } else if (DateTime.now().millisecondsSinceEpoch - _loginTime > _aDay) {
        _isExpired = true;
      }
    }
    if (_isExpired) {
      authenticationService.signOut({'fcmToken': currentFcmToken});
      _cleanupCache();
      yield UserTokenExpired();
    } else {
      final userJson = sharedPreferences.getString('userJson');
      if (userJson != null && userJson.isNotEmpty) {
        try {
          Map<String, dynamic> json = convert.jsonDecode(userJson);
          final account = AccountModel.fromJson(json);
          account.password =
              sharedPreferences.getString('last_userpassword') ?? '';
          final lang = sharedPreferences.getString('last_lang') ?? 'vi';
          yield SetUserData(currentUser: account, currentLang: lang);
          return;
          // ignore: empty_catches
        } on Error {}
      }
      final account = await AccountBloc().fetchDataById('me');
      // ignore: unnecessary_null_comparison
      if (account == null) {
        _cleanupCache();
        yield UserTokenExpired();
      } else {
        final json = account.toJson();
        final jsonStr = convert.jsonEncode(json);
        sharedPreferences.setString('userJson', jsonStr);
        account.password =
            sharedPreferences.getString('last_userpassword') ?? '';
        final lang = sharedPreferences.getString('last_lang') ?? 'vi';
        yield SetUserData(currentUser: account, currentLang: lang);
      }
    }
  }

  _cleanupCache() async {
    final SharedPreferences sharedPreferences = await prefs;
    sharedPreferences.remove('authtoken');
    sharedPreferences.remove('userJson');
    sharedPreferences.remove('login_time');
    sharedPreferences.remove('last_lang');
  }
}
