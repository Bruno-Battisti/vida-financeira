import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatters.dart';
import '../../transactions/models/transaction.dart';
import '../models/account.dart';
import '../providers/accounts_provider.dart';

class CreditCardInvoiceScreen extends ConsumerWidget {
  const CreditCardInvoiceScreen({super.key, required this.accountId});

  final String accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceAsync = ref.watch(creditCardInvoiceProvider(accountId));
    final balancesAsync = ref.watch(accountBalancesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fatura do cartão')),
      body: invoiceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro: $error')),
        data: (invoice) {
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${formatDate(invoice.periodStart)} a ${formatDate(invoice.periodEnd)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatCurrency(invoice.total),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        icon: const Icon(Icons.payment),
                        label: const Text('Pagar fatura'),
                        onPressed: invoice.total <= 0
                            ? null
                            : () => _payInvoice(context, ref, balancesAsync.value ?? const [], invoice.total),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: invoice.transactions.isEmpty
                    ? const Center(child: Text('Nenhuma compra neste ciclo.'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: invoice.transactions.length,
                        itemBuilder: (context, index) {
                          final t = invoice.transactions[index];
                          final isIncome = t.type == TransactionType.income;
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(t.description),
                              subtitle: Text(
                                t.installmentTotal != null
                                    ? '${formatDate(t.date)} · parcela ${t.installmentIndex}/${t.installmentTotal}'
                                    : formatDate(t.date),
                              ),
                              trailing: Text(
                                '${isIncome ? '-' : ''} ${formatCurrency(t.amount)}',
                                style: TextStyle(
                                  color: isIncome ? Colors.green : null,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _payInvoice(
    BuildContext context,
    WidgetRef ref,
    List<AccountBalance> balances,
    double total,
  ) async {
    final otherAccounts = balances.map((b) => b.account).where((a) => a.id != accountId).toList();
    if (otherAccounts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crie outra conta para pagar a fatura a partir dela.')),
      );
      return;
    }

    var from = otherAccounts.first;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Pagar fatura'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Valor: ${formatCurrency(total)}'),
              const SizedBox(height: 16),
              DropdownButtonFormField<Account>(
                initialValue: from,
                decoration: const InputDecoration(labelText: 'Pagar com'),
                items: otherAccounts.map((a) => DropdownMenuItem(value: a, child: Text(a.name))).toList(),
                onChanged: (value) => setDialogState(() => from = value!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Confirmar')),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      await ref.read(transfersRepositoryProvider).add(
            fromAccountId: from.id,
            toAccountId: accountId,
            amount: total,
            date: DateTime.now(),
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fatura paga com sucesso!')),
        );
      }
    }
  }
}
