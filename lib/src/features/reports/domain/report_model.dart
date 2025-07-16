import 'package:zello/src/features/reports/domain/top_customer_model.dart';
import 'package:zello/src/features/reports/domain/top_product_model.dart';

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReportData &&
        other.totalRevenue == totalRevenue &&
        other.totalSales == totalSales &&
        other.paidSales == paidSales &&
        other.pendingSales == pendingSales &&
        other.averageTicket == averageTicket &&
        other.topProducts == topProducts &&
        other.topCustomers == topCustomers;
  }

  @override
  int get hashCode {
    return totalRevenue.hashCode ^
        totalSales.hashCode ^
        paidSales.hashCode ^
        pendingSales.hashCode ^
        averageTicket.hashCode ^
        topProducts.hashCode ^
        topCustomers.hashCode;
  }
}
