import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:organik_vendas/src/features/home/controller/home_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeControllerProvider.notifier).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Controle de Vendas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF248f3d),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeControllerProvider.notifier).loadData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Resumo de Hoje
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumo de Hoje',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                NumberFormat.simpleCurrency(locale: 'pt_BR').format(state.totalSoldToday),
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Text('Total Vendido'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                state.todayOrders.toString(),
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const Text('Pedidos'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Ações Rápidas
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ações Rápidas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => context.go('/sales/form'),
                        icon: const Icon(Icons.add),
                        label: const Text('Nova Venda'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF248f3d),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          minimumSize: const Size(double.infinity, 45),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => context.go('/products'),
                              icon: const Icon(Icons.inventory_2),
                              label: const Text('Produtos'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[100],
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => context.go('/customers'),
                              icon: const Icon(Icons.people),
                              label: const Text('Clientes'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[100],
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Estatísticas
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Estatísticas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Total de Vendas: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Text(state.totalSales.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Total de Clientes: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Text(state.totalCustomers.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Total de Produtos: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Text(state.totalProducts.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Vendas Pendentes: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Text(state.pendingSales.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
