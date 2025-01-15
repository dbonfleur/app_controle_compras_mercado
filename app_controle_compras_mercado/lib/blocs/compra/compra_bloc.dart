import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/compra_model.dart';
import '../../models/compra_produto_model.dart';
import '../../repositories/compra_repository.dart';

part 'compra_event.dart';
part 'compra_state.dart';

class CompraBloc extends Bloc<CompraEvent, CompraState> {
  final CompraRepository compraRepository;

  CompraBloc(this.compraRepository) : super(CompraInitial()) {
    on<LoadCompras>(_onLoadCompras);
    on<AddCompra>(_onAddCompra);
  }

  Future<void> _onLoadCompras(LoadCompras event, Emitter<CompraState> emit) async {
    emit(CompraLoading());
    try {
      final compras = await compraRepository.getCompras();
      emit(CompraLoaded(compras));
    } catch (e) {
      emit(CompraError(e.toString()));
    }
  }

  Future<void> _onAddCompra(AddCompra event, Emitter<CompraState> emit) async {
    try {
      await compraRepository.createCompra(event.compra, event.compraProdutos);
      final compras = await compraRepository.getCompras();
      emit(CompraLoaded(compras));
    } catch (e) {
      emit(CompraError(e.toString()));
    }
  }
}