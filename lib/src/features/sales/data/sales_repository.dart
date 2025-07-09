import 'package:organik_vendas/src/features/sales/domain/sale_model.dart';

abstract interface class SalesRepository {
  Future<List<SaleModel>> findAll({bool? isPaid});
  Future<List<SaleModel>> search(String query);
  Future<SaleModel> getById(int id);
  Future<SaleModel> create(SaleModel sale);
  Future<SaleModel> update(SaleModel sale);
  Future<void> delete(int id);
}
