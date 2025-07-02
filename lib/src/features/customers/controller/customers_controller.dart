import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organik_vendas/src/features/customers/domain/customer_model.dart';
import 'package:organik_vendas/src/features/customers/domain/customers_service.dart';
import 'package:organik_vendas/src/app/providers/customers_providers.dart';

final customersControllerProvider =
    StateNotifierProvider<CustomersController, AsyncValue<List<CustomerModel>>>(
      (ref) => CustomersController(service: ref.read(customersServiceProvider)),
    );

final customerByIdProvider = FutureProvider.family<CustomerModel, int>(
  (ref, id) => ref.read(customersServiceProvider).findById(id),
);

class CustomersController
    extends StateNotifier<AsyncValue<List<CustomerModel>>> {
  final CustomersService _service;

  CustomersController({required CustomersService service})
    : _service = service,
      super(const AsyncLoading()) {
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    try {
      final customers = await _service.findAll();
      state = AsyncData(customers);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addCustomer({
    required String name,
    required String address,
    required String phone,
    String? observation,
  }) async {
    final newCustomer = await _service.create(
      name: name,
      address: address,
      phone: phone,
      observation: observation,
    );

    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, newCustomer]);
  }

  Future<void> updateCustomer({
    required int id,
    required String name,
    required String address,
    required String phone,
    required DateTime createdAt,
    String? observation,
  }) async {
    final updatedCustomer = await _service.update(
      id: id,
      name: name,
      address: address,
      phone: phone,
      observation: observation,
      createdAt: createdAt,
    );

    final current = state.valueOrNull ?? [];
    state = AsyncData([
      for (final customer in current)
        if (customer.id == id) updatedCustomer else customer,
    ]);
  }

  Future<void> deleteCustomer(int id) async {
    await _service.delete(id);

    final current = state.valueOrNull ?? [];
    state = AsyncData(current.where((c) => c.id != id).toList());
  }
}
