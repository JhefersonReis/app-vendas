import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:organik_vendas/src/features/products/controller/product_controller.dart';
import 'package:organik_vendas/src/features/products/widgets/product_list_widget.dart';

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
            return products.isEmpty ? _buildEmptyState(context) : ProductListWidget();
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
}
