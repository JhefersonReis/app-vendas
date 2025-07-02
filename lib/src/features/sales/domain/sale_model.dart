import 'package:organik_vendas/src/features/sales/domain/item_model.dart';

class SaleModel {
  int id;
  int customerId;
  String customerName;
  DateTime saleDate;
  List<ItemModel> items;
  double total;
  bool isPaid;
  DateTime createdAt;

  SaleModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.saleDate,
    required this.items,
    required this.total,
    required this.isPaid,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'customer_name': customerName,
      'sale_date': saleDate.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'is_paid': isPaid ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'],
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      saleDate: DateTime.parse(json['sale_date']),
      items: (json['items'] as List)
          .map((item) => ItemModel.fromJson(item))
          .toList(),
      total: json['total'],
      isPaid: json['is_paid'] == 1,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
