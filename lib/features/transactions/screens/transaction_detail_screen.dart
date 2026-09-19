import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_data.dart';
import '../../../core/utils/formatters.dart';
import '../models/transaction.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});

  final int transactionId;

  @override
  Widget build(BuildContext context) {
    final transaction = MockData.transactions.firstWhere((t) => t.id == transactionId);
    final category = MockData.categoryById(transaction.categoryId);
    final isIncome = transaction.type == TransactionType.income;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da transação'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'Marcar como revisada',
            onPressed: () => context.pop(true),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 32,
              child: Icon(category.icon, size: 32),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '${isIncome ? '+' : '-'} ${formatCurrency(transaction.amount)}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Descrição'),
                  subtitle: Text(transaction.description),
                ),
                ListTile(
                  leading: Icon(category.icon),
                  title: const Text('Categoria'),
                  subtitle: Text(category.name),
                ),
                ListTile(
                  leading: const Icon(Icons.event_outlined),
                  title: const Text('Data'),
                  subtitle: Text(formatDate(transaction.date)),
                ),
                if (transaction.note != null && transaction.note!.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.notes_outlined),
                    title: const Text('Observação'),
                    subtitle: Text(transaction.note!),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
