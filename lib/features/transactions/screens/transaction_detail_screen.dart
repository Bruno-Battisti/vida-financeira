import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../models/transaction.dart';
import '../providers/categories_provider.dart';
import '../providers/transactions_provider.dart';

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});

  final String transactionId;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir transação'),
        content: const Text('Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(transactionsRepositoryProvider).remove(transactionId);
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível excluir: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionByIdProvider(transactionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da transação'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'Marcar como revisada',
            onPressed: () => context.pop(true),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Excluir',
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: transactionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro: $error')),
        data: (transaction) {
          final categoryAsync = ref.watch(categoryByIdProvider(transaction.categoryId));
          final isIncome = transaction.type == TransactionType.income;

          return categoryAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Erro: $error')),
            data: (category) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Center(
                    child: Hero(
                      tag: 'transaction-avatar-${transaction.id}',
                      child: CircleAvatar(
                        radius: 32,
                        child: Icon(category.icon, size: 32),
                      ),
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
              );
            },
          );
        },
      ),
    );
  }
}
