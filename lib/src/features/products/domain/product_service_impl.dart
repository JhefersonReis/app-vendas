import 'package:organik_vendas/src/features/products/data/product_repository.dart';
import 'package:organik_vendas/src/features/products/domain/product_model.dart';
import 'package:organik_vendas/src/features/products/domain/product_service.dart';

class ProductServiceImpl implements ProductService {
  final ProductRepository _productsRepository;

  ProductServiceImpl({required ProductRepository productsRepository}) : _productsRepository = productsRepository;

  @override
  Future<ProductModel> create({
    required String name,
    required String description,
    required double weight,
    required String weightUnit,
    required double price,
    required DateTime createdAt,
  }) {
    final product = ProductModel(
      id: 0,
      name: name,
      description: description,
      price: price,
      weight: weight,
      weightUnit: weightUnit,
      createdAt: createdAt,
    );

    return _productsRepository.create(product);
  }

  @override
  Future<void> delete(int id) => _productsRepository.delete(id);

  @override
  Future<List<ProductModel>> findAll() => _productsRepository.findAll();

  @override
  Future<ProductModel> findById(int id) => _productsRepository.findById(id);

  @override
  Future<ProductModel> update({
    required int id,
    required String name,
    required String description,
    required double weight,
    required String weightUnit,
    required double price,
    required DateTime createdAt,
  }) {
    final product = ProductModel(
      id: id,
      name: name,
      description: description,
      price: price,
      weight: weight,
      weightUnit: weightUnit,
      createdAt: createdAt,
    );

    return _productsRepository.update(product);
  }
}
