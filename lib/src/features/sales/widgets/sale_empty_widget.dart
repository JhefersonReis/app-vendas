import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SaleEmptyWidget extends StatelessWidget {
  const SaleEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
}
