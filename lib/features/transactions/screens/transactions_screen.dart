import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../providers/categories_provider.dart';
import '../providers/transactions_provider.dart';

enum _TransactionFilter { all, income, expense }

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  _TransactionFilter _filter = _TransactionFilter.all;

  List<Transaction> _applyFilter(List<Transaction> transactions) {
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
    final transactionsAsync = ref.watch(transactionsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    Widget body;
    if (transactionsAsync.isLoading || categoriesAsync.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (transactionsAsync.hasError) {
      body = Center(child: Text('Erro: ${transactionsAsync.error}'));
    } else if (categoriesAsync.hasError) {
      body = Center(child: Text('Erro: ${categoriesAsync.error}'));
    } else {
      final categoryMap = {for (final c in categoriesAsync.requireValue) c.id: c};
      body = _buildList(context, _applyFilter(transactionsAsync.requireValue), categoryMap);
    }

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
          Expanded(child: body),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await context.push<bool>('/transactions/new');
          if (created == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Transação criada com sucesso!')),
            );
          }
        },
        tooltip: 'Nova transação',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<Transaction> transactions,
    Map<int, Category> categoryMap,
  ) {
    if (transactions.isEmpty) {
      return const Center(child: Text('Nenhuma transação encontrada.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final category = categoryMap[transaction.categoryId];
        final isIncome = transaction.type == TransactionType.income;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(child: Icon(category?.icon ?? Icons.category)),
            title: Text(transaction.description),
            subtitle: Text('${category?.name ?? 'Categoria'} · ${formatDate(transaction.date)}'),
            trailing: Text(
              '${isIncome ? '+' : '-'} ${formatCurrency(transaction.amount)}',
              style: TextStyle(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              final revisada = await context.push<bool>('/transactions/${transaction.id}');
              if (revisada == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transação marcada como revisada.')),
                );
              }
            },
          ),
        );
      },
    );
  }
}
