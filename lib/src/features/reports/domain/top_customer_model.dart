import 'package:organik_vendas/src/features/customers/domain/customer_model.dart';

class TopCustomer {
  final CustomerModel customer;
  final int totalPurchases;
  final double totalSpent;

  TopCustomer({
    required this.customer,
    required this.totalPurchases,
    required this.totalSpent,
  });
}
