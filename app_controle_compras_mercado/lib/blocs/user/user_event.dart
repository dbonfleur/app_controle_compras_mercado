part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserSignInWithGoogle extends UserEvent {}

class CreateUser extends UserEvent {
  final User user;

  const CreateUser(this.user);

  @override
  List<Object> get props => [user];
}

class LoadUser extends UserEvent {
  final int userId;

  const LoadUser(this.userId);

  @override
  List<Object> get props => [userId];
}

class SignInUser extends UserEvent {
  final String email;
  final String password;

  const SignInUser(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class UpdateUserImage extends UserEvent {
  final String imageBase64;

  const UpdateUserImage(this.imageBase64);

  @override
  List<Object> get props => [imageBase64];
}

class UpdateUserPassword extends UserEvent {
  final String newPassword;
  final String oldPassword;

  const UpdateUserPassword(this.newPassword, this.oldPassword);

  @override
  List<Object> get props => [newPassword, oldPassword];
}

class LogoutUserEvent extends UserEvent {}