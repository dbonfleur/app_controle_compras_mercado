import 'package:sqflite/sqflite.dart';

import '../models/user_model.dart';
import '../services/database_helper.dart';

class UserRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<Database> get database async {
    return _databaseHelper.db;
  }

  Future<int> createUser(User user) async {
    final db = await database;
    final id = await db.insert('users', user.toMap());
    return id;
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;

    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    
    return null;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    final db = await database;
  
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, User.hashPassword(password)],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    
    return null;
  }

  Future<User?> getUserById(int id) async {
    final db = await database;

    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    
    return null;
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }
}