import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:organik_vendas/src/features/sales/controller/sales_controller.dart';
import 'package:organik_vendas/src/features/sales/domain/sale_model.dart';

class SalesPage extends ConsumerWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sales = ref.watch(salesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vendas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF248f3d),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: sales.when(
          data: (saleList) => saleList.isEmpty ? _buildEmptyState(context) : _buildVendasList(saleList, ref),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Erro ao carregar vendas: $e')),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/sales/form'),
        backgroundColor: const Color(0xFF248f3d),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 50, color: Colors.grey),
              const SizedBox(height: 10),
              const Text('Nenhuma venda registrada', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('Comece registrando sua primeira venda'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => context.go('/sales/form'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF248f3d),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Registrar Primeira Venda'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVendasList(List<SaleModel> vendas, WidgetRef ref) {
    return ListView.builder(
      itemCount: vendas.length,
      itemBuilder: (context, index) {
        final venda = vendas[index];
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
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Excluir Venda'),
                  content: const Text('Tem certeza que deseja excluir esta venda?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
                    TextButton(
                      onPressed: () {
                        ref.read(salesControllerProvider.notifier).delete(venda.id);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );
          },
          child: Consumer(
            builder: (context, ref, child) => GestureDetector(
              onLongPress: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Excluir Venda'),
                      content: const Text('Tem certeza que deseja excluir esta venda?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
                        TextButton(
                          onPressed: () {
                            ref.read(salesControllerProvider.notifier).delete(venda.id);
                            Navigator.of(context).pop();
                          },
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
            ),
          ),
        );
      },
    );
  }
}
