part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;
  final BuildContext context;

  const LoginRequested(this.email, this.password, this.rememberMe, this.context);

  @override
  List<Object> get props => [email, password, rememberMe, context];
}

class CheckLoginStatus extends AuthEvent {}

class LogoutRequested extends AuthEvent {}