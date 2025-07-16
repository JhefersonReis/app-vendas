import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zello/l10n/app_localizations.dart';
import 'package:zello/src/features/customers/controller/customers_controller.dart';
import 'package:zello/src/features/customers/widgets/customer_empty_widget.dart';
import 'package:zello/src/features/customers/widgets/customer_list_widget.dart';

class CustomersPage extends ConsumerWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersControllerProvider);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.customersTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF248f3d),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: customers.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Erro ao carregar: $error')),
          data: (data) => data.isEmpty ? CustomerEmptyWidget() : CustomerListWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/customers/form'),
        backgroundColor: const Color(0xFF248f3d),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
