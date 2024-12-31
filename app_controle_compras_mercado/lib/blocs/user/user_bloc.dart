import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  }
}