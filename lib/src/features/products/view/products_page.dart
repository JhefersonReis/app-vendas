import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:organik_vendas/l10n/app_localizations.dart';
import 'package:organik_vendas/src/features/products/controller/product_controller.dart';
import 'package:organik_vendas/src/features/products/widgets/product_empty_widget.dart';
import 'package:organik_vendas/src/features/products/widgets/product_list_widget.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsControllerProvider);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.productsTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF248f3d),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: products.when(
          error: (error, stackTrace) => Center(child: Text('Erro ao carregar: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (products) => products.isEmpty ? ProductEmptyWidget() : ProductListWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/products/form'),
        backgroundColor: const Color(0xFF248f3d),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
