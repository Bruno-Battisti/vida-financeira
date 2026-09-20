import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:vida_financeira/features/dashboard/repositories/exchange_rate_repository.dart';

void main() {
  test('fetchUsdToBrl() interpreta uma resposta válida', () async {
    final client = MockClient((request) async {
      return http.Response(
        jsonEncode({
          'USDBRL': {
            'bid': '5.4321',
            'high': '5.45',
            'low': '5.40',
            'pctChange': '0.18',
            'timestamp': '1695123456',
          },
        }),
        200,
      );
    });

    final repository = ExchangeRateRepository(client);
    final rate = await repository.fetchUsdToBrl();

    expect(rate.bid, 5.4321);
    expect(rate.high, 5.45);
    expect(rate.low, 5.40);
    expect(rate.pctChange, 0.18);
  });

  test('fetchUsdToBrl() lança erro amigável quando o servidor responde com falha', () async {
    final client = MockClient((request) async => http.Response('erro interno', 500));
    final repository = ExchangeRateRepository(client);

    expect(repository.fetchUsdToBrl(), throwsA(isA<ExchangeRateException>()));
  });

  test('fetchUsdToBrl() lança erro amigável quando não há conexão', () async {
    final client = MockClient((request) async => throw Exception('sem rede'));
    final repository = ExchangeRateRepository(client);

    expect(repository.fetchUsdToBrl(), throwsA(isA<ExchangeRateException>()));
  });

  test('fetchUsdToBrl() lança erro amigável para resposta malformada', () async {
    final client = MockClient((request) async => http.Response('isso não é json', 200));
    final repository = ExchangeRateRepository(client);

    expect(repository.fetchUsdToBrl(), throwsA(isA<ExchangeRateException>()));
  });
}
