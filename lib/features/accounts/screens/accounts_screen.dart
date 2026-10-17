import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/formatters.dart';
import '../models/account.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Contas e carteiras')),
      body: balancesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro: $error')),
        data: (balances) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: balances.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = balances[index];
              return Card(
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
              );
            },
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
