import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatters.dart';
import '../models/account.dart';
import '../models/transfer.dart';
import '../providers/accounts_provider.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  IconData _iconFor(AccountType type) {
    switch (type) {
      case AccountType.checking:
        return Icons.account_balance_outlined;
      case AccountType.wallet:
        return Icons.account_balance_wallet_outlined;
      case AccountType.creditCard:
        return Icons.credit_card_outlined;
    }
  }

  String _typeLabel(AccountType type) {
    switch (type) {
      case AccountType.checking:
        return 'Conta corrente';
      case AccountType.wallet:
        return 'Carteira';
      case AccountType.creditCard:
        return 'Cartão de crédito';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balancesAsync = ref.watch(accountBalancesProvider);
    final transfersAsync = ref.watch(transfersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas e carteiras'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Nova transferência',
            onPressed: () => _transfer(context, ref, balancesAsync.value ?? const []),
          ),
        ],
      ),
      body: balancesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro: $error')),
        data: (balances) {
          final accountMap = {for (final b in balances) b.account.id: b.account};
          final transfers = switch (transfersAsync) {
            AsyncData(:final value) => value,
            _ => const <Transfer>[],
          };

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final item in balances) ...[
                Card(
                  child: ListTile(
                    leading: Icon(_iconFor(item.account.type)),
                    title: Text(item.account.name),
                    subtitle: Text(_typeLabel(item.account.type)),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          formatCurrency(item.balance),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: item.balance < 0 ? Colors.red : null,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              onPressed: () => _editAccount(context, ref, item.account),
                            ),
                            if (!item.account.isDefault)
                              IconButton(
                                icon: const Icon(Icons.delete_outline, size: 20),
                                onPressed: () => ref.read(accountsRepositoryProvider).remove(item.account.id),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (transfers.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Transferências recentes', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                for (final transfer in transfers)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.swap_horiz),
                      title: Text(
                        '${accountMap[transfer.fromAccountId]?.name ?? '?'} → '
                        '${accountMap[transfer.toAccountId]?.name ?? '?'}',
                      ),
                      subtitle: Text(formatDate(transfer.date)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(formatCurrency(transfer.amount)),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () => ref.read(transfersRepositoryProvider).remove(transfer.id),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editAccount(context, ref, null),
        tooltip: 'Nova conta',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _transfer(BuildContext context, WidgetRef ref, List<AccountBalance> balances) async {
    if (balances.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crie pelo menos duas contas para transferir entre elas.')),
      );
      return;
    }

    final accounts = balances.map((b) => b.account).toList();
    var from = accounts[0];
    var to = accounts[1];
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nova transferência'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Account>(
                  initialValue: from,
                  decoration: const InputDecoration(labelText: 'De'),
                  items: accounts.map((a) => DropdownMenuItem(value: a, child: Text(a.name))).toList(),
                  onChanged: (value) => setDialogState(() => from = value!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Account>(
                  initialValue: to,
                  decoration: const InputDecoration(labelText: 'Para'),
                  items: accounts.map((a) => DropdownMenuItem(value: a, child: Text(a.name))).toList(),
                  onChanged: (value) => setDialogState(() => to = value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Valor', prefixText: 'R\$ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    final parsed = double.tryParse((value ?? '').trim().replaceAll(',', '.'));
                    if (parsed == null || parsed <= 0) return 'Informe um valor maior que zero.';
                    return null;
                  },
                ),
                if (from.id == to.id)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('As contas de origem e destino devem ser diferentes.',
                        style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () {
                if (from.id == to.id) return;
                if (formKey.currentState!.validate()) Navigator.of(context).pop(true);
              },
              child: const Text('Transferir'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      await ref.read(transfersRepositoryProvider).add(
            fromAccountId: from.id,
            toAccountId: to.id,
            amount: double.parse(amountController.text.trim().replaceAll(',', '.')),
            date: DateTime.now(),
          );
    }
    amountController.dispose();
  }

  Future<void> _editAccount(BuildContext context, WidgetRef ref, Account? current) async {
    final nameController = TextEditingController(text: current?.name ?? '');
    final balanceController =
        TextEditingController(text: current == null ? '0' : current.initialBalance.toStringAsFixed(2));
    var type = current?.type ?? AccountType.checking;
    final formKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(current == null ? 'Nova conta' : 'Editar conta'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? 'Informe um nome.' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<AccountType>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: AccountType.values
                      .map((t) => DropdownMenuItem(value: t, child: Text(_typeLabel(t))))
                      .toList(),
                  onChanged: (value) => setDialogState(() => type = value!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: balanceController,
                  decoration: const InputDecoration(labelText: 'Saldo inicial', prefixText: 'R\$ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  validator: (value) {
                    final parsed = double.tryParse((value ?? '').trim().replaceAll(',', '.'));
                    return parsed == null ? 'Valor inválido.' : null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () {
                if (formKey.currentState!.validate()) Navigator.of(context).pop(true);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      final initialBalance = double.parse(balanceController.text.trim().replaceAll(',', '.'));
      final repository = ref.read(accountsRepositoryProvider);
      if (current == null) {
        await repository.add(name: nameController.text.trim(), type: type, initialBalance: initialBalance);
      } else {
        await repository.update(
          current.copyWith(name: nameController.text.trim(), type: type, initialBalance: initialBalance),
        );
      }
    }
    nameController.dispose();
    balanceController.dispose();
  }
}
