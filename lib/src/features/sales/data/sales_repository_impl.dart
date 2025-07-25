import 'package:drift/drift.dart';
import 'package:zello/src/app/database/database.dart';
import 'package:zello/src/features/sales/data/sales_repository.dart';
import 'package:zello/src/features/sales/domain/sale_model.dart';
import 'package:zello/src/features/sales/domain/installment_model.dart';

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
            isInstallment: Value(sale.isInstallment),
            installments: Value(sale.installments),
            observation: Value(sale.observation),
            createdAt: sale.createdAt,
          ),
        );

    if (sale.isInstallment && sale.installmentList.isNotEmpty) {
      for (var installment in sale.installmentList) {
        await _database
            .into(_database.installments)
            .insert(
              InstallmentsCompanion.insert(
                saleId: saleId,
                installmentNumber: installment.installmentNumber,
                value: installment.value,
                dueDate: installment.dueDate,
                isPaid: Value(installment.isPaid),
              ),
            );
      }
    }

    return sale.copyWith(id: saleId);
  }

  @override
  Future<void> delete(int id) async {
    await (_database.delete(_database.sales)..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<List<SaleModel>> findAll({bool? isPaid}) async {
    final query = _database.select(_database.sales);

    if (isPaid != null) {
      query.where((tbl) => tbl.isPaid.equals(isPaid));
    }

    final sales = await query.get();

    final salesWithInstallments = <SaleModel>[];
    for (var saleData in sales) {
      List<InstallmentModel> installments = [];
      if (saleData.isInstallment) {
        installments = await _getInstallmentsForSale(saleData.id);
      }
      salesWithInstallments.add(_saleFromSalesData(saleData, installments: installments));
    }
    return salesWithInstallments;
  }

  @override
  Future<List<SaleModel>> search(String query) async {
    final sales = await (_database.select(_database.sales)..where((tbl) => tbl.customerName.contains(query))).get();

    final salesWithInstallments = <SaleModel>[];
    for (var saleData in sales) {
      List<InstallmentModel> installments = [];
      if (saleData.isInstallment) {
        installments = await _getInstallmentsForSale(saleData.id);
      }
      salesWithInstallments.add(_saleFromSalesData(saleData, installments: installments));
    }
    return salesWithInstallments;
  }

  @override
  Future<SaleModel> getById(int id) async {
    final saleData = await (_database.select(_database.sales)..where((tbl) => tbl.id.equals(id))).getSingle();
    List<InstallmentModel> installments = [];
    if (saleData.isInstallment) {
      installments = await _getInstallmentsForSale(saleData.id);
    }
    return _saleFromSalesData(saleData, installments: installments);
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
        isInstallment: Value(sale.isInstallment),
        installments: Value(sale.installments),
        observation: Value(sale.observation),
        createdAt: Value(sale.createdAt),
      ),
    );

    if (sale.isInstallment) {
      // Delete existing installments
      await (_database.delete(_database.installments)..where((tbl) => tbl.saleId.equals(sale.id))).go();
      // Insert new installments
      for (var installment in sale.installmentList) {
        await _database
            .into(_database.installments)
            .insert(
              InstallmentsCompanion.insert(
                saleId: sale.id,
                installmentNumber: installment.installmentNumber,
                value: installment.value,
                dueDate: installment.dueDate,
                isPaid: Value(installment.isPaid),
              ),
            );
      }
    }

    return sale;
  }

  Future<List<InstallmentModel>> _getInstallmentsForSale(int saleId) async {
    final installmentsData = await (_database.select(
      _database.installments,
    )..where((tbl) => tbl.saleId.equals(saleId))).get();
    return installmentsData
        .map(
          (e) => InstallmentModel(
            id: e.id,
            saleId: e.saleId,
            installmentNumber: e.installmentNumber,
            value: e.value,
            dueDate: e.dueDate,
            isPaid: e.isPaid,
          ),
        )
        .toList();
  }

  SaleModel _saleFromSalesData(Sale sale, {List<InstallmentModel>? installments}) {
    return SaleModel(
      id: sale.id,
      customerId: sale.customerId,
      customerName: sale.customerName,
      saleDate: sale.saleDate,
      items: sale.items,
      total: sale.total,
      isPaid: sale.isPaid,
      isInstallment: sale.isInstallment,
      installments: sale.installments,
      installmentList: installments ?? [],
      observation: sale.observation,
      createdAt: sale.createdAt,
    );
  }
}
