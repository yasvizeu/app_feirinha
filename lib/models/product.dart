// lib/models/product.dart
class Product {
  final int? idProduto;
  final String descricao;
  final double valor;
  final String tamanho;
  final int quantidade;
  final String? imagemUrl;


  Product({
    this.idProduto,
    required this.descricao,
    required this.valor,
    required this.tamanho,
    required this.quantidade,
    this.imagemUrl,
  });


// Método para converter o JSON da API para um objeto Produto
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      idProduto: json['idProduto'],
      descricao: json['descricao'],
      valor: json['valor'] is double ? json['valor'] : (json['valor'] as num).toDouble(),
      tamanho: json['tamanho'],
      quantidade: json['quantidade'],

  imagemUrl: json['imagemUrl'],
    );
  }




 
}
