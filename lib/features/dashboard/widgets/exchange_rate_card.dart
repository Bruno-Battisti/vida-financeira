import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/currency_type.dart';
import '../providers/exchange_rate_provider.dart';

class ExchangeRateCard extends ConsumerWidget {
  const ExchangeRateCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratesAsync = ref.watch(exchangeRatesProvider);
    final selected = ref.watch(selectedCurrencyProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<CurrencyType>(
              segments: [
                for (final currency in CurrencyType.values)
                  ButtonSegment(
                    value: currency,
                    label: Text(currency.label),
                    icon: Icon(currency.icon, size: 16),
                  ),
              ],
              selected: {selected},
              onSelectionChanged: (selection) =>
                  ref.read(selectedCurrencyProvider.notifier).select(selection.first),
            ),
            const SizedBox(height: 12),
            ratesAsync.when(
              loading: () => const Row(
                children: [
                  SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2)),
                  SizedBox(width: 12),
                  Text('Buscando cotação...'),
                ],
              ),
              error: (error, _) => Row(
                children: [
                  Icon(Icons.cloud_off, color: Theme.of(context).colorScheme.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '$error',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Tentar novamente',
                    onPressed: () => ref.invalidate(exchangeRatesProvider),
                  ),
                ],
              ),
              data: (rates) {
                final rate = rates[selected]!;
                final isUp = rate.pctChange >= 0;
                return Row(
                  children: [
                    Icon(selected.icon),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${selected.label} hoje',
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'R\$ ${rate.bid.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // `Flexible` evita que o percentual force overflow em telas
                    // estreitas — em vez de vazar, o texto trunca com "...".
                    Flexible(
                      child: Text(
                        '${isUp ? '+' : ''}${rate.pctChange.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: isUp ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Atualizar cotação',
                      onPressed: () => ref.invalidate(exchangeRatesProvider),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
