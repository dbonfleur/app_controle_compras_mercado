import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  
  DatabaseHelper.internal();
  
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb("compras_mercado.db");
    return _db!;
  }

  Future<Database> _initDb(String filePath) async {
    final databasesPath = await getDatabasesPath();
    final path = databasesPath + filePath;

    return await openDatabase(
      path, 
      version: 2, 
      onCreate: _createDB
    );
  }

  void _createDB(Database db, int version) async {
    const userTable = '''CREATE TABLE User(
                          idUser INTEGER PRIMARY KEY, 
                          nome TEXT NOT NULL,
                          senha TEXT NOT NULL)''';
    
    const compraTable = '''CREATE TABLE Compra(
                          idCompra INTEGER PRIMARY KEY, 
                          idUser INTEGER NOT NULL,
                          data TEXT NOT NULL,
                          precoTotal REAL NOT NULL,
                          FOREIGN KEY (idUser) REFERENCES User(idUser)''';
    
    const produtoTable = '''CREATE TABLE Produto(
                          idProduto INTEGER PRIMARY KEY, 
                          nome TEXT NOT NULL,
                          imagemUrl TEXT)''';
    
    const compraProdutoTable = '''CREATE TABLE CompraProduto(
                          idCompraProduto INTEGER PRIMARY KEY, 
                          idCompra INTEGER NOT NULL,
                          idProduto INTEGER NOT NULL,
                          qtdeProduto INTEGER NOT NULL,
                          valorUnitario REAL NOT NULL,
                          FOREIGN KEY (idCompra) REFERENCES Compra(idCompra),
                          FOREIGN KEY (idProduto) REFERENCES Produto(idProduto)''';  
    
    await db.execute(userTable);
    await db.execute(compraTable);
    await db.execute(produtoTable);
    await db.execute(compraProdutoTable);
  }
}