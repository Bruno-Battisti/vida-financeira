import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:vida_financeira/features/transactions/models/category.dart';
import 'package:vida_financeira/features/transactions/models/transaction.dart';
import 'package:vida_financeira/features/transactions/services/transaction_csv_importer.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  final categories = [
    const Category(id: 1, name: 'Alimentação', icon: Icons.restaurant, type: CategoryType.expense),
    const Category(id: 2, name: 'Salário', icon: Icons.payments, type: CategoryType.income),
    const Category(id: 3, name: 'Outros', icon: Icons.category, type: CategoryType.expense),
    const Category(id: 4, name: 'Outros', icon: Icons.category, type: CategoryType.income),
  ];

  test('parse() separa linhas válidas de inválidas', () {
    const csv = 'Data,Descrição,Categoria,Tipo,Valor,Observação\r\n'
        '07/09/2026,Supermercado,Alimentação,Despesa,150.50,compra do mês\r\n'
        '08/09/2026,Salário,Salário,Receita,3000.00,\r\n'
        '09/09/2026,Cinema,Alimentação,Despesa,45.00,\r\n'
        '10/09/2026,Item quebrado,Alimentação,Despesa,abc,valor inválido\r\n';

    final result = TransactionCsvImporter.parse(csv, categories);

    expect(result.valid, hasLength(3));
    expect(result.invalid, hasLength(1));
    expect(result.invalid.single.reason, contains('Valor'));

    final first = result.valid.first;
    expect(first.description, 'Supermercado');
    expect(first.amount, 150.5);
    expect(first.type, TransactionType.expense);
    expect(first.categoryId, 1);
    expect(first.note, 'compra do mês');
  });

  test('parse() usa a categoria "Outros" quando o nome não é encontrado', () {
    const csv = 'Data,Descrição,Categoria,Tipo,Valor,Observação\r\n'
        '07/09/2026,Compra,Categoria Inexistente,Despesa,10.00,\r\n';

    final result = TransactionCsvImporter.parse(csv, categories);

    expect(result.valid, hasLength(1));
    expect(result.valid.single.categoryId, 3);
  });
}
