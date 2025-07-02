import 'package:organik_vendas/src/features/products/data/products_repository.dart';
import 'package:organik_vendas/src/features/products/domain/product_model.dart';
import 'package:organik_vendas/src/features/products/domain/product_service.dart';

class ProductServiceImpl implements ProductService {
  final ProductsRepository _productsRepository;

  ProductServiceImpl({required ProductsRepository productsRepository})
    : _productsRepository = productsRepository;

  @override
  Future<ProductModel> create({

  }) async {
    final product = ProductModel(
      id: 0,
      name: name,
      description: description,
      price: price,
      weight: ,
      weightUnit: '',
      createdAt: null,
    );
    return _productsRepository.create(product);
  }
}
