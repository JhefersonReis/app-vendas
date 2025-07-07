import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:organik_vendas/src/features/customers/controller/customers_controller.dart';
import 'package:organik_vendas/src/features/customers/domain/customer_model.dart';

class CustomersPage extends ConsumerWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clientes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF248f3d),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: customers.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Erro ao carregar: $err')),
          data: (customers) {
            return customers.isEmpty ? _buildEmptyState(context) : _buildClientesList(customers, ref);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/customers/form'),
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
              const Icon(Icons.people_outline, size: 50, color: Colors.grey),
              const SizedBox(height: 10),
              const Text('Nenhum cliente cadastrado', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text(
                'Cadastre seus clientes para agilizar as vendas',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => context.go('/customers/form'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF248f3d),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Adicionar Primeiro Cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClientesList(List<CustomerModel> customers, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return Dismissible(
          key: Key(customer.id.toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirmar exclusão'),
                content: const Text(
                  'Deseja realmente excluir este cliente? Todos os dados relacionados a ele serão perdidos.',
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Excluir'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) {
            ref.read(customersControllerProvider.notifier).deleteCustomer(customer.id);
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
                    children: [
                      Expanded(
                        child: Text(
                          customer.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.go('/customers/form?id=${customer.id}'),
                        icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 18, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(customer.phone),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Colors.grey),
                      const SizedBox(width: 5),
                      Expanded(child: Text(customer.address, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                  if (customer.observation != null && customer.observation!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Observação: ${customer.observation!}', style: const TextStyle(color: Colors.grey)),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
