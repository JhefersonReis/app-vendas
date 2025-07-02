import 'package:flutter/material.dart';

class Venda {
  final String cliente;
  final DateTime data;
  final double valor;
  final String status;
  final int quantidadeItens;
  final int quantidadeProdutos;

  Venda({
    required this.cliente,
    required this.data,
    required this.valor,
    required this.status,
    required this.quantidadeItens,
    required this.quantidadeProdutos,
  });
}

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final List<Venda> vendas =
      []; // Inicialmente vazio, depois você pode testar adicionando uma venda aqui.

  void adicionarVendaFake() {
    setState(() {
      vendas.add(
        Venda(
          cliente: 'dfgd',
          data: DateTime.now(),
          valor: 2.00,
          status: 'Pendente',
          quantidadeItens: 1,
          quantidadeProdutos: 1,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vendas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF248f3d),
        actions: [
          IconButton(
            onPressed:
                adicionarVendaFake, // Só para simular o cadastro de uma venda
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: vendas.isEmpty ? _buildEmptyState() : _buildVendasList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.shopping_bag_outlined,
                size: 50,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              const Text(
                'Nenhuma venda registrada',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('Comece registrando sua primeira venda'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: adicionarVendaFake,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF248f3d),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Registrar Primeira Venda'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVendasList() {
    return ListView.builder(
      itemCount: vendas.length,
      itemBuilder: (context, index) {
        final venda = vendas[index];
        return Card(
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
                    Row(
                      children: const [
                        Icon(Icons.person, size: 18, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(
                          'dfgd',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Ver Detalhes',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${venda.data.day}/${venda.data.month}/${venda.data.year}',
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 18,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'R\$ ${venda.valor.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: const [
                    Icon(Icons.warning, size: 18, color: Colors.orange),
                    SizedBox(width: 5),
                    Text('Pendente', style: TextStyle(color: Colors.orange)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${venda.quantidadeItens} item(s) • ${venda.quantidadeProdutos} produtos',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
