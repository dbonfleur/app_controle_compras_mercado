part of 'cadastro_bloc.dart';

abstract class CadastroState extends Equatable {
  const CadastroState();

  @override
  List<Object> get props => [];
}

class CadastroInitial extends CadastroState {}

class CadastroLoading extends CadastroState {}

class CadastroSuccess extends CadastroState {}

class CadastroFailure extends CadastroState {
  final String message;

  const CadastroFailure(this.message);

  @override
  List<Object> get props => [message];
}