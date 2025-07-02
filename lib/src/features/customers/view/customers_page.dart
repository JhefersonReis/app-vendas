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
        actions: [
          IconButton(
            onPressed: () => context.go('/customers/form'),
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: customers.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Erro ao carregar: $err')),
          data: (customers) {
            return customers.isEmpty
                ? _buildEmptyState(context)
                : _buildClientesList(customers, ref);
          },
        ),
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
              const Text(
                'Nenhum cliente cadastrado',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
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
          onDismissed: (_) {
            ref
                .read(customersControllerProvider.notifier)
                .deleteCustomer(customer.id);
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        customer.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          context.go('/customers/form?id=${customer.id}');
                          // final nameController = TextEditingController(
                          //   text: customer.name,
                          // );
                          // final addressController = TextEditingController(
                          //   text: customer.address,
                          // );
                          // final phoneController = TextEditingController(
                          //   text: customer.phone,
                          // );

                          // showDialog(
                          //   context: context,
                          //   builder: (context) => AlertDialog(
                          //     title: const Text('Editar Cliente'),
                          //     content: Column(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         TextField(
                          //           controller: nameController,
                          //           decoration: const InputDecoration(
                          //             labelText: 'Nome',
                          //           ),
                          //         ),
                          //         TextField(
                          //           controller: addressController,
                          //           decoration: const InputDecoration(
                          //             labelText: 'Endereço',
                          //           ),
                          //         ),
                          //         TextField(
                          //           controller: phoneController,
                          //           decoration: const InputDecoration(
                          //             labelText: 'Telefone',
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     actions: [
                          //       TextButton(
                          //         onPressed: () => Navigator.pop(context),
                          //         child: const Text('Cancelar'),
                          //       ),
                          //       ElevatedButton(
                          //         onPressed: () {
                          //           ref
                          //               .read(
                          //                 customersControllerProvider.notifier,
                          //               )
                          //               .updateCustomer(
                          //                 id: customer.id,
                          //                 name: nameController.text,
                          //                 address: addressController.text,
                          //                 phone: phoneController.text,
                          //               );
                          //           Navigator.pop(context);
                          //         },
                          //         child: const Text('Salvar'),
                          //       ),
                          //     ],
                          //   ),
                          // );
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.grey,
                        ),
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
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Expanded(child: Text(customer.address)),
                    ],
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
