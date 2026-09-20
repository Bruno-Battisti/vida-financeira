import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/currency_type.dart';
import '../models/exchange_rate.dart';
import '../repositories/exchange_rate_repository.dart';

part 'exchange_rate_provider.g.dart';

@Riverpod(keepAlive: true)
http.Client httpClient(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
}

@riverpod
ExchangeRateRepository exchangeRateRepository(Ref ref) {
  return ExchangeRateRepository(ref.watch(httpClientProvider));
}

@riverpod
Future<Map<CurrencyType, ExchangeRate>> exchangeRates(Ref ref) {
  return ref.watch(exchangeRateRepositoryProvider).fetchRates();
}

@riverpod
class SelectedCurrency extends _$SelectedCurrency {
  @override
  CurrencyType build() => CurrencyType.usd;

  void select(CurrencyType currency) => state = currency;
}
