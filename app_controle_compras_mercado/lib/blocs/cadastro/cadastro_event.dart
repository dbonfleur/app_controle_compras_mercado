part of 'cadastro_bloc.dart';

abstract class CadastroEvent extends Equatable {
  const CadastroEvent();

  @override
  List<Object> get props => [];
}

class CadastroUser extends CadastroEvent {
  final String nome;
  final String email;
  final String senha;
  final File? imagem;
  final BuildContext context;

  const CadastroUser({
    required this.nome,
    required this.email,
    required this.senha,
    this.imagem,
    required this.context,
  });
}