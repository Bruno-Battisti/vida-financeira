import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/empty_state.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../providers/categories_provider.dart';
import '../providers/transactions_provider.dart';

enum _TransactionFilter { all, income, expense }

class _AdvancedFilters {
  const _AdvancedFilters({
    this.categoryIds = const {},
    this.dateRange,
    this.minAmount,
    this.maxAmount,
  });

  final Set<int> categoryIds;
  final DateTimeRange? dateRange;
  final double? minAmount;
  final double? maxAmount;

  bool get isActive =>
      categoryIds.isNotEmpty || dateRange != null || minAmount != null || maxAmount != null;

  int get activeCount =>
      (categoryIds.isNotEmpty ? 1 : 0) +
      (dateRange != null ? 1 : 0) +
      (minAmount != null || maxAmount != null ? 1 : 0);

  _AdvancedFilters copyWith({
    Set<int>? categoryIds,
    DateTimeRange? dateRange,
    bool clearDateRange = false,
    double? minAmount,
    double? maxAmount,
    bool clearAmountRange = false,
  }) {
    return _AdvancedFilters(
      categoryIds: categoryIds ?? this.categoryIds,
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
      minAmount: clearAmountRange ? null : (minAmount ?? this.minAmount),
      maxAmount: clearAmountRange ? null : (maxAmount ?? this.maxAmount),
    );
  }
}

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  _TransactionFilter _filter = _TransactionFilter.all;
  _AdvancedFilters _advanced = const _AdvancedFilters();
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Transaction> _applyFilters(List<Transaction> transactions) {
    return transactions.where((t) {
      switch (_filter) {
        case _TransactionFilter.all:
          break;
        case _TransactionFilter.income:
          if (t.type != TransactionType.income) return false;
        case _TransactionFilter.expense:
          if (t.type != TransactionType.expense) return false;
      }

      if (_query.isNotEmpty &&
          !t.description.toLowerCase().contains(_query.toLowerCase())) {
        return false;
      }

      if (_advanced.categoryIds.isNotEmpty &&
          !_advanced.categoryIds.contains(t.categoryId)) {
        return false;
      }

      if (_advanced.dateRange != null) {
        final start = _advanced.dateRange!.start;
        final end = _advanced.dateRange!.end;
        final day = DateTime(t.date.year, t.date.month, t.date.day);
        if (day.isBefore(start) || day.isAfter(end)) return false;
      }

      if (_advanced.minAmount != null && t.amount < _advanced.minAmount!) {
        return false;
      }
      if (_advanced.maxAmount != null && t.amount > _advanced.maxAmount!) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    Widget body;
    var categories = const <Category>[];
    if (transactionsAsync.isLoading || categoriesAsync.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (transactionsAsync.hasError) {
      body = Center(child: Text('Erro: ${transactionsAsync.error}'));
    } else if (categoriesAsync.hasError) {
      body = Center(child: Text('Erro: ${categoriesAsync.error}'));
    } else {
      categories = categoriesAsync.requireValue;
      final categoryMap = {for (final c in categories) c.id: c};
      body = _buildList(context, _applyFilters(transactionsAsync.requireValue), categoryMap);
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar por descrição',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                            ),
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ),
                const SizedBox(width: 8),
                Badge(
                  label: Text('${_advanced.activeCount}'),
                  isLabelVisible: _advanced.isActive,
                  child: IconButton.filledTonal(
                    icon: const Icon(Icons.tune),
                    tooltip: 'Filtros',
                    onPressed: () => _openFilterSheet(context, categories),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
          const SizedBox(height: 8),
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

  Future<void> _openFilterSheet(BuildContext context, List<Category> categories) async {
    final result = await showModalBottomSheet<_AdvancedFilters>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _FilterSheet(initial: _advanced, categories: categories),
    );
    if (result != null) {
      setState(() => _advanced = result);
    }
  }

  Widget _buildList(
    BuildContext context,
    List<Transaction> transactions,
    Map<int, Category> categoryMap,
  ) {
    if (transactions.isEmpty) {
      return const EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'Nenhuma transação encontrada',
        subtitle: 'Ajuste os filtros ou toque no botão + para cadastrar uma nova.',
      );
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
            leading: Hero(
              tag: 'transaction-avatar-${transaction.id}',
              child: CircleAvatar(child: Icon(category?.icon ?? Icons.category)),
            ),
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

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.initial, required this.categories});

  final _AdvancedFilters initial;
  final List<Category> categories;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late Set<int> _categoryIds = {...widget.initial.categoryIds};
  late DateTimeRange? _dateRange = widget.initial.dateRange;
  late final _minController =
      TextEditingController(text: widget.initial.minAmount?.toStringAsFixed(2) ?? '');
  late final _maxController =
      TextEditingController(text: widget.initial.maxAmount?.toStringAsFixed(2) ?? '');

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filtros', style: Theme.of(context).textTheme.titleLarge),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _categoryIds = {};
                      _dateRange = null;
                      _minController.clear();
                      _maxController.clear();
                    });
                  },
                  child: const Text('Limpar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Categorias', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.categories.map((category) {
                final selected = _categoryIds.contains(category.id);
                return FilterChip(
                  avatar: Icon(category.icon, size: 18),
                  label: Text(category.name),
                  selected: selected,
                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        _categoryIds.add(category.id);
                      } else {
                        _categoryIds.remove(category.id);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Período', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.date_range),
              label: Text(
                _dateRange == null
                    ? 'Selecionar período'
                    : '${formatDate(_dateRange!.start)} - ${formatDate(_dateRange!.end)}',
              ),
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialDateRange: _dateRange,
                );
                if (range != null) {
                  setState(() => _dateRange = range);
                }
              },
            ),
            const SizedBox(height: 16),
            Text('Valor', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Mínimo', prefixText: 'R\$ '),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(labelText: 'Máximo', prefixText: 'R\$ '),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    _AdvancedFilters(
                      categoryIds: _categoryIds,
                      dateRange: _dateRange,
                      minAmount: double.tryParse(_minController.text.replaceAll(',', '.')),
                      maxAmount: double.tryParse(_maxController.text.replaceAll(',', '.')),
                    ),
                  );
                },
                child: const Text('Aplicar filtros'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
