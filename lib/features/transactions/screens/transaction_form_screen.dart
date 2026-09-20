import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../providers/categories_provider.dart';
import '../providers/transactions_provider.dart';

class TransactionFormScreen extends ConsumerStatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  ConsumerState<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  Category? _category;
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _noteController.dispose();
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _saving = true);

    final amount = double.parse(_amountController.text.trim().replaceAll(',', '.'));
    final note = _noteController.text.trim();

    try {
      await ref.read(transactionsRepositoryProvider).add(
            description: _descriptionController.text.trim(),
            amount: amount,
            type: _type,
            categoryId: _category!.id,
            date: _date,
            note: note.isEmpty ? null : note,
          );
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

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nova transação')),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro ao carregar categorias: $error')),
        data: (allCategories) {
          final categoryType = _type == TransactionType.income ? CategoryType.income : CategoryType.expense;
          final categoriesForType = allCategories.where((c) => c.type == categoryType).toList();

          return Form(
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
                  decoration: const InputDecoration(labelText: 'Valor', prefixText: 'R\$ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o valor.';
                    }
                    final parsed = double.tryParse(value.trim().replaceAll(',', '.'));
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
                      .map((category) => DropdownMenuItem(value: category, child: Text(category.name)))
                      .toList(),
                  onChanged: (value) => setState(() => _category = value),
                  validator: (value) => value == null ? 'Selecione uma categoria.' : null,
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Data'),
                  subtitle: Text(formatDate(_date)),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(labelText: 'Observação (opcional)'),
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
          );
        },
      ),
    );
  }
}
