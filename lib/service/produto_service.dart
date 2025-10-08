import 'dart:convert';   // para conversão do JSON
import 'package:http/http.dart' as http;   // pacote http para conexão
import 'package:app_feirinha/models/produto.dart'; // Importa o modelo Produto(veja aqui qual o nome de seu projeto que está diferente do modelo.

class ProdutoService {
  final String apiUrl = 'http://localhost:8089/produtos';


  Future<List<Produto>> fetchProdutos() async {
    final response = await http.get(Uri.parse(apiUrl));


    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Produto> produtos = body.map((dynamic item) => Produto.fromJson(item)).toList();
      return produtos;
    } else {
      throw Exception('Erro ao carregar produtos');
    }
  }
}
