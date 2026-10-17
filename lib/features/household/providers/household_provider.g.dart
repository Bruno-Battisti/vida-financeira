// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(householdsRepository)
final householdsRepositoryProvider = HouseholdsRepositoryProvider._();

final class HouseholdsRepositoryProvider
    extends
        $FunctionalProvider<
          HouseholdsRepository,
          HouseholdsRepository,
          HouseholdsRepository
        >
    with $Provider<HouseholdsRepository> {
  HouseholdsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'householdsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$householdsRepositoryHash();

  @$internal
  @override
  $ProviderElement<HouseholdsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HouseholdsRepository create(Ref ref) {
    return householdsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HouseholdsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HouseholdsRepository>(value),
    );
  }
}

String _$householdsRepositoryHash() =>
    r'11bdf5417e66735123c9841f7b90b0aa59a9827a';

@ProviderFor(household)
final householdProvider = HouseholdProvider._();

final class HouseholdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Household?>,
          Household?,
          Stream<Household?>
        >
    with $FutureModifier<Household?>, $StreamProvider<Household?> {
  HouseholdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'householdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$householdHash();

  @$internal
  @override
  $StreamProviderElement<Household?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Household?> create(Ref ref) {
    return household(ref);
  }
}

String _$householdHash() => r'a48f3fa5319121359f3e05933a7ce0bde59ee8cd';

/// Cria o household solo do usuário na primeira sessão, caso ele ainda não
/// faça parte de nenhum (nem o próprio, nem um compartilhado).

@ProviderFor(ensureHousehold)
final ensureHouseholdProvider = EnsureHouseholdProvider._();

/// Cria o household solo do usuário na primeira sessão, caso ele ainda não
/// faça parte de nenhum (nem o próprio, nem um compartilhado).

final class EnsureHouseholdProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Cria o household solo do usuário na primeira sessão, caso ele ainda não
  /// faça parte de nenhum (nem o próprio, nem um compartilhado).
  EnsureHouseholdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ensureHouseholdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ensureHouseholdHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return ensureHousehold(ref);
  }
}

String _$ensureHouseholdHash() => r'e5fde9434ab8e0120170cd4ff5ddb8734966384d';

/// uid efetivo usado para montar os caminhos `users/{effectiveOwnerUid}/...`
/// de todos os outros repositórios do app: o dono do household do usuário
/// (ele mesmo, por padrão, ou o dono de um household compartilhado em que
/// ele tenha entrado).

@ProviderFor(effectiveOwnerUid)
final effectiveOwnerUidProvider = EffectiveOwnerUidProvider._();

/// uid efetivo usado para montar os caminhos `users/{effectiveOwnerUid}/...`
/// de todos os outros repositórios do app: o dono do household do usuário
/// (ele mesmo, por padrão, ou o dono de um household compartilhado em que
/// ele tenha entrado).

final class EffectiveOwnerUidProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// uid efetivo usado para montar os caminhos `users/{effectiveOwnerUid}/...`
  /// de todos os outros repositórios do app: o dono do household do usuário
  /// (ele mesmo, por padrão, ou o dono de um household compartilhado em que
  /// ele tenha entrado).
  EffectiveOwnerUidProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'effectiveOwnerUidProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$effectiveOwnerUidHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return effectiveOwnerUid(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$effectiveOwnerUidHash() => r'a604d90ef8ecf6fa5885e5e5446236d5ad1613ed';
