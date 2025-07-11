import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:organik_vendas/src/features/reports/controller/reports_controller.dart';
import 'package:organik_vendas/src/features/reports/domain/report_model.dart';
import 'package:organik_vendas/src/features/reports/domain/reports_service.dart';
import 'package:organik_vendas/src/features/reports/domain/top_customer_model.dart';
import 'package:organik_vendas/src/features/reports/domain/top_product_model.dart';
import 'package:organik_vendas/src/features/products/domain/product_model.dart';
import 'package:organik_vendas/src/features/customers/domain/customer_model.dart';

import 'reports_controller_test.mocks.dart';

@GenerateMocks([ReportsService])
void main() {
  group('ReportsController', () {
    late ReportsController controller;
    late MockReportsService mockService;

    setUp(() {
      mockService = MockReportsService();
      reset(mockService);
    });

    test('can be instantiated', () {
      expect(ReportsController(mockService), isA<ReportsController>());
    });

    test('getReportData calls service and updates state', () async {
      final startDate = DateTime(2023, 1, 1);
      final endDate = DateTime(2023, 1, 31);

      final product = ProductModel(
        id: 1,
        name: 'Product 1',
        price: 10.0,
        weight: 1.0,
        weightUnit: 'kg',
        description: 'Desc 1',
        createdAt: DateTime.now(),
      );
      final customer = CustomerModel(
        id: 1,
        name: 'Customer 1',
        address: 'Address 1',
        phone: '123',
        countryISOCode: 'BR',
        createdAt: DateTime.now(),
      );

      final reportData = ReportData(
        totalRevenue: 100.0,
        totalSales: 10,
        paidSales: 8,
        pendingSales: 2,
        averageTicket: 10.0,
        topProducts: [TopProduct(product: product, quantitySold: 5, totalRevenue: 50.0)],
        topCustomers: [TopCustomer(customer: customer, totalPurchases: 3, totalSpent: 30.0)],
      );

      when(mockService.getReportData(startDate, endDate)).thenAnswer((_) async => reportData);

      controller = ReportsController(mockService);

      await controller.getReportData(startDate, endDate);

      verify(mockService.getReportData(startDate, endDate)).called(1);

      expect(controller.state.value, reportData);
    });
  });
}
