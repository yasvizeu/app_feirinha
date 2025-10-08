class Produto {
  final int id;
  final String nome;
  final String categoria;
  final String imagemUrl;
  final double preco;


  Produto({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.imagemUrl,
    required this.preco,
  });


  // Método para converter o JSON da API para um objeto Produto
  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      categoria: json['categoria'],
      imagemUrl: json['imagemUrl'],
      preco: json['preco'].toDouble(),
    );
  }
}
