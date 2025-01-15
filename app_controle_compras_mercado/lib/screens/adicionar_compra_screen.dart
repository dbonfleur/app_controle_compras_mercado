import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/compra_model.dart';
import '../models/produto_model.dart';
import '../models/compra_produto_model.dart';
import '../blocs/produto/produto_bloc.dart';
import '../blocs/compra/compra_bloc.dart';
import '../blocs/categoria/categoria_bloc.dart';
import '../models/categoria_model.dart';

class AdicionarCompraScreen extends StatefulWidget {
  const AdicionarCompraScreen({super.key});

  @override
  _AdicionarCompraScreenState createState() => _AdicionarCompraScreenState();
}

class _AdicionarCompraScreenState extends State<AdicionarCompraScreen> {
  final List<Produto> _novaListaProdutos = [];
  String? _imagemUrl;
  Categoria? _categoriaSelecionada;

  void _adicionarProduto(Produto produto) {
    setState(() {
      _novaListaProdutos.add(produto);
    });
  }

  void _salvarCompra() async {
    if(_novaListaProdutos.isEmpty) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Adicione pelo menos um produto para salvar a compra'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    final prefs = await SharedPreferences.getInstance();
    final novaCompra = Compra(
      idUser: prefs.getInt('idUser')!,
      data: DateTime.now(),
      precoTotal: _novaListaProdutos.fold(0, (total, produto) => total + produto.preco),
    );

    final compraProdutos = _novaListaProdutos.map((produto) {
      return CompraProduto(
        idCompra: novaCompra.id!,
        idProduto: produto.id!,
        qtdeProduto: 1, 
        valorUnitario: produto.preco,
      );
    }).toList();

    context.read<CompraBloc>().add(AddCompra(novaCompra, compraProdutos));
    Navigator.pop(context);
  }

  Future<void> _showAddProdutoDialog() async {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController precoController = TextEditingController();
    final TextEditingController categoriaController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Produto'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextFormField(
                  controller: precoController,
                  decoration: const InputDecoration(labelText: 'Preço'),
                  keyboardType: TextInputType.number,
                ),
                BlocBuilder<CategoriaBloc, CategoriaState>(
                  builder: (context, state) {
                    if (state is CategoriaLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is CategoriaLoaded) {
                      final categorias = state.categorias;
                      if (_categoriaSelecionada == null && categorias.isNotEmpty) {
                        _categoriaSelecionada = categorias.last;
                      }
                      return DropdownButtonFormField<Categoria>(
                        value: _categoriaSelecionada,
                        items: [
                          ...categorias.map((categoria) {
                            return DropdownMenuItem<Categoria>(
                              value: categoria,
                              child: Text(categoria.nome),
                            );
                          }),
                          DropdownMenuItem<Categoria>(
                            value: null,
                            child: const Text('Outro'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) {
                            _showAddCategoriaDialog(categoriaController);
                          } else {
                            setState(() {
                              _categoriaSelecionada = value;
                            });
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Categoria'),
                      );
                    } else if (state is CategoriaError) {
                      return Text('Erro: ${state.message}');
                    } else {
                      return DropdownButtonFormField<Categoria>(
                        value: _categoriaSelecionada,
                        items: [
                          DropdownMenuItem<Categoria>(
                            value: null,
                            child: const Text('Outro'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) {
                            _showAddCategoriaDialog(categoriaController);
                          } else {
                            setState(() {
                              _categoriaSelecionada = value;
                            });
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Categoria'),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Tirar Foto'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final novoProduto = Produto(
                  nome: nomeController.text,
                  preco: double.parse(precoController.text),
                  idCategoria: _categoriaSelecionada!.id!,
                  imagemUrl: _imagemUrl,
                );
                context.read<ProdutoBloc>().add(AddProduto(novoProduto));
                Navigator.pop(context);
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imagemUrl = pickedFile.path;
      });
    }
  }

  Future<void> _showAddCategoriaDialog(TextEditingController categoriaController) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Categoria'),
          content: TextFormField(
            controller: categoriaController,
            decoration: const InputDecoration(labelText: 'Nome da Categoria'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final novaCategoria = Categoria(nome: categoriaController.text);
                context.read<CategoriaBloc>().add(AddCategoria(novaCategoria));
                Navigator.pop(context);
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Compra'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvarCompra,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ProdutoBloc, ProdutoState>(
              builder: (context, state) {
                if (state is ProdutoLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProdutoLoaded) {
                  return ListView.builder(
                    itemCount: state.produtos.length,
                    itemBuilder: (context, index) {
                      final produto = state.produtos[index];
                      return ListTile(
                        title: Text(produto.nome),
                        subtitle: Text('Preço: ${produto.preco}'),
                        onTap: () => _adicionarProduto(produto),
                      );
                    },
                  );
                } else if (state is ProdutoError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('Nenhum produto encontrado'));
                }
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _novaListaProdutos.length,
              itemBuilder: (context, index) {
                final produto = _novaListaProdutos[index];
                return ListTile(
                  title: Text(produto.nome),
                  subtitle: Text('Preço: ${produto.preco}'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProdutoDialog,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar Produto'),
      ),
    );
  }
}