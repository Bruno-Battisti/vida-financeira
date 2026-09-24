import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/amount_parser.dart';
import '../models/category.dart';
import '../models/transaction.dart';

class ParsedTransactionRow {
  const ParsedTransactionRow({
    required this.lineNumber,
    required this.description,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.date,
    this.note,
  });

  final int lineNumber;
  final String description;
  final double amount;
  final TransactionType type;
  final int categoryId;
  final DateTime date;
  final String? note;
}

class RejectedTransactionRow {
  const RejectedTransactionRow({
    required this.lineNumber,
    required this.rawLine,
    required this.reason,
  });

  final int lineNumber;
  final String rawLine;
  final String reason;
}

class TransactionImportResult {
  const TransactionImportResult({required this.valid, required this.invalid});

  final List<ParsedTransactionRow> valid;
  final List<RejectedTransactionRow> invalid;
}

class TransactionCsvImporter {
  TransactionCsvImporter._();

  static final _dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');
  static const _minDate = 2020;
  static const _maxDate = 2100;

  static TransactionImportResult parse(String csvContent, List<Category> categories) {
    final rows = Csv().decode(csvContent);
    final valid = <ParsedTransactionRow>[];
    final invalid = <RejectedTransactionRow>[];

    for (var i = 1; i < rows.length; i++) {
      final lineNumber = i + 1;
      final row = rows[i].map((cell) => cell.toString()).toList();
      if (row.length < 6) {
        invalid.add(RejectedTransactionRow(
          lineNumber: lineNumber,
          rawLine: row.join(','),
          reason: 'Linha incompleta',
        ));
        continue;
      }

      final description = row[1].trim();
      final categoryName = row[2].trim();
      final typeText = row[3].trim().toLowerCase();
      final amountText = row[4].trim();
      final dateText = row[0].trim();
      final note = row[5].trim();

      if (description.isEmpty) {
        invalid.add(RejectedTransactionRow(
          lineNumber: lineNumber,
          rawLine: row.join(','),
          reason: 'Descrição vazia',
        ));
        continue;
      }

      final amount = parseAmountInput(amountText);
      if (amount == null || amount <= 0) {
        invalid.add(RejectedTransactionRow(
          lineNumber: lineNumber,
          rawLine: row.join(','),
          reason: 'Valor inválido',
        ));
        continue;
      }

      TransactionType? type;
      if (typeText == 'receita') {
        type = TransactionType.income;
      } else if (typeText == 'despesa') {
        type = TransactionType.expense;
      }
      if (type == null) {
        invalid.add(RejectedTransactionRow(
          lineNumber: lineNumber,
          rawLine: row.join(','),
          reason: 'Tipo inválido',
        ));
        continue;
      }

      DateTime? date;
      try {
        date = _dateFormat.parseStrict(dateText);
      } catch (_) {
        date = null;
      }
      if (date == null || date.year < _minDate || date.year > _maxDate) {
        invalid.add(RejectedTransactionRow(
          lineNumber: lineNumber,
          rawLine: row.join(','),
          reason: 'Data inválida',
        ));
        continue;
      }

      final categoryType = type == TransactionType.income ? CategoryType.income : CategoryType.expense;
      final matchingCategories = categories.where((c) => c.type == categoryType).toList();
      Category? category;
      for (final c in matchingCategories) {
        if (c.name.toLowerCase() == categoryName.toLowerCase()) {
          category = c;
          break;
        }
      }
      if (category == null) {
        for (final c in matchingCategories) {
          if (c.name.toLowerCase() == 'outros') {
            category = c;
            break;
          }
        }
      }
      if (category == null) {
        invalid.add(RejectedTransactionRow(
          lineNumber: lineNumber,
          rawLine: row.join(','),
          reason: 'Categoria não encontrada',
        ));
        continue;
      }

      valid.add(ParsedTransactionRow(
        lineNumber: lineNumber,
        description: description,
        amount: amount,
        type: type,
        categoryId: category.id,
        date: date,
        note: note.isEmpty ? null : note,
      ));
    }

    return TransactionImportResult(valid: valid, invalid: invalid);
  }
}
