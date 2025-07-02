import 'package:organik_vendas/src/features/products/domain/product_model.dart';

abstract interface class ProductService {
  Future<List<ProductModel>> findAll();
  Future<ProductModel> findById(int id);
  Future<ProductModel> create({
    required String name,
    required String description,
    required String category,
    required String image,
    required double price,
    required int quantity,
  });
  Future<ProductModel> update({
    required int id,
    required String name,
    required String description,
    required String category,
    required String image,
    required double price,
    required int quantity,
  });
  Future<void> delete(int id);
}
