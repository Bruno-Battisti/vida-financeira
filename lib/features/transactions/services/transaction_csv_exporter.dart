import 'package:csv/csv.dart';

import '../../../core/utils/formatters.dart';
import '../models/category.dart';
import '../models/transaction.dart';

class TransactionCsvExporter {
  TransactionCsvExporter._();

  static const _header = ['Data', 'Descrição', 'Categoria', 'Tipo', 'Valor', 'Observação'];

  static String build(List<Transaction> transactions, Map<int, Category> categoryMap) {
    final rows = <List<String>>[
      _header,
      for (final transaction in transactions)
        [
          formatDate(transaction.date),
          transaction.description,
          categoryMap[transaction.categoryId]?.name ?? '',
          transaction.type == TransactionType.income ? 'Receita' : 'Despesa',
          transaction.amount.toStringAsFixed(2),
          transaction.note ?? '',
        ],
    ];
    return Csv().encode(rows);
  }
}
