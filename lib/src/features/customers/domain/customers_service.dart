import 'package:zello/src/features/customers/domain/customer_model.dart';

abstract interface class CustomersService {
  Future<List<CustomerModel>> findAll();
  Future<CustomerModel> findById(int id);
  Future<CustomerModel> create({
    required String name,
    required String address,
    required String phone,
    required String countryISOCode,
    String? observation,
  });
  Future<CustomerModel> update({
    required int id,
    required String name,
    required String address,
    required String phone,
    required String countryISOCode,
    required DateTime createdAt,
    String? observation,
  });
  Future<void> delete(int id);
}
