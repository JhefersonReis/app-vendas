class ItemModel {
  int productId;
  String productName;
  int quantity;
  double unitPrice;
  double totalPrice;
  double weight;
  String weightUnit;

  ItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.weight,
    required this.weightUnit,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'],
      totalPrice: json['totalPrice'],
      weight: json['weight'],
      weightUnit: json['weightUnit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'weight': weight,
      'weightUnit': weightUnit,
    };
  }

  copyWith({
    int? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    double? weight,
    String? weightUnit,
  }) {
    return ItemModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ItemModel &&
        other.productId == productId &&
        other.productName == productName &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice &&
        other.totalPrice == totalPrice &&
        other.weight == weight &&
        other.weightUnit == weightUnit;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        productName.hashCode ^
        quantity.hashCode ^
        unitPrice.hashCode ^
        totalPrice.hashCode ^
        weight.hashCode ^
        weightUnit.hashCode;
  }
}
