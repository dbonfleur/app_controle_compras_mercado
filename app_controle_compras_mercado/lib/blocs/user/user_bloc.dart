import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';

part 'user_state.dart';
part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<CreateUser>((event, emit) async {
      emit(UserLoading());
      final id = await userRepository.createUser(event.user);
      emit(UserCreated(id: id));
    });

    on<SignInUser>((event, emit) async {
      emit(UserLoading());
      final user = await userRepository.signInWithEmail(event.email, event.password);
      if (user != null) {
        emit(UserSignedIn(user: user));
      } else {
        emit(UserError('Usuário não encontrado'));
      }
    });

    on<LoadUser>((event, emit) async {
      emit(UserLoading());
      final user = await userRepository.getUserById(event.userId);
      if (user != null) {
        emit(UserLoaded(user: user));
      } else {
        emit(UserError('Usuário não encontrado'));
      }
    });

    on<LogoutUserEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      bool rememberMe = prefs.getBool('rememberMe') ?? false;
      if (!rememberMe) {
        await prefs.clear(); 
      }
      emit(UserInitial());
    });

    on<UpdateUserImage>((event, emit) async {
      var user = (state as UserLoaded).user;
      if(event.imageBase64.isEmpty) {
        user = (state as UserLoaded).user.copyWithImagemUrl(null);
      } else {
        user = (state as UserLoaded).user.copyWithImagemUrl(event.imageBase64);
      }
      await userRepository.updateUser(user);
      emit(UserLoaded(user: user));
    });

    on<UpdateUserPassword>((event, emit) async {
      final user = (state as UserLoaded).user;
      final hashedOldPassword = User.hashPassword(event.oldPassword);
      
      if (user.senha == hashedOldPassword) {
        final updatedUser = user
            .copyWithPassword(User.hashPassword(event.newPassword));
        await userRepository.updateUser(updatedUser);
        emit(UserLoaded(user: updatedUser));
      } else {
        emit(const UserError('Senha antiga não confere'));
      }
    });
  }
}