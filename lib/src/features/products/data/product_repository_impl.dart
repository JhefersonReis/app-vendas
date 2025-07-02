import 'package:drift/drift.dart';
import 'package:organik_vendas/src/app/database/database.dart';
import 'package:organik_vendas/src/features/products/data/product_repository.dart';
import 'package:organik_vendas/src/features/products/domain/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final Database _database;

  ProductRepositoryImpl({required Database database}) : _database = database;

  @override
  Future<ProductModel> create(ProductModel product) async {
    final productId = await _database
        .into(_database.products)
        .insert(
          ProductsCompanion.insert(
            name: product.name,
            price: product.price,
            description: product.description,
            weight: product.weight,
            weightUnit: product.weightUnit,
            createdAt: product.createdAt,
          ),
        );

    return product.copyWith(id: productId);
  }

  @override
  Future<void> delete(int id) async {
    await (_database.delete(_database.products)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<List<ProductModel>> findAll() async {
    final products = await (_database.select(_database.products)).get();

    return products
        .map(
          (product) => ProductModel(
            id: product.id,
            name: product.name,
            price: product.price,
            description: product.description,
            weight: product.weight,
            weightUnit: product.weightUnit,
            createdAt: product.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<ProductModel> findById(int id) async {
    final product = await (_database.select(_database.products)..where((tbl) => tbl.id.equals(id))).getSingle();

    return ProductModel(
      id: product.id,
      name: product.name,
      price: product.price,
      description: product.description,
      weight: product.weight,
      weightUnit: product.weightUnit,
      createdAt: product.createdAt,
    );
  }

  @override
  Future<ProductModel> update(ProductModel product) async {
    await (_database.update(_database.products)..where((tbl) => tbl.id.equals(product.id))).write(
      ProductsCompanion(
        name: Value(product.name),
        price: Value(product.price),
        description: Value(product.description),
        weight: Value(product.weight),
        weightUnit: Value(product.weightUnit),
        createdAt: Value(product.createdAt),
      ),
    );

    return product;
  }
}
