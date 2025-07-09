import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductEmptyWidget extends StatelessWidget {
  const ProductEmptyWidget({super.key});

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
              const Icon(Icons.inventory_2, size: 50, color: Colors.grey),
              const SizedBox(height: 10),
              const Text('Nenhum produto cadastrado', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text(
                'Comece adicionando seus produtos\npara facilitar as vendas',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => context.go('/products/form'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF248f3d),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Adicionar Primeiro Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
