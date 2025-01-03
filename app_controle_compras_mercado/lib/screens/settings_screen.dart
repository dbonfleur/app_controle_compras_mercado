import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_state.dart';
import '../blocs/user/user_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      final imageBase64 = base64Encode(bytes);

      context.read<UserBloc>().add(UpdateUserImage(imageBase64));
    }
  }

  Future<void> _removeImage(BuildContext context) async {
    context.read<UserBloc>().add(const UpdateUserImage(''));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, stateTheme) {
        return BlocBuilder<UserBloc, UserState>(
          builder: (context, stateUser) {
            if (stateUser is UserLoaded) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: stateUser.user.imagemUrl != null
                                ? MemoryImage(base64Decode(stateUser.user.imagemUrl!))
                                : null,
                            backgroundColor: stateTheme.themeData.appBarTheme.backgroundColor,
                            child: stateUser.user.imagemUrl == null
                                ? const Icon(
                                          Icons.person, 
                                          size: 60,
                                          color: Colors.white,
                                        )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Row(
                              children: [
                                if (stateUser.user.imagemUrl != null)
                                  InkWell(
                                    onTap: () => _removeImage(context),
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
                                const SizedBox(width: 60),
                                InkWell(
                                  onTap: () => _pickImage(context),
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
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          _showChangePasswordDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: stateTheme.themeData.appBarTheme.backgroundColor,
                        ),
                        child: Text('Alterar Senha', style: TextStyle(color: stateTheme.themeData.iconTheme.color)), 
                      ),
                    ],
                  ),
                ),
              );
            } else if (stateUser is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('Erro ao carregar dados do usuário.'));
            }
          },
        );
      }
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController oldPasswordController = TextEditingController();
        final TextEditingController newPasswordController = TextEditingController();
        final TextEditingController confirmPasswordController = TextEditingController();

        return AlertDialog(
          title: const Text('Alterar Senha'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha Antiga',
                ),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nova Senha',
                ),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Nova Senha',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newPasswordController.text == confirmPasswordController.text) {
                  context.read<UserBloc>().add(UpdateUserPassword(
                    oldPasswordController.text,
                    newPasswordController.text,
                  ));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('As senhas não coincidem.')),
                  );
                }
              },
              child: const Text('Alterar'),
            ),
          ],
        );
      },
    );
  }
}