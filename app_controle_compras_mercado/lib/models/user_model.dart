import 'dart:convert';

import 'package:crypto/crypto.dart';

class User {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String? imagemUrl;

  User({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.imagemUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'imagemUrl': imagemUrl,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      imagemUrl: map['imagemUrl'],
    );
  }

  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  copyWithEmail(String email) {
    return User(
      id: id,
      nome: nome,
      email: email,
      senha: senha,
      imagemUrl: imagemUrl,
    );
  }
}