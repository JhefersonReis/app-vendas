import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerEmptyWidget extends StatelessWidget {
  const CustomerEmptyWidget({super.key});

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
}