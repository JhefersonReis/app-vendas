import 'package:organik_vendas/src/features/sales/data/sales_repository.dart';
import 'package:organik_vendas/src/features/sales/domain/sale_model.dart';
import 'package:organik_vendas/src/features/sales/domain/sales_service.dart';

class SalesServiceImpl implements SalesService {
  final SalesRepository _repository;

  SalesServiceImpl(this._repository);

  @override
  Future<SaleModel> create(SaleModel sale) => _repository.create(sale);

  @override
  Future<void> delete(int id) => _repository.delete(id);

  @override
  Future<List<SaleModel>> findAll() => _repository.findAll();

  @override
  Future<List<SaleModel>> search(String query) => _repository.search(query);

  @override
  Future<SaleModel> getById(int id) => _repository.getById(id);

  @override
  Future<SaleModel> update(SaleModel sale) => _repository.update(sale);
}
