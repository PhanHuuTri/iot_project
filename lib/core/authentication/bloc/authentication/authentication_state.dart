import 'package:equatable/equatable.dart';
import 'package:web_iot/screens/modules/healthy_check/tab_healthycheck/healthy_list.dart';
import '../../../modules/healthycheck/models/healthy_model.dart';
import '../../../modules/user_management/models/account_model.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AppAutheticated extends AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationStart extends AuthenticationState {}

class UserLogoutState extends AuthenticationState {}

class ResetPasswordState extends AuthenticationState {}

class ForgotPasswordState extends AuthenticationState {}

class UserTokenExpired extends AuthenticationState {}

class SetUserData extends AuthenticationState {
  final AccountModel currentUser;
  final String currentLang;

  const SetUserData({required this.currentUser, required this.currentLang});

  @override
  List<Object> get props => [currentUser, currentLang];
}

class AuthenticationNotAuthenticated extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  final String message;
  final String errorCode;

  const AuthenticationFailure({
    required this.message,
    required this.errorCode,
  });

  @override
  List<Object> get props => [message, errorCode];
}

class LoginLastAccount extends AuthenticationState {
  final String username;
  final bool isKeepSession;
  final String? forgotPasswordEmail;

  const LoginLastAccount({
    required this.username,
    required this.isKeepSession,
    this.forgotPasswordEmail,
  });

  @override
  List<Object> get props => [username, isKeepSession, forgotPasswordEmail!];
}
class SetHeathyData extends AuthenticationState {
  final HealthylModel currentUser;
  final String currentLang;

  const SetHeathyData({required this.currentUser, required this.currentLang});

  @override
  List<Object> get props => [currentUser, currentLang];
}
