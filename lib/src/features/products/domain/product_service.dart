import 'package:zello/src/features/products/domain/product_model.dart';

abstract interface class ProductService {
  Future<List<ProductModel>> findAll();
  Future<ProductModel> findById(int id);
  Future<ProductModel> create({
    required String name,
    required String description,
    required double weight,
    required String weightUnit,
    required double price,
    required DateTime createdAt,
  });
  Future<ProductModel> update({
    required int id,
    required String name,
    required String description,
    required double weight,
    required String weightUnit,
    required double price,
    required DateTime createdAt,
  });
  Future<void> delete(int id);
}
