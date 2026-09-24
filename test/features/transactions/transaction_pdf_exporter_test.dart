import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:vida_financeira/features/transactions/models/category.dart';
import 'package:vida_financeira/features/transactions/models/transaction.dart';
import 'package:vida_financeira/features/transactions/services/transaction_pdf_exporter.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  test('build() gera um PDF válido com transações', () async {
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

    final bytes = await TransactionPdfExporter.build(transactions, categoryMap);

    expect(bytes, isNotEmpty);
    expect(utf8.decode(bytes.sublist(0, 4)), '%PDF');
  });

  test('build() gera um PDF válido quando não há transações', () async {
    final bytes = await TransactionPdfExporter.build([], {});

    expect(bytes, isNotEmpty);
    expect(utf8.decode(bytes.sublist(0, 4)), '%PDF');
  });
}
