import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organik_vendas/src/app/database/database.dart';
import 'package:organik_vendas/src/features/customers/data/customers_repository.dart';
import 'package:organik_vendas/src/features/customers/data/customers_repository_impl.dart';
import 'package:organik_vendas/src/features/customers/domain/customers_service.dart';
import 'package:organik_vendas/src/features/customers/domain/customers_service_impl.dart';

final databaseProvider = Provider<Database>((ref) => Database());

final customersRepositoryProvider = Provider<CustomersRepository>(
  (ref) => CustomersRepositoryImpl(database: ref.read(databaseProvider)),
);

final customersServiceProvider = Provider<CustomersService>(
  (ref) => CustomersServiceImpl(
    customersRepository: ref.read(customersRepositoryProvider),
  ),
);
