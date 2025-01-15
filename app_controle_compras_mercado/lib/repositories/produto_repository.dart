import '../models/produto_model.dart';
import '../services/database_helper.dart';

class ProdutoRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> createProduto(Produto produto) async {
    final db = await _databaseHelper.db;
    return await db.insert('produtos', produto.toMap());
  }

  Future<List<Produto>> getProdutos() async {
    final db = await _databaseHelper.db;
    final List<Map<String, dynamic>> maps = await db.query('produtos');
    return List.generate(maps.length, (i) {
      return Produto.fromMap(maps[i]);
    });
  }
}