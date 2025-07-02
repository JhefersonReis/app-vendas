class CustomerModel {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String? observation;
  final DateTime createdAt;

  CustomerModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.observation,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'observation': observation,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      observation: json['observation'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  CustomerModel copyWith({
    int? id,
    String? name,
    String? address,
    String? phone,
    String? observation,
    DateTime? createdAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      observation: observation ?? this.observation,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
