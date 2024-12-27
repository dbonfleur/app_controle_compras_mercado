import 'dart:convert';

import 'package:crypto/crypto.dart';

class User {
  final int? id;
  final String nome;
  final String senha;

  User({
    this.id,
    required this.nome,
    required this.senha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'senha': senha,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      nome: map['nome'],
      senha: map['senha'],
    );
  }

  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}