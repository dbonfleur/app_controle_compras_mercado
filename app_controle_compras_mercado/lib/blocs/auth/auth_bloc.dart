import 'package:app_controle_compras_mercado/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';
import '../user/user_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;
  
  AuthBloc(this._userRepository) : super(AuthInitial()) { 
    on<LoginRequested>(_onLoginRequested);
    on<CheckLoginStatus>(_onCheckLoginStatus);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _userRepository.signInWithEmail(event.email, event.password);
      if(user != null) {
        if(event.rememberMe) {
          BlocProvider.of<UserBloc>(event.context).add(LoadUser(user.id!));
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', event.email);
          await prefs.setBool('isLogged', true);
        } else {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('email');
          await prefs.remove('isLogged');
        }
        emit(AuthSuccess(user: user));
      } 
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }

  Future<void> _onCheckLoginStatus(CheckLoginStatus event, Emitter<AuthState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isLogged = prefs.getBool('isLogged') ?? false;

    if(isLogged) {
      final email = prefs.getString('email');
      if(email != null) {
        final user = await _userRepository.getUserByEmail(email);
        emit(AuthSuccess(user: user!));
      } else {
        emit(AuthInitial());
      }
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('isLogged');
    emit(AuthInitial());
  }
}