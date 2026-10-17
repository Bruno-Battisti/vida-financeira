// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transfersRepository)
final transfersRepositoryProvider = TransfersRepositoryProvider._();

final class TransfersRepositoryProvider
    extends
        $FunctionalProvider<
          TransfersRepository,
          TransfersRepository,
          TransfersRepository
        >
    with $Provider<TransfersRepository> {
  TransfersRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transfersRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transfersRepositoryHash();

  @$internal
  @override
  $ProviderElement<TransfersRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransfersRepository create(Ref ref) {
    return transfersRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransfersRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransfersRepository>(value),
    );
  }
}

String _$transfersRepositoryHash() =>
    r'0bacfb8de6c1cbdf81b49a58ef2028331b80b52c';

@ProviderFor(transfers)
final transfersProvider = TransfersProvider._();

final class TransfersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Transfer>>,
          List<Transfer>,
          Stream<List<Transfer>>
        >
    with $FutureModifier<List<Transfer>>, $StreamProvider<List<Transfer>> {
  TransfersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transfersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transfersHash();

  @$internal
  @override
  $StreamProviderElement<List<Transfer>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Transfer>> create(Ref ref) {
    return transfers(ref);
  }
}

String _$transfersHash() => r'6170765e982d52c3517088125a6408c26110ade8';

@ProviderFor(accountsRepository)
final accountsRepositoryProvider = AccountsRepositoryProvider._();

final class AccountsRepositoryProvider
    extends
        $FunctionalProvider<
          AccountsRepository,
          AccountsRepository,
          AccountsRepository
        >
    with $Provider<AccountsRepository> {
  AccountsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AccountsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountsRepository create(Ref ref) {
    return accountsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountsRepository>(value),
    );
  }
}

String _$accountsRepositoryHash() =>
    r'c340aa7742b07a28d0c75b338eea06e2e65bb27e';

@ProviderFor(accounts)
final accountsProvider = AccountsProvider._();

final class AccountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Account>>,
          List<Account>,
          Stream<List<Account>>
        >
    with $FutureModifier<List<Account>>, $StreamProvider<List<Account>> {
  AccountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountsHash();

  @$internal
  @override
  $StreamProviderElement<List<Account>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Account>> create(Ref ref) {
    return accounts(ref);
  }
}

String _$accountsHash() => r'6c999354b4a4576f3d5caba58bbe66b46bb996b0';

/// Cria a conta "Principal" na primeira vez que o usuário abre o app depois
/// desta feature — garante que sempre exista pelo menos uma conta para
/// absorver as transações antigas (que não têm `accountId`).

@ProviderFor(ensureDefaultAccount)
final ensureDefaultAccountProvider = EnsureDefaultAccountProvider._();

/// Cria a conta "Principal" na primeira vez que o usuário abre o app depois
/// desta feature — garante que sempre exista pelo menos uma conta para
/// absorver as transações antigas (que não têm `accountId`).

final class EnsureDefaultAccountProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Cria a conta "Principal" na primeira vez que o usuário abre o app depois
  /// desta feature — garante que sempre exista pelo menos uma conta para
  /// absorver as transações antigas (que não têm `accountId`).
  EnsureDefaultAccountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ensureDefaultAccountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ensureDefaultAccountHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return ensureDefaultAccount(ref);
  }
}

String _$ensureDefaultAccountHash() =>
    r'64ab443ba3c0185c44ddaa5daecd0620d799e5bb';

/// Saldo de cada conta: saldo inicial + soma das transações já pagas
/// atribuídas a ela (transações antigas sem `accountId` contam para a
/// conta padrão) + transferências recebidas/enviadas.

@ProviderFor(accountBalances)
final accountBalancesProvider = AccountBalancesProvider._();

/// Saldo de cada conta: saldo inicial + soma das transações já pagas
/// atribuídas a ela (transações antigas sem `accountId` contam para a
/// conta padrão) + transferências recebidas/enviadas.

final class AccountBalancesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AccountBalance>>,
          List<AccountBalance>,
          FutureOr<List<AccountBalance>>
        >
    with
        $FutureModifier<List<AccountBalance>>,
        $FutureProvider<List<AccountBalance>> {
  /// Saldo de cada conta: saldo inicial + soma das transações já pagas
  /// atribuídas a ela (transações antigas sem `accountId` contam para a
  /// conta padrão) + transferências recebidas/enviadas.
  AccountBalancesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountBalancesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountBalancesHash();

  @$internal
  @override
  $FutureProviderElement<List<AccountBalance>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AccountBalance>> create(Ref ref) {
    return accountBalances(ref);
  }
}

String _$accountBalancesHash() => r'ab18f529af358b42cbd837a888ddc75325767a89';

/// Fatura fechada mais recente de um cartão de crédito: soma das compras do
/// ciclo (já inclui parcelas, que são transações normais com `accountId`
/// apontando para o cartão).

@ProviderFor(creditCardInvoice)
final creditCardInvoiceProvider = CreditCardInvoiceFamily._();

/// Fatura fechada mais recente de um cartão de crédito: soma das compras do
/// ciclo (já inclui parcelas, que são transações normais com `accountId`
/// apontando para o cartão).

final class CreditCardInvoiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<CreditCardInvoice>,
          CreditCardInvoice,
          FutureOr<CreditCardInvoice>
        >
    with
        $FutureModifier<CreditCardInvoice>,
        $FutureProvider<CreditCardInvoice> {
  /// Fatura fechada mais recente de um cartão de crédito: soma das compras do
  /// ciclo (já inclui parcelas, que são transações normais com `accountId`
  /// apontando para o cartão).
  CreditCardInvoiceProvider._({
    required CreditCardInvoiceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'creditCardInvoiceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$creditCardInvoiceHash();

  @override
  String toString() {
    return r'creditCardInvoiceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CreditCardInvoice> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CreditCardInvoice> create(Ref ref) {
    final argument = this.argument as String;
    return creditCardInvoice(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CreditCardInvoiceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$creditCardInvoiceHash() => r'd75c846291484fb5d380b8e36ae779798a35627e';

/// Fatura fechada mais recente de um cartão de crédito: soma das compras do
/// ciclo (já inclui parcelas, que são transações normais com `accountId`
/// apontando para o cartão).

final class CreditCardInvoiceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CreditCardInvoice>, String> {
  CreditCardInvoiceFamily._()
    : super(
        retry: null,
        name: r'creditCardInvoiceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fatura fechada mais recente de um cartão de crédito: soma das compras do
  /// ciclo (já inclui parcelas, que são transações normais com `accountId`
  /// apontando para o cartão).

  CreditCardInvoiceProvider call(String accountId) =>
      CreditCardInvoiceProvider._(argument: accountId, from: this);

  @override
  String toString() => r'creditCardInvoiceProvider';
}
