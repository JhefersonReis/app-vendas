import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organik_vendas/src/features/products/domain/product_model.dart';

class ProductsController extends StateNotifier<AsyncValue<List<ProductModel>>> {
  ProductsController() : super(const AsyncLoading());

  void addProduct(ProductModel product) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, product]);
  }

  void updateProduct(ProductModel product) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([
      for (final product in current)
        if (product.id == product.id) product else product,
    ]);
  }

  void deleteProduct(int id) {
    final current = state.valueOrNull ?? [];
    state = AsyncData([
      for (final product in current)
        if (product.id != id) product,
    ]);
  }

  void setProducts(List<ProductModel> products) {
    state = AsyncData(products);
  }
}
