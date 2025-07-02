import 'package:organik_vendas/src/features/customers/domain/customer_model.dart';

abstract interface class CustomersService {
  Future<List<CustomerModel>> findAll();
  Future<CustomerModel> findById(int id);
  Future<CustomerModel> create({
    required String name,
    required String address,
    required String phone,
    String? observation,
  });
  Future<CustomerModel> update({
    required int id,
    required String name,
    required String address,
    required String phone,
    required DateTime createdAt,
    String? observation,
  });
  Future<void> delete(int id);
}
