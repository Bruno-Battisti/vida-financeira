double? parseAmountInput(String raw) =>
    double.tryParse(raw.trim().replaceAll(',', '.'));
