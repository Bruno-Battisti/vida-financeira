import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/utils/formatters.dart';
import '../models/category.dart';
import '../models/transaction.dart';

class TransactionPdfExporter {
  TransactionPdfExporter._();

  static const _header = ['Data', 'Descrição', 'Categoria', 'Tipo', 'Valor', 'Observação'];

  static Future<Uint8List> build(
    List<Transaction> transactions,
    Map<int, Category> categoryMap,
  ) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Vida Financeira - Transações', style: const pw.TextStyle(fontSize: 20)),
          ),
          pw.Text('Gerado em ${formatDate(DateTime.now())}'),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headers: _header,
            data: [
              for (final transaction in transactions)
                [
                  formatDate(transaction.date),
                  transaction.description,
                  categoryMap[transaction.categoryId]?.name ?? '',
                  transaction.type == TransactionType.income ? 'Receita' : 'Despesa',
                  transaction.amount.toStringAsFixed(2),
                  transaction.note ?? '',
                ],
            ],
          ),
        ],
      ),
    );

    return doc.save();
  }
}
