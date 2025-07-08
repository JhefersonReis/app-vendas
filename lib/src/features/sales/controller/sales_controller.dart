import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organik_vendas/src/app/providers/providers.dart';
import 'package:organik_vendas/src/features/customers/controller/customers_controller.dart';
import 'package:organik_vendas/src/features/sales/data/sales_repository.dart';
import 'package:organik_vendas/src/features/sales/data/sales_repository_impl.dart';
import 'package:organik_vendas/src/features/sales/domain/sale_model.dart';
import 'package:organik_vendas/src/features/sales/domain/sales_service.dart';
import 'package:organik_vendas/src/features/sales/domain/sales_service_impl.dart';

final salesRepositoryProvider = Provider<SalesRepository>(
  (ref) => SalesRepositoryImpl(database: ref.read(databaseProvider)),
);

final salesServiceProvider = Provider<SalesService>((ref) => SalesServiceImpl(ref.read(salesRepositoryProvider)));

final salesControllerProvider = StateNotifierProvider.autoDispose<SalesController, AsyncValue<List<SaleModel>>>((ref) {
  ref.watch(customersControllerProvider);
  return SalesController(ref.read(salesServiceProvider), ref);
});

final saleByIdProvider = FutureProvider.family<SaleModel, int>((ref, id) => ref.read(salesServiceProvider).getById(id));

final salesFilterProvider = StateProvider.autoDispose<String>((ref) => '');

final filteredSalesProvider = Provider.autoDispose<List<SaleModel>>((ref) {
  final salesState = ref.watch(salesControllerProvider);
  final filter = ref.watch(salesFilterProvider);

  return salesState.when(
    data: (sales) {
      if (filter.isEmpty) {
        return sales;
      }
      return sales.where((sale) => sale.customerName.toLowerCase().contains(filter.toLowerCase())).toList();
    },
    loading: () => [],
    error: (e, s) => [],
  );
});

class SalesController extends StateNotifier<AsyncValue<List<SaleModel>>> {
  final SalesService _service;
  final Ref _ref;

  SalesController(this._service, this._ref) : super(const AsyncValue.loading()) {
    findAll();
  }

  Future<void> findAll() async {
    state = const AsyncValue.loading();
    try {
      final sales = await _service.findAll();
      state = AsyncValue.data(sales);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  void search(String query) {
    _ref.read(salesFilterProvider.notifier).state = query;
  }

  Future<void> create(SaleModel sale) async {
    state = const AsyncValue.loading();
    try {
      await _service.create(sale);
      await findAll();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> update(SaleModel sale) async {
    state = const AsyncValue.loading();
    try {
      await _service.update(sale);
      await findAll();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> delete(int id) async {
    state = const AsyncValue.loading();
    try {
      await _service.delete(id);
      await findAll();
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
