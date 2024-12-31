import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import '../user/user_bloc.dart';

part 'cadastro_event.dart';
part 'cadastro_state.dart';

class CadastroBloc extends Bloc<CadastroEvent, CadastroState> {
  
  CadastroBloc() : super(CadastroInitial()) {
    on<CadastroUser>(_onCadastroUser);
  }

  Future<void> _onCadastroUser(
    CadastroUser event, 
    Emitter<CadastroState> emit
  ) async {
    emit(CadastroLoading());
    try {
      final userBloc = BlocProvider.of<UserBloc>(event.context);
      
      String? imageBase64;

      if (event.imagem != null) {
        final bytes = await event.imagem!.readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

      final hashPassword = User.hashPassword(event.senha);

      final user = User(
        nome: event.nome,
        email: event.email,
        senha: hashPassword,
        imagemUrl: imageBase64,
      );

      userBloc.add(CreateUser(user));

      emit(CadastroSuccess());
      return;
    } catch (e) {
      emit(CadastroFailure(e.toString()));
    }
  }
}