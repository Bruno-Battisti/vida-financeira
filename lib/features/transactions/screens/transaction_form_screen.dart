import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/responsive_center.dart';
import '../../accounts/models/account.dart';
import '../../accounts/providers/accounts_provider.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../providers/categories_provider.dart';
import '../providers/transactions_provider.dart';

class TransactionFormScreen extends ConsumerStatefulWidget {
  const TransactionFormScreen({super.key, this.prefillCategory});

  /// Categoria pré-selecionada ao abrir pelo atalho de lançamento rápido.
  final Category? prefillCategory;

  @override
  ConsumerState<TransactionFormScreen> createState() =>
      _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _installmentsController = TextEditingController(text: '2');

  late TransactionType _type = widget.prefillCategory == null
      ? TransactionType.expense
      : widget.prefillCategory!.type == CategoryType.income
          ? TransactionType.income
          : TransactionType.expense;
  late Category? _category = widget.prefillCategory;
  DateTime _date = DateTime.now();
  bool _saving = false;
  bool _isPending = false;
  DateTime? _dueDate;
  bool _isInstallment = false;
  Account? _account;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _installmentsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_isPending && _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe a data de vencimento.')),
      );
      return;
    }

    setState(() => _saving = true);

    final amount =
        double.parse(_amountController.text.trim().replaceAll(',', '.'));
    final note = _noteController.text.trim();

    try {
      if (_isInstallment) {
        await ref.read(transactionsRepositoryProvider).addInstallments(
              description: _descriptionController.text.trim(),
              totalAmount: amount,
              type: _type,
              categoryId: _category!.id,
              firstDate: _date,
              installmentsCount: int.parse(_installmentsController.text.trim()),
              note: note.isEmpty ? null : note,
              accountId: _account?.id,
            );
      } else {
        await ref.read(transactionsRepositoryProvider).add(
              description: _descriptionController.text.trim(),
              amount: amount,
              type: _type,
              categoryId: _category!.id,
              date: _date,
              note: note.isEmpty ? null : note,
              isPaid: !_isPending,
              dueDate: _isPending ? _dueDate : null,
              accountId: _account?.id,
            );
      }
      if (mounted) {
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível salvar: $e')),
        );
      }
    }
  }

  String _accountLabel(Account account) {
    switch (account.type) {
      case AccountType.checking:
        return '${account.name} · Conta corrente';
      case AccountType.wallet:
        return '${account.name} · Carteira';
      case AccountType.creditCard:
        return '${account.name} · Cartão de crédito';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final accountsAsync = ref.watch(accountsProvider);
    final accounts = accountsAsync.value ?? const <Account>[];
    if (_account == null && accounts.isNotEmpty) {
      _account = accounts.firstWhere((a) => a.isDefault, orElse: () => accounts.first);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nova transação')),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            Center(child: Text('Erro ao carregar categorias: $error')),
        data: (allCategories) {
          final categoryType = _type == TransactionType.income
              ? CategoryType.income
              : CategoryType.expense;
          final categoriesForType =
              allCategories.where((c) => c.type == categoryType).toList();

          return ResponsiveCenter(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SegmentedButton<TransactionType>(
                    segments: const [
                      ButtonSegment(
                        value: TransactionType.expense,
                        label: Text('Despesa'),
                        icon: Icon(Icons.arrow_downward),
                      ),
                      ButtonSegment(
                        value: TransactionType.income,
                        label: Text('Receita'),
                        icon: Icon(Icons.arrow_upward),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (selection) {
                      setState(() {
                        _type = selection.first;
                        _category = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe uma descrição.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: _isInstallment ? 'Valor total da compra' : 'Valor',
                      prefixText: 'R\$ ',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o valor.';
                      }
                      final parsed =
                          double.tryParse(value.trim().replaceAll(',', '.'));
                      if (parsed == null) {
                        return 'Valor inválido.';
                      }
                      if (parsed <= 0) {
                        return 'O valor deve ser maior que zero.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Category>(
                    initialValue: _category,
                    decoration: const InputDecoration(labelText: 'Categoria'),
                    items: categoriesForType
                        .map((category) => DropdownMenuItem(
                            value: category, child: Text(category.name)))
                        .toList(),
                    onChanged: (value) => setState(() => _category = value),
                    validator: (value) =>
                        value == null ? 'Selecione uma categoria.' : null,
                  ),
                  if (accounts.length > 1) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Account>(
                      initialValue: _account,
                      decoration: const InputDecoration(labelText: 'Conta'),
                      items: accounts
                          .map((account) => DropdownMenuItem(
                              value: account, child: Text(_accountLabel(account))))
                          .toList(),
                      onChanged: (value) => setState(() => _account = value),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Data'),
                    subtitle: Text(formatDate(_date)),
                    trailing: const Icon(Icons.calendar_today_outlined),
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Parcelar compra'),
                    subtitle: const Text('Divide o valor em parcelas mensais'),
                    value: _isInstallment,
                    onChanged: (value) => setState(() {
                      _isInstallment = value;
                      if (value) {
                        _isPending = false;
                        _dueDate = null;
                      }
                    }),
                  ),
                  if (_isInstallment)
                    TextFormField(
                      controller: _installmentsController,
                      decoration: const InputDecoration(labelText: 'Número de parcelas'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final parsed = int.tryParse((value ?? '').trim());
                        if (parsed == null || parsed < 2) {
                          return 'Informe pelo menos 2 parcelas.';
                        }
                        return null;
                      },
                    )
                  else ...[
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Conta a pagar/receber'),
                      subtitle: const Text('Ainda não foi paga ou recebida'),
                      value: _isPending,
                      onChanged: (value) => setState(() {
                        _isPending = value;
                        if (!value) _dueDate = null;
                      }),
                    ),
                    if (_isPending)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Vencimento'),
                        subtitle: Text(_dueDate == null ? 'Selecione a data' : formatDate(_dueDate!)),
                        trailing: const Icon(Icons.event_outlined),
                        onTap: _pickDueDate,
                      ),
                  ],
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _noteController,
                    decoration: const InputDecoration(
                        labelText: 'Observação (opcional)'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _saving ? null : _submit,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: _saving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
