import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organik_vendas/src/app/providers/providers.dart';
import 'package:organik_vendas/src/features/sales/domain/sale_model.dart';
import 'package:organik_vendas/src/features/sales/domain/sales_service.dart';

final salesControllerProvider = StateNotifierProvider<SalesController, AsyncValue<List<SaleModel>>>(
  (ref) => SalesController(ref.read(salesServiceProvider)),
);

final saleByIdProvider = FutureProvider.family<SaleModel, int>((ref, id) => ref.read(salesServiceProvider).getById(id));

class SalesController extends StateNotifier<AsyncValue<List<SaleModel>>> {
  final SalesService _service;

  SalesController(this._service) : super(const AsyncValue.loading()) {
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
