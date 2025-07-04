import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    productPrice.text = product.price.toString();
    productWeight.text = product.weight.toString();
    productWeightUnit.text = product.weightUnit;
    productDescription.text = product.description;
  }

  Future<void> _saveProduct() async {
    if (widget.id != null) {
      final product = await ref.read(productByIdProvider(int.parse(widget.id!)).future);

      await ref
          .read(productsControllerProvider.notifier)
          .updateProduct(
            id: product.id,
            name: productName.text,
            price: double.parse(productPrice.text),
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
            price: double.parse(productPrice.text),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id == null ? 'Novo Produto' : 'Editar Produto',
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
            const Text.rich(
              TextSpan(
                text: "Nome do Produto ",
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
              controller: productName,
              decoration: const InputDecoration(hintText: 'Digite o nome do produto', border: OutlineInputBorder()),
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
                      const Text.rich(
                        TextSpan(
                          text: "Preço (R\$) ",
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
                        decoration: const InputDecoration(hintText: '0,00', border: OutlineInputBorder()),
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
                      const Text.rich(
                        TextSpan(
                          text: "Peso ",
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
                        controller: productWeight,
                        decoration: const InputDecoration(hintText: '1', border: OutlineInputBorder()),
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
            const Text.rich(
              TextSpan(
                text: "Descrição ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                children: [TextSpan(text: "(opcional)", style: TextStyle(fontSize: 12))],
              ),
            ),
            TextField(
              controller: productDescription,
              decoration: const InputDecoration(
                hintText: 'Digite a descrição do produto',
                border: OutlineInputBorder(),
              ),
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
                    '${widget.id == null ? 'Cadastrar' : 'Atualizar'} Produto',
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
}
