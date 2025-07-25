import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zello/l10n/app_localizations.dart';
import 'package:zello/src/app/helpers/currency_helper.dart';
import 'package:zello/src/app/helpers/toast_helper.dart';
import 'package:zello/src/features/customers/controller/customers_controller.dart';
import 'package:zello/src/features/products/controller/product_controller.dart';
import 'package:zello/src/features/products/domain/product_model.dart';
import 'package:zello/src/features/sales/controller/sales_controller.dart';
import 'package:zello/src/features/sales/domain/installment_model.dart';
import 'package:zello/src/features/sales/domain/item_model.dart';
import 'package:zello/src/features/sales/domain/sale_model.dart';
import 'package:zello/src/features/sales/widgets/sale_item_widget.dart';
import 'package:zello/src/features/sales/widgets/installment_list_widget.dart';

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
  final _searchController = TextEditingController();

  final _installmentsController = TextEditingController();

  int? _selectedCustomerId;
  List<ItemModel> _items = [];
  bool _isPaid = false;
  bool _isInstallment = false;
  List<InstallmentModel> _installments = [];
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.initialSale != null) {
      final sale = widget.initialSale!;
      _selectedCustomerId = sale.customerId;
      _items = sale.items;
      _isPaid = sale.isPaid;
      _isInstallment = sale.isInstallment;
      if (_isInstallment) {
        _installments = sale.installmentList;
        _installmentsController.text = sale.installments.toString();
      }
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
      // Procura se o produto já existe na lista
      final existingItemIndex = _items.indexWhere((existingItem) => existingItem.productId == item.productId);

      if (existingItemIndex != -1) {
        // Se o produto já existe, soma a quantidade e atualiza o preço total
        final existingItem = _items[existingItemIndex];
        final newQuantity = existingItem.quantity + item.quantity;
        final newTotalPrice = existingItem.unitPrice * newQuantity;

        _items[existingItemIndex] = ItemModel(
          productId: existingItem.productId,
          productName: existingItem.productName,
          quantity: newQuantity,
          unitPrice: existingItem.unitPrice,
          totalPrice: newTotalPrice,
          weight: existingItem.weight,
          weightUnit: existingItem.weightUnit,
        );
      } else {
        // Se o produto não existe, adiciona normalmente
        _items.add(item);
      }

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
      if (_isInstallment) {
        _calculateInstallments();
      }
    });
  }

  void _calculateInstallments() {
    final installmentCount = int.tryParse(_installmentsController.text) ?? 0;
    if (installmentCount > 0) {
      final installmentValue = _total / installmentCount;
      final installments = <InstallmentModel>[];
      for (var i = 1; i <= installmentCount; i++) {
        installments.add(
          InstallmentModel(
            id: 0,
            saleId: widget.id != null ? int.parse(widget.id!) : 0,
            installmentNumber: i,
            value: installmentValue,
            dueDate: DateTime.now().add(Duration(days: 30 * i)),
            isPaid: false,
          ),
        );
      }
      setState(() {
        _installments = installments;
      });
    } else {
      setState(() {
        _installments.clear();
      });
    }
  }

  void _saveSale() {
    final localization = AppLocalizations.of(context)!;

    if (_selectedCustomerId == null) {
      ToastHelper.showError(context, localization.selectOneClient);
      return;
    }

    if (_items.isEmpty) {
      ToastHelper.showError(context, localization.addAtLeastOneProduct);
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
      isInstallment: _isInstallment,
      installments: int.tryParse(_installmentsController.text) ?? 0,
      installmentList: _installments,
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
                data: (customerList) => DropdownMenu<int>(
                  controller: _searchController,
                  enableFilter: true,
                  requestFocusOnTap: true,
                  initialSelection: _selectedCustomerId,
                  onSelected: (value) {
                    setState(() {
                      _selectedCustomerId = value;
                    });
                  },
                  dropdownMenuEntries: customerList
                      .map((c) => DropdownMenuEntry<int>(value: c.id, label: c.name))
                      .toList(),
                  textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
                  width: MediaQuery.of(context).size.width - 32,
                  menuHeight: 200,
                  inputDecorationTheme: InputDecorationTheme(border: OutlineInputBorder()),
                  hintText: localization.selectACustomer,
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
                      CurrencyHelper.formatCurrency(context, _total),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF248f3d)),
                    ),
                  ],
                ),
              ),
              if (!_isInstallment) ...[
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
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isInstallment,
                    onChanged: (value) {
                      setState(() {
                        _isInstallment = value ?? false;
                        if (!_isInstallment) {
                          _installments.clear();
                          _installmentsController.clear();
                        }
                      });
                    },
                  ),
                  Text(localization.installmentSale),
                ],
              ),
              if (_isInstallment) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _installmentsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: localization.numberOfInstallments,
                  ),
                  onChanged: (value) {
                    _calculateInstallments();
                  },
                ),
                const SizedBox(height: 16),
                InstallmentListWidget(
                  installments: _installments,
                  onInstallmentSelected: (installment) {
                    // Calcular se todas as parcelas estão pagas
                    final allPaid = _installments.every((i) => i.isPaid);

                    setState(() {
                      allPaid ? _isPaid = true : _isPaid = false;
                      _installments = List.from(_installments);
                    });
                  },
                ),
              ],
              const SizedBox(height: 16),
              Text(localization.observations, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: localization.saleNotes,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
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
          final size = MediaQuery.of(context).size;

          return AlertDialog(
            title: Text(localization.addProduct),
            content: SizedBox(
              width: size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownMenu<ProductModel>(
                    enableFilter: true,
                    requestFocusOnTap: true,
                    onSelected: (value) {
                      selectedProduct = value;
                    },
                    dropdownMenuEntries: products
                        .map(
                          (product) => DropdownMenuEntry<ProductModel>(
                            value: product,
                            label:
                                '${product.name} - ${product.weightUnit == 'g' || product.weightUnit == 'un' ? product.weight.toStringAsFixed(0) : product.weight.toStringAsFixed(1)}${product.weightUnit}',
                          ),
                        )
                        .toList(),
                    textStyle: const TextStyle(overflow: TextOverflow.ellipsis),
                    width: size.width * 0.7,
                    menuHeight: 300,
                    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
                    hintText: localization.selectAProduct,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(border: OutlineInputBorder(), labelText: localization.quantity),
                  ),
                ],
              ),
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
