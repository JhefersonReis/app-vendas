import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organik_vendas/src/app/providers/providers.dart';
import 'package:organik_vendas/src/features/products/domain/product_model.dart';
import 'package:organik_vendas/src/features/products/domain/product_service.dart';

final productsControllerProvider = StateNotifierProvider<ProductController, AsyncValue<List<ProductModel>>>(
  (ref) => ProductController(service: ref.read(productServiceProvider)),
);

final productByIdProvider = FutureProvider.family<ProductModel, int>(
  (ref, id) => ref.read(productServiceProvider).findById(id),
);

final productsFilterProvider = StateProvider<String>((ref) => '');

final filteredProductsProvider = Provider.autoDispose<List<ProductModel>>((ref) {
  final productsState = ref.watch(productsControllerProvider);
  final filter = ref.watch(productsFilterProvider);

  return productsState.when(
    data: (products) {
      if (filter.isEmpty) {
        return products;
      }

      return products.where((product) {
        final searchTerm = filter.toLowerCase();
        final productName = product.name.toLowerCase();
        final productDescription = product.description.toLowerCase();

        return productName.contains(searchTerm) || productDescription.contains(searchTerm);
      }).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

class ProductController extends StateNotifier<AsyncValue<List<ProductModel>>> {
  final ProductService _service;

  ProductController({required ProductService service}) : _service = service, super(const AsyncLoading()) {
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final products = await _service.findAll();
      state = AsyncData(products);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  Future<void> createProduct({
    required String name,
    required String description,
    required double weight,
    required String weightUnit,
    required double price,
  }) async {
    try {
      final newProduct = await _service.create(
        name: name,
        description: description,
        weight: weight,
        weightUnit: weightUnit,
        price: price,
        createdAt: DateTime.now(),
      );

      final current = state.valueOrNull ?? [];
      state = AsyncData([...current, newProduct]);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    required String description,
    required double weight,
    required String weightUnit,
    required double price,
    required DateTime createdAt,
  }) async {
    try {
      final updatedProduct = await _service.update(
        id: id,
        name: name,
        description: description,
        weight: weight,
        weightUnit: weightUnit,
        price: price,
        createdAt: createdAt,
      );

      final current = state.valueOrNull ?? [];
      final index = current.indexWhere((product) => product.id == id);

      if (index != -1) {
        final updatedList = List<ProductModel>.from(current)..[index] = updatedProduct;
        state = AsyncData(updatedList);
      }
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _service.delete(id);

      final current = state.valueOrNull ?? [];
      final updatedList = current.where((product) => product.id != id).toList();
      state = AsyncData(updatedList);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
