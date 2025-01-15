part of 'compra_bloc.dart';

abstract class CompraEvent extends Equatable {
  const CompraEvent();

  @override
  List<Object> get props => [];
}

class LoadCompras extends CompraEvent {}

class AddCompra extends CompraEvent {
  final Compra compra;
  final List<CompraProduto> compraProdutos;

  const AddCompra(this.compra, this.compraProdutos);

  @override
  List<Object> get props => [compra, compraProdutos];
}