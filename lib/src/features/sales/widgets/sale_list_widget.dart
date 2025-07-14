import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:organik_vendas/l10n/app_localizations.dart';
import 'package:organik_vendas/src/features/sales/controller/sales_controller.dart';

class SaleListWidget extends ConsumerWidget {
  const SaleListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredSales = ref.watch(filteredSalesProvider);
    final localization = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: localization.search,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                onChanged: (value) {
                  ref.read(salesFilterProvider.notifier).state = value;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PopupMenuButton(
                offset: Offset(0, 30),
                tooltip: localization.filterBy,
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(value: SalesStatusFilter.all, child: Text(localization.all)),
                    PopupMenuItem(value: SalesStatusFilter.unpaid, child: Text(localization.pendings)),
                    PopupMenuItem(value: SalesStatusFilter.paid, child: Text(localization.paids)),
                  ];
                },
                onSelected: (value) {
                  ref.read(salesStatusFilterProvider.notifier).state = value;
                },
                child: Icon(Icons.filter_list),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: filteredSales.isEmpty
              ? Center(
                  child: Text(
                    localization.noSalesFoundWithThisFilter,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(salesControllerProvider.notifier).findAll();
                  },
                  child: ListView.builder(
                    itemCount: filteredSales.length,
                    itemBuilder: (context, index) {
                      final sale = filteredSales[index];
                      return Dismissible(
                        key: Key(sale.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          ref.read(salesControllerProvider.notifier).delete(sale.id);
                        },
                        confirmDismiss: (direction) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(localization.deleteConfirmTitle),
                                content: Text(localization.areYouSureYouWantToDeleteThisSale),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text(localization.cancel),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: Text(localization.delete, style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              );
                            },
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.person, size: 18, color: Colors.grey),
                                        const SizedBox(width: 5),
                                        Text(sale.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () => context.go('/sales/form?id=${sale.id}'),
                                      child: Text(localization.seeDetails, style: TextStyle(color: Colors.green)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Text(DateFormat('dd/MM/yyyy').format(sale.saleDate)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.attach_money, size: 18, color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Text(
                                      NumberFormat.simpleCurrency(locale: 'pt_BR').format(sale.total),
                                      style: const TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      sale.isPaid ? Icons.check_circle : Icons.warning,
                                      size: 18,
                                      color: sale.isPaid ? Colors.green : Colors.orange,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      sale.isPaid ? localization.paid : localization.pending,
                                      style: TextStyle(color: sale.isPaid ? Colors.green : Colors.orange),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${sale.items.length} ${localization.item}(s) - ${sale.items.fold(0, (int sum, item) => sum + item.quantity)} ${localization.product}(s)',
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
