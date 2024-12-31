import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/cadastro/cadastro_bloc.dart';
import '../blocs/theme/theme_bloc.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  void _removeImage() {
    setState(() {
      _imageFile = null;
    });
  }

  bool _validateFields() {
    final nome = _nomeController.text;
    final email = _emailController.text;
    final senha = _senhaController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campos obrigatórios não preenchidos')),
      );
      return false;
    }

    if(!email.contains('@') || !email.contains('.com')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-mail inválido')),
      );
      return false;
    }

    if(senha.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha deve ter no mínimo 6 caracteres')),
      );
      return false;
    }

    if(!senha.contains(RegExp(r'[0-9]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha deve conter ao menos um número')),
      );
      return false;
    }

    if(!senha.contains(RegExp(r'[A-Z]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha deve conter ao menos uma letra maiúscula')),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    backgroundColor: _imageFile == null ? BlocProvider.of<ThemeBloc>(context).state.themeData.primaryColor : null,
                    child: _imageFile == null
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      children: [
                        if (_imageFile != null)
                          InkWell(
                            onTap: _removeImage,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.delete,
                                size: 20,
                                color: Colors.white, 
                              ),
                            ),
                          ),
                        const SizedBox(width: 40),
                        InkWell(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add_a_photo,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              cursorColor: BlocProvider.of<ThemeBloc>(context).state.themeData.primaryColor,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              cursorColor: BlocProvider.of<ThemeBloc>(context).state.themeData.primaryColor,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              cursorColor: BlocProvider.of<ThemeBloc>(context).state.themeData.primaryColor,
            ),
            const SizedBox(height: 20),
            BlocConsumer<CadastroBloc, CadastroState>(
              listener: (context, state) {
                if (state is CadastroSuccess) {
                  Navigator.pop(context);
                } else if (state is CadastroFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is CadastroLoading) {
                  return const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    ),
                  );
                }
                return ElevatedButton(
                  onPressed: () {
                    if(!_validateFields()) return;
                    
                    BlocProvider.of<CadastroBloc>(context).add(
                      CadastroUser(
                        nome: _nomeController.text,
                        email: _emailController.text,
                        senha: _senhaController.text,
                        imagem: _imageFile,
                        context: context,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: BlocProvider.of<ThemeBloc>(context).state.themeData.primaryColor,
                  ),
                  child: const Text('Cadastrar'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}