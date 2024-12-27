class Produto {
  final int? id;
  final String nome;
  final String? imagemUrl;


  Produto({
    this.id,
    required this.nome,
    this.imagemUrl
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'imagemUrl': imagemUrl
    };
  }

  static Produto fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      imagemUrl: map['imagemUrl']
    );
  }
}