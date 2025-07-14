import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:organik_vendas/l10n/app_localizations.dart';
import 'package:organik_vendas/src/app/helpers/toast_helper.dart';
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
      ToastHelper.showError(context, 'Selecione um cliente');
      return;
    }

    if (_items.isEmpty) {
      ToastHelper.showError(context, 'Adicione pelo menos um produto');
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
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id != null ? localization.editSale : localization.newSale,
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
              Text.rich(
                TextSpan(
                  text: localization.customer,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  children: [
                    TextSpan(
                      text: " *",
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
                  items: customerList
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  decoration: InputDecoration(border: OutlineInputBorder(), hintText: localization.selectACustomer),
                  menuMaxHeight: 200,
                  isExpanded: true,
                  selectedItemBuilder: (BuildContext context) {
                    final size = MediaQuery.of(context).size;

                    return customerList.map<Widget>((customer) {
                      return Container(
                        constraints: BoxConstraints(maxWidth: size.width * 0.8),
                        child: Text(customer.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                      );
                    }).toList();
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => const Center(child: Text('Erro ao carregar clientes')),
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  text: localization.dateOfSale,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  children: [
                    TextSpan(
                      text: " *",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: localization.selectADate,
                  suffixIcon: Icon(Icons.calendar_month),
                ),
                onTap: _showDatePicker,
                readOnly: true,
                controller: _selectedDate,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(localization.saleItems, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
                    Text("${localization.totalSale}:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const Spacer(),
                    Text(
                      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$', decimalDigits: 2).format(_total),
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
                  Text(localization.saleAlreadyPaid),
                ],
              ),
              const SizedBox(height: 16),
              Text(localization.observations, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: localization.saleNotes,
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
                      widget.id == null ? localization.createSale : localization.updateSale,
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

  void _showAddProductDialog(List<ProductModel> products) async {
    ProductModel? selectedProduct;
    final quantityController = TextEditingController(text: '1');

    await showDialog(
      context: context,
      builder: (dialogContext) => Consumer(
        builder: (context, ref, child) {
          final localization = AppLocalizations.of(dialogContext)!;

          return AlertDialog(
            title: Text(localization.addProduct),
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
                          child: Row(
                            children: [
                              product.name.length > 25
                                  ? Expanded(child: Text(product.name, overflow: TextOverflow.ellipsis))
                                  : Text(product.name),
                              Text(
                                ' - ${product.weightUnit == 'g' ? product.weight.toStringAsFixed(0) : product.weight.toStringAsFixed(1)}${product.weightUnit}',
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: localization.selectAProduct),
                  selectedItemBuilder: (BuildContext context) {
                    final size = MediaQuery.of(context).size;
                    final maxWidth = size.width * 0.5;

                    return products.map<Widget>((product) {
                      return Container(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList();
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(border: OutlineInputBorder(), labelText: localization.quantity),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(localization.cancel)),
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
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: Text(localization.add),
              ),
            ],
          );
        },
      ),
    );
  }
}
