import 'package:zello/src/features/customers/domain/customer_model.dart';

class TopCustomer {
  final CustomerModel customer;
  final int totalPurchases;
  final double totalSpent;

  TopCustomer({required this.customer, required this.totalPurchases, required this.totalSpent});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TopCustomer &&
        other.customer == customer &&
        other.totalPurchases == totalPurchases &&
        other.totalSpent == totalSpent;
  }

  @override
  int get hashCode {
    return customer.hashCode ^ totalPurchases.hashCode ^ totalSpent.hashCode;
  }
}
