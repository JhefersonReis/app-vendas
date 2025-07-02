import 'package:organik_vendas/src/features/customers/domain/customer_model.dart';

abstract interface class CustomersRepository {
  Future<List<CustomerModel>> findAll();
  Future<CustomerModel> findById(int id);
  Future<CustomerModel> create(CustomerModel customer);
  Future<CustomerModel> update(CustomerModel customer);
  Future<void> delete(int id);
}
