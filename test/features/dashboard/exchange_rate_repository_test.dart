import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:vida_financeira/features/dashboard/models/currency_type.dart';
import 'package:vida_financeira/features/dashboard/repositories/exchange_rate_repository.dart';

Map<String, dynamic> _rate({String bid = '5.4321'}) => {
      'bid': bid,
      'high': '5.45',
      'low': '5.40',
      'pctChange': '0.18',
      'timestamp': '1695123456',
    };

void main() {
  test('fetchRates() interpreta uma resposta válida para todas as moedas', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'USDBRL': _rate(bid: '5.4321'),
          'BTCBRL': _rate(bid: '350000.00'),
          'EURBRL': _rate(bid: '5.90'),
        }),
        200,
      );
    });

    final repository = ExchangeRateRepository(client);
    final rates = await repository.fetchRates();

    expect(rates[CurrencyType.usd]!.bid, 5.4321);
    expect(rates[CurrencyType.btc]!.bid, 350000.00);
    expect(rates[CurrencyType.eur]!.bid, 5.90);
  });

  test('fetchRates() lança erro amigável quando o servidor responde com falha', () async {
    final client = MockClient((request) async => http.Response('erro interno', 500));
    final repository = ExchangeRateRepository(client);

    expect(repository.fetchRates(), throwsA(isA<ExchangeRateException>()));
  });

  test('fetchRates() lança erro amigável quando não há conexão', () async {
    final client = MockClient((request) async => throw Exception('sem rede'));
    final repository = ExchangeRateRepository(client);

    expect(repository.fetchRates(), throwsA(isA<ExchangeRateException>()));
  });

  test('fetchRates() lança erro amigável para resposta malformada', () async {
    final client = MockClient((request) async => http.Response('isso não é json', 200));
    final repository = ExchangeRateRepository(client);

    expect(repository.fetchRates(), throwsA(isA<ExchangeRateException>()));
  });
}
