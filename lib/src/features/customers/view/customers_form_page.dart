import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:organik_vendas/src/features/customers/controller/customers_controller.dart';

class CustomersFormPage extends ConsumerStatefulWidget {
  final String? id;

  const CustomersFormPage({super.key, this.id});

  @override
  ConsumerState<CustomersFormPage> createState() => _CustomersFormPageState();
}

class _CustomersFormPageState extends ConsumerState<CustomersFormPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _observationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadCustomer(int.parse(widget.id!));
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _observationController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomer(int id) async {
    final customer = await ref.read(customerByIdProvider(id).future);
    _nameController.text = customer.name;
    _phoneController.text = customer.phone;
    _addressController.text = customer.address;
    _observationController.text = customer.observation ?? '';
  }

  Future<void> _saveCustomer() async {
    if (widget.id != null) {
      final customer = await ref.read(
        customerByIdProvider(int.parse(widget.id!)).future,
      );

      await ref
          .read(customersControllerProvider.notifier)
          .updateCustomer(
            id: int.parse(widget.id!),
            name: _nameController.text,
            address: _addressController.text,
            phone: _phoneController.text,
            observation: _observationController.text,
            createdAt: customer.createdAt,
          );
    } else {
      await ref
          .read(customersControllerProvider.notifier)
          .addCustomer(
            name: _nameController.text,
            address: _addressController.text,
            phone: _phoneController.text,
            observation: _observationController.text,
          );
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.id != null ? "Editar Cliente" : "Novo Cliente",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF248f3d),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text.rich(
              TextSpan(
                text: "Nome do Cliente ",
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
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Nome completo",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: 16),
            const Text.rich(
              TextSpan(
                text: "Telefone ",
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
              controller: _phoneController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "(xx) xxxxx-xxxx",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: 16),
            const Text.rich(
              TextSpan(
                text: "Endereço Completo ",
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
              controller: _addressController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Rua, Bairro, Cidade, Estado, CEP",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: 16),
            const Text.rich(
              TextSpan(
                text: "Observação ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            TextField(
              controller: _observationController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Ex: Cliente que sempre compra na terça-feira",
                hintStyle: TextStyle(color: Colors.grey),
              ),
              maxLines: 3,
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF248f3d),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _saveCustomer,
              child: Text(
                widget.id != null ? 'Salvar Alterações' : 'Cadastrar Cliente',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
