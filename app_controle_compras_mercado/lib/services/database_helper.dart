import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.internal();
  factory DatabaseHelper() => instance;
  
  DatabaseHelper.internal();
  
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb("compras_mercado.db");
    return _db!;
  }

  Future<Database> _initDb(String filePath) async {
    String path;
    if (kIsWeb) {
      path = filePath;
    } else {
      final databasesPath = await getDatabasesPath();
      path = join(databasesPath, filePath);
    }

    return await openDatabase(
      path, 
      version: 2, 
      onCreate: _createDB
    );
  }

  Future _createDB(Database db, int version) async {
    const userTable = '''CREATE TABLE users(
                          id INTEGER PRIMARY KEY AUTOINCREMENT, 
                          nome TEXT NOT NULL,
                          email TEXT NOT NULL,
                          senha TEXT NOT NULL,
                          imagemUrl TEXT)''';
    
    const compraTable = '''CREATE TABLE compras(
                            id INTEGER PRIMARY KEY AUTOINCREMENT, 
                            idUser INTEGER NOT NULL,
                            data TEXT NOT NULL,
                            precoTotal REAL NOT NULL,
                            FOREIGN KEY (idUser) REFERENCES users(idUser)
                          )''';
    
    const produtoTable = '''CREATE TABLE produtos(
                          id INTEGER PRIMARY KEY AUTOINCREMENT, 
                          nome TEXT NOT NULL,
                          imagemUrl TEXT)''';
    
    const compraProdutoTable = '''CREATE TABLE compraProduto(
                                  id INTEGER PRIMARY KEY AUTOINCREMENT, 
                                  idCompra INTEGER NOT NULL,
                                  idProduto INTEGER NOT NULL,
                                  qtdeProduto INTEGER NOT NULL,
                                  valorUnitario REAL NOT NULL,
                                  FOREIGN KEY (idCompra) REFERENCES compras(idCompra),
                                  FOREIGN KEY (idProduto) REFERENCES produtos(idProduto)
                                )''';  
    
    await db.execute(userTable);
    await db.execute(compraTable);
    await db.execute(produtoTable);
    await db.execute(compraProdutoTable);
  }
}