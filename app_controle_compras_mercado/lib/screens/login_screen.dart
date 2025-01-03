import 'package:app_controle_compras_mercado/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              cursorColor: Colors.purple,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira um email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              obscureText: true,
              cursorColor: Colors.purple,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira uma senha';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                ),
                const Text('Manter Conectado'),
              ],
            ),
            const SizedBox(height: 35),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(), 
                    ),
                  );
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const CircularProgressIndicator();
                } else if(state is AuthFailure) {
                }
                return ElevatedButton(
                  onPressed: () {
                    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Por favor, preencha todos os campos')),
                      );
                      return;
                    }
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    BlocProvider.of<AuthBloc>(context).add(
                      LoginRequested(email, password, _rememberMe, context),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    foregroundColor: Colors.white, 
                    backgroundColor:  Colors.deepPurple,
                  ),
                  child: const Text('Login'),
                );
              },
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cadastro');
              },
              child: const Text('Não possui uma conta? Cadastre-se'),
            ),
          ],
        ),
      ),
    );
  }
}
