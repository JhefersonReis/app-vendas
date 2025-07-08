import 'package:organik_vendas/src/features/customers/domain/customer_model.dart';
import 'package:organik_vendas/src/features/customers/data/customers_repository.dart';
import 'package:organik_vendas/src/features/customers/domain/customers_service.dart';

class CustomersServiceImpl implements CustomersService {
  final CustomersRepository _customersRepository;

  CustomersServiceImpl({required CustomersRepository customersRepository}) : _customersRepository = customersRepository;

  @override
  Future<CustomerModel> create({
    required String name,
    required String address,
    required String phone,
    required String countryISOCode,
    String? observation,
  }) async {
    final customer = CustomerModel(
      id: 0,
      name: name,
      address: address,
      phone: phone,
      countryISOCode: countryISOCode,
      observation: observation,
      createdAt: DateTime.now(),
    );

    return await _customersRepository.create(customer);
  }

  @override
  Future<void> delete(int id) => _customersRepository.delete(id);

  @override
  Future<List<CustomerModel>> findAll() => _customersRepository.findAll();

  @override
  Future<CustomerModel> findById(int id) => _customersRepository.findById(id);

  @override
  Future<CustomerModel> update({
    required int id,
    required String name,
    required String address,
    required String phone,
    required String countryISOCode,
    required DateTime createdAt,
    String? observation,
  }) async {
    final customer = CustomerModel(
      id: id,
      name: name,
      address: address,
      phone: phone,
      countryISOCode: countryISOCode,
      observation: observation,
      createdAt: createdAt,
    );

    return await _customersRepository.update(customer);
  }
}
