class Produto {
  final int? id;
  final int idCategoria;
  final String nome;
  final String? imagemUrl;
  final double preco;

  Produto({
    this.id,
    required this.nome,
    required this.idCategoria,
    this.imagemUrl,
    required this.preco
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCategoria': idCategoria,
      'nome': nome,
      'imagemUrl': imagemUrl,
      'preco': preco
    };
  }

  static Produto fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      idCategoria: map['idCategoria'],
      imagemUrl: map['imagemUrl'],
      preco: map['preco']
    );
  }
}