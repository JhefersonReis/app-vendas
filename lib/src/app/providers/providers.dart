import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organik_vendas/src/app/database/database.dart';
import 'package:organik_vendas/src/features/customers/data/customers_repository.dart';
import 'package:organik_vendas/src/features/customers/data/customers_repository_impl.dart';
import 'package:organik_vendas/src/features/customers/domain/customers_service.dart';
import 'package:organik_vendas/src/features/customers/domain/customers_service_impl.dart';
import 'package:organik_vendas/src/features/home/controller/home_state.dart';
import 'package:organik_vendas/src/features/products/data/product_repository.dart';
import 'package:organik_vendas/src/features/products/data/product_repository_impl.dart';
import 'package:organik_vendas/src/features/products/domain/product_service.dart';
import 'package:organik_vendas/src/features/products/domain/product_service_impl.dart';
import 'package:organik_vendas/src/features/reports/data/reports_repository.dart';
import 'package:organik_vendas/src/features/reports/data/reports_repository_impl.dart';
import 'package:organik_vendas/src/features/reports/domain/reports_service.dart';
import 'package:organik_vendas/src/features/reports/domain/reports_service_impl.dart';

import 'package:organik_vendas/src/features/sales/controller/sales_controller.dart';
import 'package:organik_vendas/src/features/sales/data/sales_repository.dart';
import 'package:organik_vendas/src/features/sales/data/sales_repository_impl.dart';
import 'package:organik_vendas/src/features/sales/domain/sale_model.dart';
import 'package:organik_vendas/src/features/sales/domain/sales_service.dart';
import 'package:organik_vendas/src/features/sales/domain/sales_service_impl.dart';

import 'package:organik_vendas/src/features/home/controller/home_controller.dart';

// Home provider
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>((ref) {
  return HomeController(ref);
});

// Database provider
final databaseProvider = Provider<Database>((ref) => Database());

// Customers provider
final customersRepositoryProvider = Provider<CustomersRepository>(
  (ref) => CustomersRepositoryImpl(database: ref.read(databaseProvider)),
);
final customersServiceProvider = Provider<CustomersService>(
  (ref) => CustomersServiceImpl(customersRepository: ref.read(customersRepositoryProvider)),
);

// Products provider
final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(database: ref.read(databaseProvider)),
);
final productServiceProvider = Provider<ProductService>(
  (ref) => ProductServiceImpl(productsRepository: ref.read(productRepositoryProvider)),
);

// Sales provider
final salesRepositoryProvider = Provider<SalesRepository>(
  (ref) => SalesRepositoryImpl(database: ref.read(databaseProvider)),
);

final salesServiceProvider = Provider<SalesService>((ref) => SalesServiceImpl(ref.read(salesRepositoryProvider)));

final salesControllerProvider = StateNotifierProvider<SalesController, AsyncValue<List<SaleModel>>>(
  (ref) => SalesController(ref.read(salesServiceProvider), ref),
);

// Reports provider
final reportsRepositoryProvider = Provider<ReportsRepository>(
  (ref) => ReportsRepositoryImpl(database: ref.read(databaseProvider)),
);

final reportsServiceProvider = Provider<ReportsService>(
  (ref) => ReportsServiceImpl(ref.read(reportsRepositoryProvider)),
);
