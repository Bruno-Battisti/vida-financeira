import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/exchange_rate.dart';

/// Erro amigável para exibir na UI — já traduzido, sem vazar detalhes
/// técnicos da exceção original (SocketException, FormatException etc.).
class ExchangeRateException implements Exception {
  ExchangeRateException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ExchangeRateRepository {
  ExchangeRateRepository(this._client);

  final http.Client _client;

  static final _uri = Uri.parse('https://economia.awesomeapi.com.br/json/last/USD-BRL');

  Future<ExchangeRate> fetchUsdToBrl() async {
    final http.Response response;
    try {
      response = await _client.get(_uri).timeout(const Duration(seconds: 10));
    } catch (_) {
      throw ExchangeRateException('Sem conexão com a internet. Verifique sua rede e tente novamente.');
    }

    if (response.statusCode != 200) {
      throw ExchangeRateException('O serviço de cotação retornou um erro (${response.statusCode}).');
    }

    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['USDBRL'] as Map<String, dynamic>;
      return ExchangeRate(
        bid: double.parse(data['bid'] as String),
        high: double.parse(data['high'] as String),
        low: double.parse(data['low'] as String),
        pctChange: double.parse(data['pctChange'] as String),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(int.parse(data['timestamp'] as String) * 1000),
      );
    } catch (_) {
      throw ExchangeRateException('Não foi possível interpretar a resposta do serviço de cotação.');
    }
  }
}
