import 'package:drift/drift.dart';
import 'package:organik_vendas/src/app/database/database.dart';
import 'package:organik_vendas/src/features/customers/domain/customer_model.dart';
import 'package:organik_vendas/src/features/products/domain/product_model.dart';
import 'package:organik_vendas/src/features/reports/data/reports_repository.dart';
import 'package:organik_vendas/src/features/reports/domain/report_model.dart';
import 'package:organik_vendas/src/features/reports/domain/top_customer_model.dart';
import 'package:organik_vendas/src/features/reports/domain/top_product_model.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final Database _database;

  ReportsRepositoryImpl({required Database database}) : _database = database;

  @override
  Future<ReportData> getReportData(DateTime startDate, DateTime endDate) async {
    final sales =
        await (_database.select(_database.sales)
              ..where((tbl) => tbl.saleDate.isBiggerOrEqualValue(startDate))
              ..where((tbl) => tbl.saleDate.isSmallerOrEqualValue(endDate)))
            .get();

    final totalRevenue = sales.fold<double>(0, (prev, sale) => prev + sale.total);
    final totalSales = sales.length;
    final paidSales = sales.where((sale) => sale.isPaid).length;
    final pendingSales = totalSales - paidSales;
    final averageTicket = totalSales > 0 ? totalRevenue / totalSales : 0.0;

    final productSales = <int, int>{};
    final productRevenue = <int, double>{};

    for (var sale in sales) {
      for (var item in sale.items) {
        productSales[item.productId] = (productSales[item.productId] ?? 0) + item.quantity;
        productRevenue[item.productId] = (productRevenue[item.productId] ?? 0) + (item.quantity * item.unitPrice);
      }
    }

    final topProductIds = productSales.keys.toList()..sort((a, b) => productSales[b]!.compareTo(productSales[a]!));

    final topProducts = <TopProduct>[];
    for (var productId in topProductIds.take(3)) {
      final product = await (_database.select(
        _database.products,
      )..where((tbl) => tbl.id.equals(productId))).getSingle();
      topProducts.add(
        TopProduct(
          product: ProductModel(
            id: product.id,
            name: product.name,
            price: product.price,
            weight: product.weight,
            weightUnit: product.weightUnit,
            description: product.description,
            createdAt: product.createdAt,
          ),
          quantitySold: productSales[productId]!,
          totalRevenue: productRevenue[productId]!,
        ),
      );
    }

    final customerPurchases = <int, int>{};
    final customerSpent = <int, double>{};

    for (var sale in sales) {
      customerPurchases[sale.customerId] = (customerPurchases[sale.customerId] ?? 0) + 1;
      customerSpent[sale.customerId] = (customerSpent[sale.customerId] ?? 0) + sale.total;
    }

    final topCustomerIds = customerPurchases.keys.toList()
      ..sort((a, b) => customerPurchases[b]!.compareTo(customerPurchases[a]!));

    final topCustomers = <TopCustomer>[];
    for (var customerId in topCustomerIds.take(3)) {
      final customer = await (_database.select(
        _database.customers,
      )..where((tbl) => tbl.id.equals(customerId))).getSingle();
      topCustomers.add(
        TopCustomer(
          customer: CustomerModel(
            id: customer.id,
            name: customer.name,
            phone: customer.phone,
            address: customer.address,
            createdAt: customer.createdAt,
          ),
          totalPurchases: customerPurchases[customerId]!,
          totalSpent: customerSpent[customerId]!,
        ),
      );
    }

    return ReportData(
      totalRevenue: totalRevenue,
      totalSales: totalSales,
      paidSales: paidSales,
      pendingSales: pendingSales,
      averageTicket: averageTicket,
      topProducts: topProducts,
      topCustomers: topCustomers,
    );
  }
}
