import 'dart:convert';   // para conversão do JSON
import 'package:http/http.dart' as http;   // pacote http para conexão
import 'package:app_feirinha/models/produto.dart'; // Importa o modelo Produto(veja aqui qual o nome de seu projeto que está diferente do modelo.
import '../models/product.dart';

class ProductService {
  static const String baseUrl = 'http://localhost:8089/api';
 
  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
   
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar produtos: ${response.statusCode}');
    }
  }


}
