import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:zello/src/features/customers/controller/customers_controller.dart';
import 'package:zello/src/features/customers/domain/customer_model.dart';
import 'package:zello/src/features/customers/domain/customers_service.dart';

import 'customers_controller_test.mocks.dart';

@GenerateMocks([CustomersService])
void main() {
  group('CustomersController', () {
    late CustomersController controller;
    late MockCustomersService mockService;

    setUp(() {
      mockService = MockCustomersService();
    });

    test('initial state is loading and loads customers', () async {
      final customers = [
        CustomerModel(
          id: 1,
          name: 'Test',
          address: 'Test',
          phone: 'Test',
          countryISOCode: 'Test',
          createdAt: DateTime.now(),
        ),
      ];
      when(mockService.findAll()).thenAnswer((_) async => customers);

      controller = CustomersController(service: mockService);

      expect(controller.state, const AsyncLoading<List<CustomerModel>>());

      await Future.delayed(Duration.zero);

      verify(mockService.findAll()).called(1);

      expect(controller.state.value, customers);
    });

    test('addCustomer calls service and updates state', () async {
      final newCustomer = CustomerModel(
        id: 2,
        name: 'New',
        address: 'New',
        phone: 'New',
        countryISOCode: 'New',
        createdAt: DateTime.now(),
      );
      when(mockService.findAll()).thenAnswer((_) async => []);
      when(
        mockService.create(
          name: anyNamed('name'),
          address: anyNamed('address'),
          phone: anyNamed('phone'),
          countryISOCode: anyNamed('countryISOCode'),
          observation: anyNamed('observation'),
        ),
      ).thenAnswer((_) async => newCustomer);

      controller = CustomersController(service: mockService);
      await Future.delayed(Duration.zero);

      await controller.addCustomer(name: 'New', address: 'New', phone: 'New', countryISOCode: 'New');

      verify(
        mockService.create(name: 'New', address: 'New', phone: 'New', countryISOCode: 'New', observation: null),
      ).called(1);

      expect(controller.state.value, [newCustomer]);
    });

    test('updateCustomer calls service and updates state', () async {
      final initialCustomer = CustomerModel(
        id: 1,
        name: 'Initial',
        address: 'Initial',
        phone: 'Initial',
        countryISOCode: 'Initial',
        createdAt: DateTime.now(),
      );
      final updatedCustomer = initialCustomer.copyWith(name: 'Updated');

      when(mockService.findAll()).thenAnswer((_) async => [initialCustomer]);
      when(
        mockService.update(
          id: anyNamed('id'),
          name: anyNamed('name'),
          address: anyNamed('address'),
          phone: anyNamed('phone'),
          countryISOCode: anyNamed('countryISOCode'),
          observation: anyNamed('observation'),
          createdAt: anyNamed('createdAt'),
        ),
      ).thenAnswer((_) async => updatedCustomer);

      controller = CustomersController(service: mockService);
      await Future.delayed(Duration.zero);

      await controller.updateCustomer(
        id: 1,
        name: 'Updated',
        address: 'Initial',
        phone: 'Initial',
        countryISOCode: 'Initial',
        createdAt: initialCustomer.createdAt,
      );

      verify(
        mockService.update(
          id: 1,
          name: 'Updated',
          address: 'Initial',
          phone: 'Initial',
          countryISOCode: 'Initial',
          observation: null,
          createdAt: initialCustomer.createdAt,
        ),
      ).called(1);

      expect(controller.state.value, [updatedCustomer]);
    });

    test('deleteCustomer calls service and updates state', () async {
      final customer = CustomerModel(
        id: 1,
        name: 'Test',
        address: 'Test',
        phone: 'Test',
        countryISOCode: 'Test',
        createdAt: DateTime.now(),
      );
      when(mockService.findAll()).thenAnswer((_) async => [customer]);
      when(mockService.delete(any)).thenAnswer((_) async => {});

      controller = CustomersController(service: mockService);
      await Future.delayed(Duration.zero);

      await controller.deleteCustomer(1);

      verify(mockService.delete(1)).called(1);

      expect(controller.state.value, []);
    });
  });
}
