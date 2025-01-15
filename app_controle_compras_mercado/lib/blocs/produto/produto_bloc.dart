import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/produto_model.dart';
import '../../repositories/produto_repository.dart';

part 'produto_event.dart';
part 'produto_state.dart';

class ProdutoBloc extends Bloc<ProdutoEvent, ProdutoState> {
  final ProdutoRepository produtoRepository;

  ProdutoBloc(this.produtoRepository) : super(ProdutoInitial()) {
    on<LoadProdutos>(_onLoadProdutos);
    on<AddProduto>(_onAddProduto);
  }

  Future<void> _onLoadProdutos(LoadProdutos event, Emitter<ProdutoState> emit) async {
    emit(ProdutoLoading());
    try {
      final produtos = await produtoRepository.getProdutos();
      emit(ProdutoLoaded(produtos));
    } catch (e) {
      emit(ProdutoError(e.toString()));
    }
  }

  Future<void> _onAddProduto(AddProduto event, Emitter<ProdutoState> emit) async {
    try {
      await produtoRepository.createProduto(event.produto);
      final produtos = await produtoRepository.getProdutos();
      emit(ProdutoLoaded(produtos));
    } catch (e) {
      emit(ProdutoError(e.toString()));
    }
  }
}