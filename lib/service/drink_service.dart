import 'dart:convert';   // para conversão do JSON
import 'package:app_feirinha/models/bebidas.dart';
import 'package:http/http.dart' as http;   // pacote http para conexão
import 'package:app_feirinha/models/produto.dart'; // Importa o modelo Produto(veja aqui qual o nome de seu projeto que está diferente do modelo.
import '../models/bebidas.dart';

class DrinkService {
  static const String baseUrl = 'http://localhost:8089/api';
 
  static Future<List<Drink>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/bebidas'));
   
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Drink.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar produtos: ${response.statusCode}');
    }
  }

}