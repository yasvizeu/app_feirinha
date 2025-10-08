import 'package:app_feirinha/models/produto.dart';
import 'package:app_feirinha/service/produto_service.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
late Future<List<Produto>> futureProdutos;  // ← aqui foi implementado


 @override
  void initState() {
    super.initState();
    futureProdutos = ProdutoService().fetchProdutos();
  }

 // Função para separar os produtos por categoria
  Map<String, List<Produto>> agruparProdutosPorCategoria(List<Produto> produtos) {
    Map<String, List<Produto>> categorias = {};
    for (var produto in produtos) {
      if (!categorias.containsKey(produto.categoria)) {
        categorias[produto.categoria] = [];
      }
      categorias[produto.categoria]!.add(produto);
    }
    return categorias;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos da Feirinha'),
      ),
      body: FutureBuilder<List<Produto>>(
        future: futureProdutos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar produtos'));
          } else if (snapshot.hasData) {
            Map<String, List<Produto>> produtosPorCategoria = agruparProdutosPorCategoria(snapshot.data!);


            return ListView(
              children: produtosPorCategoria.keys.map((String categoria) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        categoria,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      children: produtosPorCategoria[categoria]!.map((Produto produto) {
                        return Card(
                          child: ListTile(
                            leading: Image.network(produto.imagemUrl), // Exibe a imagem do produto
                            title: Text(produto.nome),
                            subtitle: Text('Preço: R\$${produto.preco.toStringAsFixed(2)}'),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              }).toList(),
            );
          } else {
            return Center(child: Text('Nenhum produto encontrado'));
          }
        },
      ),
    );
  }
}
