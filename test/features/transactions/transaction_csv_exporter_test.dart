import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:vida_financeira/features/transactions/models/category.dart';
import 'package:vida_financeira/features/transactions/models/transaction.dart';
import 'package:vida_financeira/features/transactions/services/transaction_csv_exporter.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  test('build() gera cabeçalho e uma linha por transação', () {
    final categoryMap = {
      1: const Category(id: 1, name: 'Alimentação', icon: Icons.restaurant, type: CategoryType.expense),
    };
    final transactions = [
      Transaction(
        id: 't1',
        description: 'Supermercado',
        amount: 150.5,
        type: TransactionType.expense,
        categoryId: 1,
        date: DateTime(2026, 9, 7),
        note: 'compra do mês',
      ),
    ];

    final csv = TransactionCsvExporter.build(transactions, categoryMap);
    final lines = csv.trim().split('\r\n');

    expect(lines, hasLength(2));
    expect(lines.first, 'Data,Descrição,Categoria,Tipo,Valor,Observação');
    expect(lines.last, '07/09/2026,Supermercado,Alimentação,Despesa,150.50,compra do mês');
  });

  test('build() gera só o cabeçalho quando não há transações', () {
    final csv = TransactionCsvExporter.build([], {});
    expect(csv.trim().split('\r\n'), hasLength(1));
  });
}
