class Compra {
  final int? id;
  final int idUser;
  final DateTime data;
  final double precoTotal;

  Compra({
    this.id,
    required this.idUser,
    required this.data,
    required this.precoTotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUser': idUser,
      'data': data.toIso8601String(),
      'precoTotal': precoTotal,
    };
  }

  static Compra fromMap(Map<String, dynamic> map) {
    return Compra(
      id: map['id'],
      idUser: map['idUser'],
      data: DateTime.parse(map['data']),
      precoTotal: map['precoTotal'],
    );
  }
}