import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:organik_vendas/src/features/customers/controller/customers_controller.dart';
import 'package:organik_vendas/src/features/products/controller/product_controller.dart';
import 'package:organik_vendas/src/features/products/domain/product_model.dart';
import 'package:organik_vendas/src/features/sales/controller/sales_controller.dart';
import 'package:organik_vendas/src/features/sales/domain/item_model.dart';
import 'package:organik_vendas/src/features/sales/domain/sale_model.dart';
import 'package:organik_vendas/src/features/sales/widgets/sale_item_widget.dart';

class SaleFormPage extends ConsumerWidget {
  final String? id;

  const SaleFormPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (id != null) {
      final saleAsync = ref.watch(saleByIdProvider(int.parse(id!)));
      return saleAsync.when(
        loading: () => Scaffold(
          appBar: AppBar(title: const Text('Carregando...'), backgroundColor: const Color(0xFF248f3d)),
          body: const Center(child: CircularProgressIndicator()),
        ),
        error: (e, s) => Scaffold(
          appBar: AppBar(title: const Text('Erro'), backgroundColor: const Color(0xFF248f3d)),
          body: Center(child: Text('Erro ao carregar a venda: $e')),
        ),
        data: (sale) => _SaleForm(initialSale: sale, id: id),
      );
    } else {
      return _SaleForm(id: id);
    }
  }
}

class _SaleForm extends ConsumerStatefulWidget {
  final SaleModel? initialSale;
  final String? id;

  const _SaleForm({this.initialSale, this.id});

  @override
  ConsumerState<_SaleForm> createState() => _SaleFormState();
}

class _SaleFormState extends ConsumerState<_SaleForm> {
  final _selectedDate = TextEditingController();
  final _notesController = TextEditingController();

  int? _selectedCustomerId;
  List<ItemModel> _items = [];
  bool _isPaid = false;
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.initialSale != null) {
      final sale = widget.initialSale!;
      _selectedCustomerId = sale.customerId;
      _items = sale.items;
      _isPaid = sale.isPaid;
      _total = sale.total;
      _selectedDate.text = DateFormat('dd/MM/yyyy').format(sale.saleDate);
      _notesController.text = sale.observation ?? '';
    } else {
      _selectedDate.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    }
  }

  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formatedDate = DateFormat('dd/MM/yyyy').format(picked);
      setState(() {
        _selectedDate.text = formatedDate;
      });
    }
  }

  void _addItem(ItemModel item) {
    setState(() {
      _items.add(item);
      _calculateTotal();
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _calculateTotal();
    });
  }

  void _updateItem(int index, ItemModel item) {
    setState(() {
      _items[index] = item;
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    setState(() {
      _total = _items.fold(0.0, (sum, item) => sum + item.totalPrice);
    });
  }

  void _saveSale() {
    if (_selectedCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione um cliente')));
      return;
    }

    final customersState = ref.read(customersControllerProvider);
    final customerName = customersState.asData?.value.firstWhere((c) => c.id == _selectedCustomerId).name ?? '';

    final sale = SaleModel(
      id: widget.id != null ? int.parse(widget.id!) : 0,
      customerId: _selectedCustomerId!,
      customerName: customerName,
      saleDate: DateFormat('dd/MM/yyyy').parse(_selectedDate.text),
      items: _items,
      total: _total,
      isPaid: _isPaid,
      observation: _notesController.text,
      createdAt: widget.initialSale?.createdAt ?? DateTime.now(),
    );

    if (widget.id != null) {
      ref.read(salesControllerProvider.notifier).update(sale);
      ref.invalidate(
        saleByIdProvider(int.parse(widget.id!)),
      ); // Invalida o provider para atualizar a lista (se necessário)
    } else {
      ref.read(salesControllerProvider.notifier).create(sale);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customersControllerProvider);
    final products = ref.watch(productsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id != null ? "Editar Venda" : "Nova Venda",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF248f3d),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text.rich(
                TextSpan(
                  text: "Cliente ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              customers.when(
                data: (customerList) => DropdownButtonFormField<int>(
                  value: _selectedCustomerId,
                  onChanged: (value) {
                    setState(() {
                      _selectedCustomerId = value;
                    });
                  },
                  items: customerList.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Selecione um cliente'),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => const Center(child: Text('Erro ao carregar clientes')),
              ),
              const SizedBox(height: 16),
              const Text.rich(
                TextSpan(
                  text: "Data da Venda ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Selecione uma data",
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                onTap: _showDatePicker,
                readOnly: true,
                controller: _selectedDate,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text("Itens da Venda ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  IconButton(
                    onPressed: () => _showAddProductDialog(products.asData?.value ?? []),
                    icon: const Icon(Icons.add, color: Colors.white),
                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xFF248f3d))),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return SaleItemWidget(
                    item: item,
                    onDelete: () => _removeItem(index),
                    onUpdate: (updatedItem) => _updateItem(index, updatedItem),
                  );
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xFFD7F4DE),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total da Venda:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const Spacer(),
                    Text(
                      "R\$ ${_total.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF248f3d)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isPaid,
                    onChanged: (value) {
                      setState(() {
                        _isPaid = value ?? false;
                      });
                    },
                  ),
                  const Text("Venda já foi paga"),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Observações', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Observações sobre a venda",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF248f3d),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _saveSale,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.id == null ? 'Cadastrar' : 'Atualizar'} Venda',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddProductDialog(List<ProductModel> products) {
    ProductModel? selectedProduct;
    final quantityController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Produto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<ProductModel>(
              onChanged: (value) {
                selectedProduct = value;
              },
              items: products
                  .map(
                    (product) => DropdownMenuItem(
                      value: product,
                      child: Text(
                        '${product.name} - ${product.weightUnit == 'g' ? product.weight.toStringAsFixed(0) : product.weight.toStringAsFixed(1)}${product.weightUnit}',
                      ),
                    ),
                  )
                  .toList(),
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Selecione um produto'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Quantidade'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              if (selectedProduct != null) {
                final quantity = int.tryParse(quantityController.text) ?? 1;
                final item = ItemModel(
                  productId: selectedProduct!.id,
                  productName: selectedProduct!.name,
                  quantity: quantity,
                  unitPrice: selectedProduct!.price,
                  totalPrice: selectedProduct!.price * quantity,
                  weight: selectedProduct!.weight,
                  weightUnit: selectedProduct!.weightUnit,
                );
                _addItem(item);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
