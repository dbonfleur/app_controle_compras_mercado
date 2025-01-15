part of 'produto_bloc.dart';

abstract class ProdutoEvent extends Equatable {
  const ProdutoEvent();

  @override
  List<Object> get props => [];
}

class LoadProdutos extends ProdutoEvent {}

class AddProduto extends ProdutoEvent {
  final Produto produto;

  const AddProduto(this.produto);

  @override
  List<Object> get props => [produto];
}