import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart' as user_model;
import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';

part 'user_state.dart';
part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<CreateUser>((event, emit) async {
      emit(UserLoading());
      final user = event.user;
      final userMap = {
        'id': user.id,
        'email': user.email,
        'nome': user.nome,
        'imagemUrl': user.imagemUrl,
      };
      await userRepository.createUser(userMap);
      emit(UserCreated(id: user.id!));
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
  }
}