import '../models/compra_model.dart';
import '../models/compra_produto_model.dart';
import '../services/database_helper.dart';

class CompraRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> createCompra(Compra compra, List<CompraProduto> compraProdutos) async {
    final db = await _databaseHelper.db;
    final compraId = await db.insert('compras', compra.toMap());
    for (var compraProduto in compraProdutos) {
      await db.insert('compraProduto', compraProduto.toMap());
    }
    return compraId;
  }

  Future<List<Compra>> getCompras() async {
    final db = await _databaseHelper.db;
    final List<Map<String, dynamic>> maps = await db.query('compras');
    return List.generate(maps.length, (i) {
      return Compra.fromMap(maps[i]);
    });
  }
}