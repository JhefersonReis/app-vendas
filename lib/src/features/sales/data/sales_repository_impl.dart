import 'package:drift/drift.dart';
import 'package:organik_vendas/src/app/database/database.dart';
import 'package:organik_vendas/src/features/sales/data/sales_repository.dart';
import 'package:organik_vendas/src/features/sales/domain/sale_model.dart';

class SalesRepositoryImpl implements SalesRepository {
  final Database _database;

  SalesRepositoryImpl({required Database database}) : _database = database;

  @override
  Future<SaleModel> create(SaleModel sale) async {
    final saleId = await _database
        .into(_database.sales)
        .insert(
          SalesCompanion.insert(
            customerId: sale.customerId,
            customerName: sale.customerName,
            saleDate: sale.saleDate,
            items: sale.items,
            total: sale.total,
            isPaid: sale.isPaid,
            observation: Value(sale.observation),
            createdAt: sale.createdAt,
          ),
        );

    return sale.copyWith(id: saleId);
  }

  @override
  Future<void> delete(int id) async {
    await (_database.delete(_database.sales)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<List<SaleModel>> findAll() async {
    final sales = await _database.select(_database.sales).get();

    return sales
        .map(
          (sale) => SaleModel(
            id: sale.id,
            customerId: sale.customerId,
            customerName: sale.customerName,
            saleDate: sale.saleDate,
            items: sale.items,
            total: sale.total,
            isPaid: sale.isPaid,
            observation: sale.observation,
            createdAt: sale.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<List<SaleModel>> search(String query) async {
    final sales = await (_database.select(_database.sales)..where((tbl) => tbl.customerName.contains(query))).get();

    return sales
        .map(
          (sale) => SaleModel(
            id: sale.id,
            customerId: sale.customerId,
            customerName: sale.customerName,
            saleDate: sale.saleDate,
            items: sale.items,
            total: sale.total,
            isPaid: sale.isPaid,
            observation: sale.observation,
            createdAt: sale.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<SaleModel> getById(int id) async {
    final sale = await (_database.select(_database.sales)..where((tbl) => tbl.id.equals(id))).getSingle();

    return SaleModel(
      id: sale.id,
      customerId: sale.customerId,
      customerName: sale.customerName,
      saleDate: sale.saleDate,
      items: sale.items,
      total: sale.total,
      isPaid: sale.isPaid,
      observation: sale.observation,
      createdAt: sale.createdAt,
    );
  }

  @override
  Future<SaleModel> update(SaleModel sale) async {
    await (_database.update(_database.sales)..where((tbl) => tbl.id.equals(sale.id))).write(
      SalesCompanion(
        customerId: Value(sale.customerId),
        customerName: Value(sale.customerName),
        saleDate: Value(sale.saleDate),
        items: Value(sale.items),
        total: Value(sale.total),
        isPaid: Value(sale.isPaid),
        observation: Value(sale.observation),
        createdAt: Value(sale.createdAt),
      ),
    );

    return sale;
  }
}
