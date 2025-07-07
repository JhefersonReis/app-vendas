import 'package:flutter/material.dart';
import 'package:organik_vendas/src/features/sales/domain/item_model.dart';

class SaleItemWidget extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onDelete;
  final ValueChanged<ItemModel> onUpdate;

  const SaleItemWidget({super.key, required this.item, required this.onDelete, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final quantityController = TextEditingController(text: item.quantity.toString());

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Tooltip(
                      message: item.productName,
                      child: Text(item.productName, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  Text(
                    ' - ${item.weightUnit == 'g' ? item.weight.toStringAsFixed(0) : item.weight.toStringAsFixed(1)}${item.weightUnit}',
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 50,
              child: TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  final quantity = int.tryParse(value) ?? 0;
                  onUpdate(item.copyWith(quantity: quantity, totalPrice: item.unitPrice * quantity));
                },
              ),
            ),
            const SizedBox(width: 8),
            Text('R\$ ${item.unitPrice.toStringAsFixed(2)}'),
            const SizedBox(width: 8),
            Text('R\$ ${item.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
