import 'package:organik_vendas/src/features/reports/domain/top_customer_model.dart';
import 'package:organik_vendas/src/features/reports/domain/top_product_model.dart';

class ReportData {
  final double totalRevenue;
  final int totalSales;
  final int paidSales;
  final int pendingSales;
  final double averageTicket;
  final List<TopProduct> topProducts;
  final List<TopCustomer> topCustomers;

  ReportData({
    required this.totalRevenue,
    required this.totalSales,
    required this.paidSales,
    required this.pendingSales,
    required this.averageTicket,
    required this.topProducts,
    required this.topCustomers,
  });
}
