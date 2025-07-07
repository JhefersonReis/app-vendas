import 'package:organik_vendas/src/features/products/domain/product_model.dart';

class TopProduct {
  final ProductModel product;
  final int quantitySold;
  final double totalRevenue;

  TopProduct({
    required this.product,
    required this.quantitySold,
    required this.totalRevenue,
  });
}
