part of 'categoria_bloc.dart';

abstract class CategoriaEvent extends Equatable {
  const CategoriaEvent();

  @override
  List<Object> get props => [];
}

class LoadCategorias extends CategoriaEvent {}

class AddCategoria extends CategoriaEvent {
  final Categoria categoria;

  const AddCategoria(this.categoria);

  @override
  List<Object> get props => [categoria];
}