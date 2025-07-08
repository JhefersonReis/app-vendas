import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:organik_vendas/src/features/sales/controller/sales_controller.dart';

class SaleListWidget extends ConsumerWidget {
  const SaleListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredSales = ref.watch(filteredSalesProvider);

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Pesquisar',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          onChanged: (value) {
            ref.read(salesFilterProvider.notifier).state = value;
          },
        ),
        const SizedBox(height: 8),
        Expanded(
          child: filteredSales.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhuma venda encontrada com esse filtro',
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
                      final venda = filteredSales[index];
                      return Dismissible(
                        key: Key(venda.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          ref.read(salesControllerProvider.notifier).delete(venda.id);
                        },
                        confirmDismiss: (direction) async {
                          return await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Excluir Venda'),
                                content: const Text('Tem certeza que deseja excluir esta venda?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Excluir', style: TextStyle(color: Colors.red)),
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
                                        Text(venda.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () => context.go('/sales/form?id=${venda.id}'),
                                      child: const Text('Ver Detalhes', style: TextStyle(color: Colors.green)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Text(DateFormat('dd/MM/yyyy').format(venda.saleDate)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.attach_money, size: 18, color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Text(
                                      NumberFormat.simpleCurrency(locale: 'pt_BR').format(venda.total),
                                      style: const TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      venda.isPaid ? Icons.check_circle : Icons.warning,
                                      size: 18,
                                      color: venda.isPaid ? Colors.green : Colors.orange,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      venda.isPaid ? 'Pago' : 'Pendente',
                                      style: TextStyle(color: venda.isPaid ? Colors.green : Colors.orange),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${venda.items.length} item(s) - ${venda.items.fold(0, (int sum, item) => sum + item.quantity)} produto(s)',
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
