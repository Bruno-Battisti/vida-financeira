import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/responsive_center.dart';
import '../providers/transactions_provider.dart';
import '../services/transaction_csv_importer.dart';

class ImportPreviewScreen extends ConsumerStatefulWidget {
  const ImportPreviewScreen({super.key, required this.result});

  final TransactionImportResult result;

  @override
  ConsumerState<ImportPreviewScreen> createState() => _ImportPreviewScreenState();
}

class _ImportPreviewScreenState extends ConsumerState<ImportPreviewScreen> {
  bool _importing = false;

  Future<void> _confirmImport() async {
    setState(() => _importing = true);
    try {
      await ref.read(transactionsRepositoryProvider).addBatch(widget.result.valid);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.result.valid.length} transações importadas.')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível importar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.result.valid.length + widget.result.invalid.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Importar transações')),
      body: ResponsiveCenter(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$total linhas lidas — ${widget.result.valid.length} válidas, ${widget.result.invalid.length} inválidas',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'A importação sempre adiciona novas transações; nada é alterado ou removido. '
                      'Importar o mesmo arquivo duas vezes duplica os dados.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.result.invalid.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Linhas inválidas', style: Theme.of(context).textTheme.titleSmall),
              for (final row in widget.result.invalid)
                ListTile(
                  leading: const Icon(Icons.error_outline, color: Colors.red),
                  title: Text('Linha ${row.lineNumber}: ${row.reason}'),
                  subtitle: Text(row.rawLine),
                ),
            ],
            if (widget.result.valid.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Linhas válidas', style: Theme.of(context).textTheme.titleSmall),
              for (final row in widget.result.valid)
                ListTile(
                  leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                  title: Text(row.description),
                  subtitle: Text('Linha ${row.lineNumber}'),
                ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: widget.result.valid.isEmpty || _importing ? null : _confirmImport,
              child: _importing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('Importar ${widget.result.valid.length} transações'),
            ),
          ],
        ),
      ),
    );
  }
}
