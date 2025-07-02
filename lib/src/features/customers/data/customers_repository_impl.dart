import 'package:drift/drift.dart';
import 'package:organik_vendas/src/app/database/database.dart';
import 'package:organik_vendas/src/features/customers/domain/customer_model.dart';
import 'package:organik_vendas/src/features/customers/data/customers_repository.dart';

class CustomersRepositoryImpl implements CustomersRepository {
  final Database _database;

  CustomersRepositoryImpl({required Database database}) : _database = database;

  @override
  Future<CustomerModel> create(CustomerModel customer) async {
    final customerId = await _database
        .into(_database.customers)
        .insert(
          CustomersCompanion.insert(
            name: customer.name,
            address: customer.address,
            phone: customer.phone,
            observation: Value(customer.observation),
            createdAt: customer.createdAt,
          ),
        );

    return customer.copyWith(id: customerId);
  }

  @override
  Future<void> delete(int id) async {
    await (_database.delete(
      _database.customers,
    )..where((tbl) => tbl.id.equals(id))).go();
  }

  @override
  Future<List<CustomerModel>> findAll() async {
    final customers = await _database.select(_database.customers).get();
    return customers
        .map(
          (customer) => CustomerModel(
            id: customer.id,
            name: customer.name,
            address: customer.address,
            phone: customer.phone,
            observation: customer.observation,
            createdAt: customer.createdAt,
          ),
        )
        .toList();
  }

  @override
  Future<CustomerModel> findById(int id) async {
    final customer = await (_database.select(
      _database.customers,
    )..where((tbl) => tbl.id.equals(id))).getSingle();
    return CustomerModel(
      id: customer.id,
      name: customer.name,
      address: customer.address,
      phone: customer.phone,
      observation: customer.observation,
      createdAt: customer.createdAt,
    );
  }

  @override
  Future<CustomerModel> update(CustomerModel customer) async {
    await (_database.update(
      _database.customers,
    )..where((tbl) => tbl.id.equals(customer.id))).write(
      CustomersCompanion(
        name: Value(customer.name),
        address: Value(customer.address),
        phone: Value(customer.phone),
        observation: Value(customer.observation),
      ),
    );

    return customer;
  }
}
