import 'package:organik_vendas/src/features/products/domain/product_model.dart';

abstract interface class ProductRepository {
  Future<List<ProductModel>> findAll();
  Future<ProductModel> findById(int id);
  Future<ProductModel> create(ProductModel product);
  Future<ProductModel> update(ProductModel product);
  Future<void> delete(int id);
}
