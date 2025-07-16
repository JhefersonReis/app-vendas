import 'package:zello/src/features/products/domain/product_model.dart';

class TopProduct {
  final ProductModel product;
  final int quantitySold;
  final double totalRevenue;

  TopProduct({required this.product, required this.quantitySold, required this.totalRevenue});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TopProduct &&
        other.product == product &&
        other.quantitySold == quantitySold &&
        other.totalRevenue == totalRevenue;
  }

  @override
  int get hashCode {
    return product.hashCode ^ quantitySold.hashCode ^ totalRevenue.hashCode;
  }
}
