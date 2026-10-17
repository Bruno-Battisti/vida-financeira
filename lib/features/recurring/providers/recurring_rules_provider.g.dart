// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_rules_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recurringRulesRepository)
final recurringRulesRepositoryProvider = RecurringRulesRepositoryProvider._();

final class RecurringRulesRepositoryProvider
    extends
        $FunctionalProvider<
          RecurringRulesRepository,
          RecurringRulesRepository,
          RecurringRulesRepository
        >
    with $Provider<RecurringRulesRepository> {
  RecurringRulesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recurringRulesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recurringRulesRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecurringRulesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecurringRulesRepository create(Ref ref) {
    return recurringRulesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecurringRulesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecurringRulesRepository>(value),
    );
  }
}

String _$recurringRulesRepositoryHash() =>
    r'2aa5dbed5ab46a921ebf27297af212340a1cbca6';

@ProviderFor(recurringRules)
final recurringRulesProvider = RecurringRulesProvider._();

final class RecurringRulesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecurringRule>>,
          List<RecurringRule>,
          Stream<List<RecurringRule>>
        >
    with
        $FutureModifier<List<RecurringRule>>,
        $StreamProvider<List<RecurringRule>> {
  RecurringRulesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recurringRulesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recurringRulesHash();

  @$internal
  @override
  $StreamProviderElement<List<RecurringRule>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RecurringRule>> create(Ref ref) {
    return recurringRules(ref);
  }
}

String _$recurringRulesHash() => r'46b7f288946872f424ab39eecf252e9a2ef0a529';

/// Roda uma única vez por sessão (provider `keepAlive`) assim que o usuário
/// entra no app, materializando as ocorrências de recorrências já vencidas.

@ProviderFor(recurringGeneration)
final recurringGenerationProvider = RecurringGenerationProvider._();

/// Roda uma única vez por sessão (provider `keepAlive`) assim que o usuário
/// entra no app, materializando as ocorrências de recorrências já vencidas.

final class RecurringGenerationProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Roda uma única vez por sessão (provider `keepAlive`) assim que o usuário
  /// entra no app, materializando as ocorrências de recorrências já vencidas.
  RecurringGenerationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recurringGenerationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recurringGenerationHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return recurringGeneration(ref);
  }
}

String _$recurringGenerationHash() =>
    r'be7e48422dff426d6fa5603b74f653e974579444';
