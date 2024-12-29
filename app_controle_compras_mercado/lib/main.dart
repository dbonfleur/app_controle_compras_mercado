import 'dart:io';

import 'package:app_controle_compras_mercado/blocs/auth/auth_bloc.dart';
import 'package:app_controle_compras_mercado/screens/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'blocs/theme/theme_bloc.dart';
import 'blocs/theme/theme_state.dart';
import 'blocs/user/user_bloc.dart';
import 'repositories/user_repository.dart';
import 'services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(MercadoApp());
}

class MercadoApp extends StatelessWidget {
  final userRepository = UserRepository(DatabaseHelper.instance);
  
  MercadoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: blocProviders, 
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Compras de Mercado',
            debugShowCheckedModeBanner: false,
            theme: state.themeData,
            initialRoute: '/',
            routes: {
              '/': (context) => const LoginScreen()
            },
          );
        },
      ),
    );
  }

  List<SingleChildWidget> get blocProviders {
    return [
      BlocProvider<ThemeBloc>(
        create: (context) => ThemeBloc(),
      ),
      BlocProvider<UserBloc>(
        create: (context) => UserBloc(userRepository),
      ),
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(userRepository),
      ),
    ];
  }
}
