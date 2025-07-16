import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zello/l10n/app_localizations.dart';
import 'package:zello/src/features/sales/controller/sales_controller.dart';
import 'package:zello/src/features/sales/widgets/sale_empty_widget.dart';
import 'package:zello/src/features/sales/widgets/sale_list_widget.dart';

class SalesPage extends ConsumerWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesState = ref.watch(salesControllerProvider);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.salesTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF248f3d),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: salesState.when(
          data: (data) => data.isEmpty ? SaleEmptyWidget() : SaleListWidget(),
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
}
