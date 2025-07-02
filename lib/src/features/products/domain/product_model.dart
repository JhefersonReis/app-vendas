class ProductModel {
  int id;
  String name;
  double price;
  double weight;
  String weightUnit;
  String description;
  DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.weight,
    required this.weightUnit,
    required this.description,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      weight: json['weight'],
      weightUnit: json['weightUnit'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'weight': weight,
      'weightUnit': weightUnit,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  copyWith({
    int? id,
    String? name,
    double? price,
    double? weight,
    String? weightUnit,
    String? description,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
