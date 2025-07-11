import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:organik_vendas/src/features/products/controller/product_controller.dart';
import 'package:organik_vendas/src/features/products/domain/product_model.dart';
import 'package:organik_vendas/src/features/products/domain/product_service.dart';

import 'product_controller_test.mocks.dart';

@GenerateMocks([ProductService])
void main() {
  group('ProductController', () {
    late ProductController controller;
    late MockProductService mockService;

    setUp(() {
      mockService = MockProductService();
      reset(mockService);
    });

    test('initial state is loading and loads products', () async {
      final products = [
        ProductModel(
          id: 1,
          name: 'Test',
          price: 1.0,
          weight: 1.0,
          weightUnit: 'kg',
          description: 'Test',
          createdAt: DateTime.now(),
        ),
      ];
      when(mockService.findAll()).thenAnswer((_) async => products);

      controller = ProductController(service: mockService);

      expect(controller.state, const AsyncLoading<List<ProductModel>>());

      await untilCalled(mockService.findAll());

      verify(mockService.findAll()).called(1);

      expect(controller.state.value, products);
    });

    test('createProduct calls service and updates state', () async {
      final newProduct = ProductModel(
        id: 2,
        name: 'New',
        price: 2.0,
        weight: 2.0,
        weightUnit: 'kg',
        description: 'New',
        createdAt: DateTime.now(),
      );
      when(mockService.findAll()).thenAnswer((_) async => []);
      when(
        mockService.create(
          name: anyNamed('name'),
          description: anyNamed('description'),
          weight: anyNamed('weight'),
          weightUnit: anyNamed('weightUnit'),
          price: anyNamed('price'),
          createdAt: anyNamed('createdAt'),
        ),
      ).thenAnswer((_) async => newProduct);

      controller = ProductController(service: mockService);
      await untilCalled(mockService.findAll());

      await controller.createProduct(name: 'New', description: 'New', weight: 2.0, weightUnit: 'kg', price: 2.0);

      verify(
        mockService.create(
          name: 'New',
          description: 'New',
          weight: 2.0,
          weightUnit: 'kg',
          price: 2.0,
          createdAt: anyNamed('createdAt'),
        ),
      ).called(1);

      expect(controller.state.value, [newProduct]);
    });

    test('updateProduct calls service and updates state', () async {
      final initialProduct = ProductModel(
        id: 1,
        name: 'Initial',
        price: 1.0,
        weight: 1.0,
        weightUnit: 'kg',
        description: 'Initial',
        createdAt: DateTime.now(),
      );
      final updatedProduct = initialProduct.copyWith(name: 'Updated');

      when(mockService.findAll()).thenAnswer((_) async => [initialProduct]);
      when(
        mockService.update(
          id: anyNamed('id'),
          name: anyNamed('name'),
          description: anyNamed('description'),
          weight: anyNamed('weight'),
          weightUnit: anyNamed('weightUnit'),
          price: anyNamed('price'),
          createdAt: anyNamed('createdAt'),
        ),
      ).thenAnswer((_) async => updatedProduct);

      controller = ProductController(service: mockService);
      await untilCalled(mockService.findAll());

      await controller.updateProduct(
        id: 1,
        name: 'Updated',
        description: 'Initial',
        weight: 1.0,
        weightUnit: 'kg',
        price: 1.0,
        createdAt: initialProduct.createdAt,
      );

      verify(
        mockService.update(
          id: 1,
          name: 'Updated',
          description: 'Initial',
          weight: 1.0,
          weightUnit: 'kg',
          price: 1.0,
          createdAt: initialProduct.createdAt,
        ),
      ).called(1);

      expect(controller.state.value, [updatedProduct]);
    });

    test('deleteProduct calls service and updates state', () async {
      final product = ProductModel(
        id: 1,
        name: 'Test',
        price: 1.0,
        weight: 1.0,
        weightUnit: 'kg',
        description: 'Test',
        createdAt: DateTime.now(),
      );
      when(mockService.findAll()).thenAnswer((_) async => [product]);
      when(mockService.delete(any)).thenAnswer((_) async => {});

      controller = ProductController(service: mockService);
      await untilCalled(mockService.findAll());

      await controller.deleteProduct(1);

      verify(mockService.delete(1)).called(1);

      expect(controller.state.value, []);
    });
  });
}
