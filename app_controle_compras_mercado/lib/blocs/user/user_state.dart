part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserCreated extends UserState {
  final int id;

  const UserCreated({required this.id});

  @override
  List<Object> get props => [id];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSignedIn extends UserState {
  final user_model.User user;

  const UserSignedIn({required this.user});

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object> get props => [message];
}