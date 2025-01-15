part of 'compra_bloc.dart';

abstract class CompraState extends Equatable {
  const CompraState();

  @override
  List<Object> get props => [];
}

class CompraInitial extends CompraState {}

class CompraLoading extends CompraState {}

class CompraLoaded extends CompraState {
  final List<Compra> compras;

  const CompraLoaded(this.compras);

  @override
  List<Object> get props => [compras];
}

class CompraError extends CompraState {
  final String message;

  const CompraError(this.message);

  @override
  List<Object> get props => [message];
}