import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/mock/mock_data.dart';
import '../../../core/utils/formatters.dart';
import '../models/transaction.dart';

enum _TransactionFilter { all, income, expense }

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  _TransactionFilter _filter = _TransactionFilter.all;

  List<Transaction> get _filteredTransactions {
    final transactions = MockData.transactions;
    switch (_filter) {
      case _TransactionFilter.all:
        return transactions;
      case _TransactionFilter.income:
        return transactions.where((t) => t.type == TransactionType.income).toList();
      case _TransactionFilter.expense:
        return transactions.where((t) => t.type == TransactionType.expense).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _filteredTransactions;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<_TransactionFilter>(
              segments: const [
                ButtonSegment(value: _TransactionFilter.all, label: Text('Todas')),
                ButtonSegment(value: _TransactionFilter.income, label: Text('Receitas')),
                ButtonSegment(value: _TransactionFilter.expense, label: Text('Despesas')),
              ],
              selected: {_filter},
              onSelectionChanged: (selection) {
                setState(() => _filter = selection.first);
              },
            ),
          ),
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text('Nenhuma transação encontrada.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final category = MockData.categoryById(transaction.categoryId);
                      final isIncome = transaction.type == TransactionType.income;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(child: Icon(category.icon)),
                          title: Text(transaction.description),
                          subtitle: Text('${category.name} · ${formatDate(transaction.date)}'),
                          trailing: Text(
                            '${isIncome ? '+' : '-'} ${formatCurrency(transaction.amount)}',
                            style: TextStyle(
                              color: isIncome ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () async {
                            final revisada = await context.push<bool>(
                              '/transactions/${transaction.id}',
                            );
                            if (revisada == true && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Transação marcada como revisada.')),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Formulário de cadastro chega na Fase 3.')),
          );
        },
        tooltip: 'Nova transação',
        child: const Icon(Icons.add),
      ),
    );
  }
}
