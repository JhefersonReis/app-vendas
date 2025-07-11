import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:organik_vendas/src/features/home/controller/home_controller.dart';

class MockRef extends Mock implements Ref {}

void main() {
  group('HomeController', () {
    test('can be instantiated', () {
      final mockRef = MockRef();
      expect(HomeController(mockRef), isA<HomeController>());
    });
  });
}