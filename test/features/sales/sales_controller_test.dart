import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:zello/src/features/sales/controller/sales_controller.dart';
import 'package:zello/src/features/sales/domain/sale_model.dart';
import 'package:zello/src/features/sales/domain/sales_service.dart';

import 'sales_controller_test.mocks.dart';

@GenerateMocks([SalesService, Ref])
void main() {
  group('SalesController', () {
    late SalesController controller;
    late MockSalesService mockService;
    late MockRef mockRef;

    setUp(() {
      mockService = MockSalesService();
      mockRef = MockRef();
      reset(mockService);
      reset(mockRef);

      // Provide dummy values for StateController
      provideDummy<StateController<String>>(StateController(''));
      provideDummy<StateController<SalesStatusFilter>>(StateController(SalesStatusFilter.all));
    });

    test('initial state is loading and loads sales', () async {
      final sales = [
        SaleModel(
          id: 1,
          customerId: 1,
          customerName: 'Test',
          saleDate: DateTime.now(),
          items: [],
          total: 10.0,
          isPaid: true,
          isInstallment: false,
          installments: 0,
          installmentList: [],
          observation: 'Test sale',
          createdAt: DateTime.now(),
        ),
      ];
      when(mockService.findAll()).thenAnswer((_) async => sales);

      controller = SalesController(mockService, mockRef);

      expect(controller.state, const AsyncLoading<List<SaleModel>>());

      await untilCalled(mockService.findAll());

      verify(mockService.findAll()).called(1);

      expect(controller.state.value, sales);
    });

    test('create calls service and updates state', () async {
      final newSale = SaleModel(
        id: 2,
        customerId: 1,
        customerName: 'New',
        saleDate: DateTime.now(),
        items: [],
        total: 20.0,
        isPaid: false,
        isInstallment: false,
        installments: 0,
        installmentList: [],
        observation: 'New sale',
        createdAt: DateTime.now(),
      );
      when(mockService.findAll()).thenAnswer((_) async => []); // Initial state
      when(mockService.create(any)).thenAnswer((Invocation invocation) async => invocation.positionalArguments[0]);

      controller = SalesController(mockService, mockRef);
      await untilCalled(mockService.findAll());

      // Mock findAll to return the new sale after creation
      when(mockService.findAll()).thenAnswer((_) async => [newSale]);

      await controller.create(newSale);

      verify(mockService.create(newSale)).called(1);
      verify(mockService.findAll()).called(2); // Called once in constructor, once after create

      expect(controller.state.value, [newSale]);
    });

    test('update calls service and updates state', () async {
      final initialSale = SaleModel(
        id: 1,
        customerId: 1,
        customerName: 'Initial',
        saleDate: DateTime.now(),
        items: [],
        total: 10.0,
        isPaid: true,
        isInstallment: false,
        installments: 0,
        installmentList: [],
        observation: 'Initial sale',
        createdAt: DateTime.now(),
      );
      final updatedSale = initialSale.copyWith(customerName: 'Updated');

      when(mockService.findAll()).thenAnswer((_) async => [initialSale]); // Initial state
      when(mockService.update(any)).thenAnswer((Invocation invocation) async => invocation.positionalArguments[0]);

      controller = SalesController(mockService, mockRef);
      await untilCalled(mockService.findAll());

      // Mock findAll to return the updated sale after update
      when(mockService.findAll()).thenAnswer((_) async => [updatedSale]);

      await controller.update(updatedSale);

      verify(mockService.update(updatedSale)).called(1);
      verify(mockService.findAll()).called(2);

      expect(controller.state.value, [updatedSale]);
    });

    test('delete calls service and updates state', () async {
      final sale = SaleModel(
        id: 1,
        customerId: 1,
        customerName: 'Test',
        saleDate: DateTime.now(),
        items: [],
        total: 10.0,
        isPaid: true,
        isInstallment: false,
        installments: 0,
        installmentList: [],
        observation: 'Test sale',
        createdAt: DateTime.now(),
      );
      when(mockService.findAll()).thenAnswer((_) async => [sale]); // Initial state
      when(mockService.delete(any)).thenAnswer((_) async => {});

      controller = SalesController(mockService, mockRef);
      await untilCalled(mockService.findAll());

      // Mock findAll to return an empty list after deletion
      when(mockService.findAll()).thenAnswer((_) async => []);

      await controller.delete(1);

      verify(mockService.delete(1)).called(1);
      verify(mockService.findAll()).called(2);

      expect(controller.state.value, []);
    });

    test('search updates salesFilterProvider', () {
      final salesFilterNotifier = StateController<String>('');
      when(mockRef.read(salesFilterProvider.notifier)).thenReturn(salesFilterNotifier);

      controller = SalesController(mockService, mockRef);
      controller.search('query');

      expect(salesFilterNotifier.state, 'query');
    });

    test('setStatusFilter updates salesStatusFilterProvider', () {
      final salesStatusFilterNotifier = StateController<SalesStatusFilter>(SalesStatusFilter.all);
      when(mockRef.read(salesStatusFilterProvider.notifier)).thenReturn(salesStatusFilterNotifier);

      controller = SalesController(mockService, mockRef);
      controller.setStatusFilter(SalesStatusFilter.paid);

      expect(salesStatusFilterNotifier.state, SalesStatusFilter.paid);
    });
  });
}
