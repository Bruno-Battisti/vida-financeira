import 'package:freezed_annotation/freezed_annotation.dart';

part 'exchange_rate.freezed.dart';

@freezed
abstract class ExchangeRate with _$ExchangeRate {
  const factory ExchangeRate({
    required double bid,
    required double high,
    required double low,
    required double pctChange,
    required DateTime updatedAt,
  }) = _ExchangeRate;
}
