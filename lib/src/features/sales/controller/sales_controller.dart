import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zello/src/app/providers/providers.dart';
import 'package:zello/src/features/customers/controller/customers_controller.dart';
import 'package:zello/src/features/sales/data/sales_repository.dart';
import 'package:zello/src/features/sales/data/sales_repository_impl.dart';
import 'package:zello/src/features/sales/domain/sale_model.dart';
import 'package:zello/src/features/sales/domain/sales_service.dart';
import 'package:zello/src/features/sales/domain/sales_service_impl.dart';

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

enum SalesStatusFilter { all, paid, unpaid }

final salesStatusFilterProvider = StateProvider.autoDispose<SalesStatusFilter>((ref) => SalesStatusFilter.all);

final filteredSalesProvider = Provider.autoDispose<List<SaleModel>>((ref) {
  final salesState = ref.watch(salesControllerProvider);
  final filter = ref.watch(salesFilterProvider);
  final statusFilter = ref.watch(salesStatusFilterProvider);

  return salesState.when(
    data: (sales) {
      List<SaleModel> filteredSales;

      // Filtro por status
      switch (statusFilter) {
        case SalesStatusFilter.paid:
          filteredSales = sales.where((sale) => sale.isPaid).toList();
          break;
        case SalesStatusFilter.unpaid:
          filteredSales = sales.where((sale) => !sale.isPaid).toList();
          break;
        case SalesStatusFilter.all:
          filteredSales = sales;
          break;
      }

      // Filtro por nome
      if (filter.isNotEmpty) {
        filteredSales = filteredSales
            .where((sale) => sale.customerName.toLowerCase().contains(filter.toLowerCase()))
            .toList();
      }

      return filteredSales;
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

  void setStatusFilter(SalesStatusFilter filter) {
    _ref.read(salesStatusFilterProvider.notifier).state = filter;
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
