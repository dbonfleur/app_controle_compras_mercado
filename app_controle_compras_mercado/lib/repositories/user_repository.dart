import 'package:sqflite/sqflite.dart';

import '../models/user_model.dart' as user_model;
import '../models/user_model.dart';
import '../services/database_helper.dart';

class UserRepository {
  final DatabaseHelper _database;

  UserRepository(this._database);

  Future<Database> get database async {
    return _database.db;
  }

  Future<int> createUser(User user) async {
    final db = await database;
    final id = await db.insert('users', user.toMap());
    return id;
  }

  Future<user_model.User?> getUserByEmail(String email) async {
    final db = await database;

    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return user_model.User.fromMap(maps.first);
    }
    
    return null;
  }

  Future<user_model.User?> signInWithEmail(String email, String password) async {
    final db = await database;

    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, user_model.User.hashPassword(password)],
    );

    if (maps.isNotEmpty) {
      return user_model.User.fromMap(maps.first);
    }
    
    return null;
  }
}