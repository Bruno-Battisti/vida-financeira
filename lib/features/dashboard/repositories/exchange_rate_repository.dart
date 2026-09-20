import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/currency_type.dart';
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

  static final _uri = Uri.parse(
    'https://economia.awesomeapi.com.br/json/last/'
    '${CurrencyType.values.map((c) => c.pair).join(',')}',
  );

  /// Busca as cotações de todas as [CurrencyType] em uma única requisição —
  /// a AwesomeAPI aceita múltiplos pares separados por vírgula na mesma URL.
  Future<Map<CurrencyType, ExchangeRate>> fetchRates() async {
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
      return {
        for (final currency in CurrencyType.values)
          currency: _parseRate(body[currency.responseKey] as Map<String, dynamic>),
      };
    } catch (_) {
      throw ExchangeRateException('Não foi possível interpretar a resposta do serviço de cotação.');
    }
  }

  ExchangeRate _parseRate(Map<String, dynamic> data) {
    return ExchangeRate(
      bid: double.parse(data['bid'] as String),
      high: double.parse(data['high'] as String),
      low: double.parse(data['low'] as String),
      pctChange: double.parse(data['pctChange'] as String),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(int.parse(data['timestamp'] as String) * 1000),
    );
  }
}
