import 'package:flutter/material.dart';

enum CurrencyType {
  usd('USD-BRL', 'Dólar', Icons.attach_money),
  btc('BTC-BRL', 'Bitcoin', Icons.currency_bitcoin),
  eur('EUR-BRL', 'Euro', Icons.euro);

  const CurrencyType(this.pair, this.label, this.icon);

  /// Código do par de moedas aceito pela AwesomeAPI (ex: `USD-BRL`).
  final String pair;
  final String label;
  final IconData icon;

  /// Chave usada pela AwesomeAPI na resposta JSON (ex: `USDBRL`).
  String get responseKey => pair.replaceAll('-', '');
}
