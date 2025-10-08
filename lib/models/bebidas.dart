class Drink {
  final int? idDrink;
  final String nome;
  final String categoria;
  final String descricao;
  final double valor;
  final double quantidade;
  final String? imagemUrl;


  Drink({
    this.idDrink,
    required this.nome,
    required this.categoria,
    required this.descricao,
    required this.valor,
    required this.quantidade,
    this.imagemUrl,
  });

  factory Drink.fromJson(Map<String, dynamic> json){
    return Drink(
      idDrink: json['idProduto'],
      nome: json['nome'],
      categoria: json['categoria'],
      descricao: json['descricao'],
      valor: json['valor'],
      quantidade: json['quantidade'],
      imagemUrl: json['imagemUrl'],

      );
  }
}

