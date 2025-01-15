import '../models/categoria_model.dart';
import '../services/database_helper.dart';

class CategoriaRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<int> createCategoria(Categoria categoria) async {
    final db = await _databaseHelper.db;
    return await db.insert('categorias', categoria.toJson());
  }

  Future<List<Categoria>> getCategorias() async {
    final db = await _databaseHelper.db;
    final List<Map<String, dynamic>> maps = await db.query('categorias');
    return List.generate(maps.length, (i) {
      return Categoria.fromMap(maps[i]);
    });
  }
}