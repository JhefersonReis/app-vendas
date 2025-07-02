import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  DateTime dataInicial = DateTime.now();
  DateTime dataFinal = DateTime.now();

  Future<void> selecionarDataInicial() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: dataInicial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (dataSelecionada != null) {
      setState(() => dataInicial = dataSelecionada);
    }
  }

  Future<void> selecionarDataFinal() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: dataFinal,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (dataSelecionada != null) {
      setState(() => dataFinal = dataSelecionada);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatoData = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Relatórios',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF248f3d),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.bar_chart, color: Color(0xFF248f3d)),
                SizedBox(width: 8),
                Text(
                  'Relatórios',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Período
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Período',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDataInput(
                          label: 'Data Inicial',
                          data: formatoData.format(dataInicial),
                          onTap: selecionarDataInicial,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDataInput(
                          label: 'Data Final',
                          data: formatoData.format(dataFinal),
                          onTap: selecionarDataFinal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Receita Total e Total de Vendas
            _buildCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildResumoValor(
                    icon: Icons.attach_money,
                    label: 'Receita Total',
                    valor: 'R\$ 0.00',
                  ),
                  _buildResumoValor(
                    icon: Icons.inventory_2,
                    label: 'Total de Vendas',
                    valor: '0',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Status dos Pagamentos
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Status dos Pagamentos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildStatusLinha(
                    Icons.circle,
                    'Vendas Pagas',
                    Colors.green,
                    '0',
                    'R\$ 0.00',
                  ),
                  const SizedBox(height: 5),
                  _buildStatusLinha(
                    Icons.circle,
                    'Vendas Pendentes',
                    Colors.orange,
                    '0',
                    'R\$ 0.00',
                  ),
                  const Divider(height: 20),
                  const Text(
                    'Ticket Médio',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text('R\$ 0.00'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Produtos Mais Vendidos
            _buildCard(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Produtos Mais Vendidos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nenhum produto registrado.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }

  Widget _buildDataInput({
    required String label,
    required String data,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade100,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data),
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResumoValor({
    required IconData icon,
    required String label,
    required String valor,
  }) {
    return Column(
      children: [
        Icon(icon, size: 30, color: const Color(0xFF248f3d)),
        const SizedBox(height: 5),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF248f3d),
          ),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildStatusLinha(
    IconData icon,
    String label,
    Color color,
    String quantidade,
    String valor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 6),
        Expanded(child: Text(label)),
        Text(quantidade),
        const SizedBox(width: 10),
        Text(valor, style: TextStyle(color: color)),
      ],
    );
  }
}
