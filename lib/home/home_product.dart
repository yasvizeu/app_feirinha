// lib/screens/products_screen.dart
import 'package:flutter/material.dart';
import '../service/product_service.dart';  // Import do serviço que faz as requisições HTTP
import '../models/product.dart';        // Import do modelo de dados (classe Product)




class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}


class _ProductsScreenState extends State<ProductsScreen> {
  // VARIÁVEIS DE ESTADO
  // Estas variáveis armazenam o estado atual do componente
  List<Product> _products = [];  // Lista que armazenará os produtos da API
  bool _isLoading = false;       // Controla se está carregando (true/false)
  String? _error;               // Armazena mensagem de erro se a requisição falhar


  // initState() - CICLO DE VIDA
  // Método chamado automaticamente quando o widget é criado
  // Ideal para fazer configurações iniciais e carregar dados
  @override
  void initState() {
    super.initState();
    _loadProducts();  // Chama a função para carregar os produtos da API
  }


  // FUNÇÃO ASSÍNCRONA PARA CONSUMIR API
  // async/await permite que operações demoradas não bloqueiem a interface
  Future<void> _loadProducts() async {
    // setState() notifica o Flutter que o estado mudou e a tela deve ser redesenhada
    setState(() {

      _isLoading = true;  // Mostra indicador de carregamento
      _error = null;      // Limpa qualquer erro anterior
    });


    try {
      // CHAMADA HTTP PARA A API
      // await "espera" a resposta da API sem travar a interface
      final products = await ProductService.getProducts();
     
      // Atualiza o estado com os dados recebidos da API
      setState(() {
        _products = products;  // Armazena os produtos na variável de estado
      });
    } catch (e) {
      //  TRATAMENTO DE ERROS
      // Se a requisição falhar, capturamos o erro aqui
      setState(() {
        _error = e.toString();  // Converte o erro para texto e armazena
      });
    } finally {
      //  BLOCO FINALLY
      // Executa sempre, independente de sucesso ou erro
      setState(() {
        _isLoading = false;  // Esconde o indicador de carregamento
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo de Produtos - Consumindo API REST'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // CORPO DA TELA COM LAYOUT CONDICIONAL
      // A interface muda baseada no estado atual (carregando, erro, sucesso)
      body: _buildBody(),
      // BOTÃO FLUTUANTE PARA ATUALIZAR
      floatingActionButton: FloatingActionButton(
        onPressed: _loadProducts,  // Recarrega os produtos quando pressionado
        child: Icon(Icons.refresh),
         tooltip: 'Atualizar produtos da API',
      ),
    );
  }


  // MÉTODO QUE CONSTRÓI A INTERFACE CONDICIONALMENTE
  Widget _buildBody() {
    // SE estiver carregando, mostra indicador
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),  // Indicador visual de carregamento
            SizedBox(height: 16),         // Espaçamento entre elementos
            Text('Conectando com a API...'),
          ],
        ),
      );
    }


    // SE houve erro, mostra mensagem de erro
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Falha na comunicação com a API',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            SizedBox(height: 8),
            Text(_error!),  // Exibe a mensagem de erro específica
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProducts,  // Tenta recarregar
              child: Text('Tentar Novamente'),
            ),
          ],
        ),
      );

       }


    // SE a lista está vazia (mas não há erro)
    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Nenhum produto cadastrado',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }


    // LISTA DE PRODUTOS (SUCESSO)
    // Se chegou aqui, temos produtos para exibir
    return ListView.builder(
      itemCount: _products.length,  // Quantidade de itens na lista
      itemBuilder: (context, index) {
        final product = _products[index];  // Pega o produto atual
       
        // CARD PARA CADA PRODUTO
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,  // Sombra do card
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: product.imagemUrl != null
                  ? Image.network(product.imagemUrl!)  // Imagem do produto
                  : Icon(Icons.shopping_bag, color: Colors.blue),  // Ícone padrão
            ),
            title: Text(

               product.descricao,  // Nome do produto vindo da API
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text('Tamanho: ${product.tamanho}'),  // Tamanho do produto
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'R\$${product.valor.toStringAsFixed(2)}',  // Preço formatado
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Estoque: ${product.quantidade}',  // Quantidade em estoque
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            // 📍 INTERAÇÃO DO USUÁRIO
            trailing: IconButton(
              icon: Icon(Icons.info, color: Colors.blue),
              onPressed: () {
                _showProductDetails(context, product);  // Mostra detalhes
              },
            ),
          ),
        );
      },
    );

      }


  // DIÁLOGO COM DETALHES DO PRODUTO
  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.descricao),
        content: Column(
          mainAxisSize: MainAxisSize.min,  // Ocupa apenas espaço necessário
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tamanho: ${product.tamanho}'),
            SizedBox(height: 16),
            Text(
              'Preço: R\$${product.valor.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: 8),
            Text('Estoque disponível: ${product.quantidade}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),  // Fecha o diálogo
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }
}

