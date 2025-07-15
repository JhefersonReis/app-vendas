import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:organik_vendas/l10n/app_localizations.dart';
import 'package:organik_vendas/src/app/helpers/currency_helper.dart';
import 'package:organik_vendas/src/app/helpers/toast_helper.dart';
import 'package:organik_vendas/src/features/products/controller/product_controller.dart';

class ProductFormPage extends ConsumerStatefulWidget {
  final String? id;

  const ProductFormPage({super.key, this.id});

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final productName = TextEditingController();
  final productPrice = TextEditingController();
  final productWeight = TextEditingController();
  final productWeightUnit = TextEditingController(text: 'g');
  final productDescription = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadProduct(int.parse(widget.id!));
      });
    }
  }

  @override
  void dispose() {
    productName.dispose();
    productPrice.dispose();
    productWeight.dispose();
    productWeightUnit.dispose();
    productDescription.dispose();
    super.dispose();
  }

  Future<void> _loadProduct(int id) async {
    final product = await ref.read(productByIdProvider(id).future);

    productName.text = product.name;
    productPrice.text = toCurrencyString(
      product.price.toString(),
      leadingSymbol: 'R\$',
      useSymbolPadding: true,
      thousandSeparator: ThousandSeparator.Period,
      mantissaLength: 2,
      trailingSymbol: '',
    );
    productWeight.text = product.weight.toString();
    productWeightUnit.text = product.weightUnit;
    productDescription.text = product.description;
  }

  Future<void> _saveProduct() async {
    final localization = AppLocalizations.of(context)!;

    if (productName.text.isEmpty) {
      ToastHelper.showError(context, localization.productNameIsRequired);
      return;
    }

    if (productPrice.text.isEmpty) {
      ToastHelper.showError(context, localization.productPriceIsRequired);
      return;
    }

    if (productWeight.text.isEmpty) {
      ToastHelper.showError(context, localization.productWeightIsRequired);
      return;
    }

    final price = _parseCurrencyToDouble(productPrice.text);

    if (widget.id != null) {
      final product = await ref.read(productByIdProvider(int.parse(widget.id!)).future);

      await ref
          .read(productsControllerProvider.notifier)
          .updateProduct(
            id: product.id,
            name: productName.text,
            price: price,
            weight: double.parse(productWeight.text),
            weightUnit: productWeightUnit.text,
            description: productDescription.text,
            createdAt: product.createdAt,
          );

      ref.invalidate(productByIdProvider(int.parse(widget.id!)));
    } else {
      await ref
          .read(productsControllerProvider.notifier)
          .createProduct(
            name: productName.text,
            price: price,
            weight: double.parse(productWeight.text),
            weightUnit: productWeightUnit.text,
            description: productDescription.text,
          );
    }

    if (context.mounted && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? localization.newProduct : localization.editProduct,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF248f3d),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: localization.productName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: " *",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            TextField(
              controller: productName,
              decoration: InputDecoration(hintText: localization.enterTheProductName, border: OutlineInputBorder()),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "${localization.price} (${CurrencyHelper.getCurrencySymbol(context)}) ",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: "*",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      TextField(
                        controller: productPrice,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CurrencyInputFormatter(
                            leadingSymbol: CurrencyHelper.getCurrencySymbol(context),
                            useSymbolPadding: true,
                            thousandSeparator: ThousandSeparator.Period,
                            mantissaLength: 2,
                          ),
                        ],
                        decoration: InputDecoration(
                          hintText: '${CurrencyHelper.getCurrencySymbol(context)} 0,00',
                          border: OutlineInputBorder(),
                        ),
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: localization.weight,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: " *",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      TextField(
                        controller: productWeight,
                        decoration: const InputDecoration(hintText: '0', border: OutlineInputBorder()),
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.0285),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                          isDense: true,
                        ),
                        value: productWeightUnit.text,
                        items: const [
                          DropdownMenuItem(value: 'g', child: Text('g')),
                          DropdownMenuItem(value: 'kg', child: Text('kg')),
                        ],
                        onChanged: (value) {
                          productWeightUnit.text = value!;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text.rich(
              TextSpan(
                text: localization.description,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                children: [TextSpan(text: " (${localization.optional})", style: TextStyle(fontSize: 12))],
              ),
            ),
            TextField(
              controller: productDescription,
              decoration: InputDecoration(hintText: localization.productNote, border: OutlineInputBorder()),
              maxLines: 3,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF248f3d),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _saveProduct,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.save, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    widget.id == null ? localization.createProduct : localization.updateProduct,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _parseCurrencyToDouble(String currency) {
    return double.parse(currency.replaceAll('R\$', '').replaceAll('\$', '').replaceAll('.', '').replaceAll(',', '.'));
  }
}
