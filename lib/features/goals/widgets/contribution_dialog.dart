import 'package:flutter/material.dart';

class ContributionDialog extends StatefulWidget {
  const ContributionDialog({super.key, required this.isWithdrawal});

  final bool isWithdrawal;

  @override
  State<ContributionDialog> createState() => _ContributionDialogState();
}

class _ContributionDialogState extends State<ContributionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _confirm() {
    if (!_formKey.currentState!.validate()) return;
    final value = double.parse(_amountController.text.trim().replaceAll(',', '.'));
    Navigator.of(context).pop(widget.isWithdrawal ? -value : value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isWithdrawal ? 'Retirar dinheiro' : 'Adicionar aporte'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _amountController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Valor', prefixText: 'R\$ '),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onFieldSubmitted: (_) => _confirm(),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Informe o valor.';
            }
            final parsed = double.tryParse(value.trim().replaceAll(',', '.'));
            if (parsed == null || parsed <= 0) {
              return 'Valor inválido.';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _confirm,
          child: const Text('Confirmar'),
        ),
      ],
    );
  }
}
