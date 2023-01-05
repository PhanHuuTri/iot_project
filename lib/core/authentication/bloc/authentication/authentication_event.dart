import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

// Fired just after the app is loaded
class AppLoadedup extends AuthenticationEvent {}

class UserLogOut extends AuthenticationEvent {}

class GetUserData extends AuthenticationEvent {}

class UserSignUp extends AuthenticationEvent {
  final String email;
  final String password;

  const UserSignUp({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class UserLogin extends AuthenticationEvent {
  final String email;
  final String password;
  final bool keepSession;
  final bool isMobile;

  const UserLogin({
    required this.email,
    required this.password,
    required this.keepSession,
    required this.isMobile,
  });

  @override
  List<Object> get props => [email, password, keepSession,isMobile];
}

class ForgotPassword extends AuthenticationEvent {
  final String email;

  const ForgotPassword({required this.email});

  @override
  List<Object> get props => [email];
}

class ResetPassword extends AuthenticationEvent {
  final String email;
  final String password;
  final String resetToken;

  const ResetPassword({
    required this.email,
    required this.password,
    required this.resetToken,
  });

  @override
  List<Object> get props => [email, password, resetToken];
}

class UserLanguage extends AuthenticationEvent {
  final String lang;

  const UserLanguage({
    required this.lang,
  });

  @override
  List<Object> get props => [lang];
}

class TokenExpired extends AuthenticationEvent {}

class GetLastAccount extends AuthenticationEvent {}
