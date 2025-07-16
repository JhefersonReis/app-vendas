import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zello/l10n/app_localizations.dart';
import 'package:zello/src/app/helpers/currency_helper.dart';
import 'package:zello/src/features/products/controller/product_controller.dart';

class ProductListWidget extends ConsumerWidget {
  const ProductListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProducts = ref.watch(filteredProductsProvider);
    final localization = AppLocalizations.of(context)!;

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: localization.search,
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          onChanged: (value) {
            ref.read(productsFilterProvider.notifier).state = value;
          },
        ),
        const SizedBox(height: 10),
        Expanded(
          child: filteredProducts.isEmpty
              ? Center(
                  child: Text(
                    localization.noProductsFoundWithThisFilter,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(productsControllerProvider.notifier).loadProducts();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Dismissible(
                        key: ValueKey(product.id),
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          ref.read(productsControllerProvider.notifier).deleteProduct(product.id);
                        },
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(localization.deleteConfirmTitle),
                              content: Text(localization.areYouSureYouWantToDeleteThisProduct),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text(localization.cancel),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                  child: Text(localization.delete),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => context.go('/products/form?id=${product.id}'),
                                      icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Text(
                                  CurrencyHelper.formatCurrency(context, product.price),
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${product.weightUnit == 'kg' ? product.weight.toStringAsFixed(1) : product.weight.toStringAsFixed(0)} ${product.weightUnit}',
                                ),
                                if (product.description.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${localization.observations}: ${product.description}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}
