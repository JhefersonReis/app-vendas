import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:organik_vendas/src/features/products/controller/product_controller.dart';
import 'package:organik_vendas/src/features/products/domain/product_model.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Produtos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF248f3d),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: products.when(
          error: (error, stackTrace) => Center(child: Text('Erro ao carregar: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (products) {
            return products.isEmpty ? _buildEmptyState(context) : _buildProdutosList(products, ref);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/products/form'),
        backgroundColor: const Color(0xFF248f3d),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inventory_2, size: 50, color: Colors.grey),
              const SizedBox(height: 10),
              const Text('Nenhum produto cadastrado', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text(
                'Comece adicionando seus produtos\npara facilitar as vendas',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => context.go('/products/form'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF248f3d),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Adicionar Primeiro Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProdutosList(List<ProductModel> products, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Dismissible(
          key: ValueKey(product.id),
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            ref.read(productsControllerProvider.notifier).deleteProduct(product.id);
          },
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirmar exclusão'),
                content: const Text('Deseja realmente excluir este produto?'),
                actions: [
                  TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Excluir'),
                  ),
                ],
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.go('/products/form?id=${product.id}'),
                        icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                  Text(
                    NumberFormat.simpleCurrency(locale: 'pt_BR').format(product.price),
                    style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${product.weightUnit == 'kg' ? product.weight.toStringAsFixed(1) : product.weight.toStringAsFixed(0)} ${product.weightUnit}',
                  ),
                  if (product.description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Observação: ${product.description}', style: const TextStyle(color: Colors.grey)),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
