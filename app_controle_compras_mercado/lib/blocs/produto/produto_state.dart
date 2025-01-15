part of 'produto_bloc.dart';

abstract class ProdutoState extends Equatable {
  const ProdutoState();

  @override
  List<Object> get props => [];
}

class ProdutoInitial extends ProdutoState {}

class ProdutoLoading extends ProdutoState {}

class ProdutoLoaded extends ProdutoState {
  final List<Produto> produtos;

  const ProdutoLoaded(this.produtos);

  @override
  List<Object> get props => [produtos];
}

class ProdutoError extends ProdutoState {
  final String message;

  const ProdutoError(this.message);

  @override
  List<Object> get props => [message];
}