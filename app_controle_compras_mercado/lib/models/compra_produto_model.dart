class CompraProduto {
  final int? id;
  final int? idCompra;
  final int idProduto;
  final int qtdeProduto;
  final double valorUnitario;

  CompraProduto({
    this.id,
    this.idCompra,
    required this.idProduto,
    required this.qtdeProduto,
    required this.valorUnitario,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idCompra': idCompra,
      'idProduto': idProduto,
      'qtdeProduto': qtdeProduto,
      'valorUnitario': valorUnitario,
    };
  }

  static CompraProduto fromMap(Map<String, dynamic> map) {
    return CompraProduto(
      id: map['id'],
      idCompra: map['idCompra'],
      idProduto: map['idProduto'],
      qtdeProduto: map['qtdeProduto'],
      valorUnitario: map['valorUnitario'],
    );
  }
}