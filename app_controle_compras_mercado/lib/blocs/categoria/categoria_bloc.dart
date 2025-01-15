import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/categoria_model.dart';
import '../../repositories/categoria_repository.dart';

part 'categoria_event.dart';
part 'categoria_state.dart';

class CategoriaBloc extends Bloc<CategoriaEvent, CategoriaState> {
  final CategoriaRepository categoriaRepository;

  CategoriaBloc(this.categoriaRepository) : super(CategoriaInitial()) {
    on<LoadCategorias>(_onLoadCategorias);
    on<AddCategoria>(_onAddCategoria);
    add(LoadCategorias()); 
  }

  Future<void> _onLoadCategorias(LoadCategorias event, Emitter<CategoriaState> emit) async {
    emit(CategoriaLoading());
    try {
      final categorias = await categoriaRepository.getCategorias();
      emit(CategoriaLoaded(categorias));
    } catch (e) {
      emit(CategoriaError(e.toString()));
    }
  }

  Future<void> _onAddCategoria(AddCategoria event, Emitter<CategoriaState> emit) async {
    try {
      final categoriaId = await categoriaRepository.createCategoria(event.categoria);
      Categoria(id: categoriaId, nome: event.categoria.nome);
      final categorias = await categoriaRepository.getCategorias();
      emit(CategoriaLoaded(categorias));
    } catch (e) {
      emit(CategoriaError(e.toString()));
    }
  }
}