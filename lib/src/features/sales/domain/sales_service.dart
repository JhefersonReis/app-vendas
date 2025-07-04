import 'package:organik_vendas/src/features/sales/domain/sale_model.dart';

abstract interface class SalesService {
  Future<List<SaleModel>> findAll();
  Future<SaleModel> getById(int id);
  Future<SaleModel> create(SaleModel sale);
  Future<SaleModel> update(SaleModel sale);
  Future<void> delete(int id);
}