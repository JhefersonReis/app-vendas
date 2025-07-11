import 'package:organik_vendas/src/features/sales/domain/item_model.dart';

class SaleModel {
  int id;
  int customerId;
  String customerName;
  DateTime saleDate;
  List<ItemModel> items;
  double total;
  bool isPaid;
  String? observation;
  DateTime createdAt;

  SaleModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.saleDate,
    required this.items,
    required this.total,
    required this.isPaid,
    this.observation,
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
      'observation': observation,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'],
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      saleDate: DateTime.parse(json['sale_date']),
      items: (json['items'] as List).map((item) => ItemModel.fromJson(item)).toList(),
      total: json['total'],
      isPaid: json['is_paid'] == 1,
      observation: json['observation'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  copyWith({
    int? id,
    int? customerId,
    String? customerName,
    DateTime? saleDate,
    List<ItemModel>? items,
    double? total,
    bool? isPaid,
    String? observation,
    DateTime? createdAt,
  }) {
    return SaleModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      saleDate: saleDate ?? this.saleDate,
      items: items ?? this.items,
      total: total ?? this.total,
      isPaid: isPaid ?? this.isPaid,
      observation: observation ?? this.observation,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SaleModel &&
        other.id == id &&
        other.customerId == customerId &&
        other.customerName == customerName &&
        other.saleDate == saleDate &&
        other.items == items &&
        other.total == total &&
        other.isPaid == isPaid &&
        other.observation == observation &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        customerId.hashCode ^
        customerName.hashCode ^
        saleDate.hashCode ^
        items.hashCode ^
        total.hashCode ^
        isPaid.hashCode ^
        observation.hashCode ^
        createdAt.hashCode;
  }
}
