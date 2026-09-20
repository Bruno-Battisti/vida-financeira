// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(httpClient)
final httpClientProvider = HttpClientProvider._();

final class HttpClientProvider
    extends $FunctionalProvider<http.Client, http.Client, http.Client>
    with $Provider<http.Client> {
  HttpClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'httpClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$httpClientHash();

  @$internal
  @override
  $ProviderElement<http.Client> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  http.Client create(Ref ref) {
    return httpClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(http.Client value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<http.Client>(value),
    );
  }
}

String _$httpClientHash() => r'7ec49beae0f15115de79f9aa98dbd250130e26d8';

@ProviderFor(exchangeRateRepository)
final exchangeRateRepositoryProvider = ExchangeRateRepositoryProvider._();

final class ExchangeRateRepositoryProvider
    extends
        $FunctionalProvider<
          ExchangeRateRepository,
          ExchangeRateRepository,
          ExchangeRateRepository
        >
    with $Provider<ExchangeRateRepository> {
  ExchangeRateRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeRateRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeRateRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExchangeRateRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExchangeRateRepository create(Ref ref) {
    return exchangeRateRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExchangeRateRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExchangeRateRepository>(value),
    );
  }
}

String _$exchangeRateRepositoryHash() =>
    r'a7f9c4fcea8f73e6f490ff8b234f24b8715967ae';

@ProviderFor(exchangeRates)
final exchangeRatesProvider = ExchangeRatesProvider._();

final class ExchangeRatesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<CurrencyType, ExchangeRate>>,
          Map<CurrencyType, ExchangeRate>,
          FutureOr<Map<CurrencyType, ExchangeRate>>
        >
    with
        $FutureModifier<Map<CurrencyType, ExchangeRate>>,
        $FutureProvider<Map<CurrencyType, ExchangeRate>> {
  ExchangeRatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exchangeRatesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exchangeRatesHash();

  @$internal
  @override
  $FutureProviderElement<Map<CurrencyType, ExchangeRate>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<CurrencyType, ExchangeRate>> create(Ref ref) {
    return exchangeRates(ref);
  }
}

String _$exchangeRatesHash() => r'f18bd78d69243603c471970383e95e76e75dbaf9';

@ProviderFor(SelectedCurrency)
final selectedCurrencyProvider = SelectedCurrencyProvider._();

final class SelectedCurrencyProvider
    extends $NotifierProvider<SelectedCurrency, CurrencyType> {
  SelectedCurrencyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCurrencyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCurrencyHash();

  @$internal
  @override
  SelectedCurrency create() => SelectedCurrency();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CurrencyType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CurrencyType>(value),
    );
  }
}

String _$selectedCurrencyHash() => r'1b4869962210b459d6c4661f0c5c6799a303702c';

abstract class _$SelectedCurrency extends $Notifier<CurrencyType> {
  CurrencyType build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CurrencyType, CurrencyType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CurrencyType, CurrencyType>,
              CurrencyType,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
