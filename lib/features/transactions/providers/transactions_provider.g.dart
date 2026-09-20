// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transactionsRepository)
final transactionsRepositoryProvider = TransactionsRepositoryProvider._();

final class TransactionsRepositoryProvider
    extends
        $FunctionalProvider<
          TransactionsRepository,
          TransactionsRepository,
          TransactionsRepository
        >
    with $Provider<TransactionsRepository> {
  TransactionsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionsRepositoryHash();

  @$internal
  @override
  $ProviderElement<TransactionsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionsRepository create(Ref ref) {
    return transactionsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionsRepository>(value),
    );
  }
}

String _$transactionsRepositoryHash() =>
    r'3fe2220a2617c7e21b5e4a61db61711dc6ba62db';

@ProviderFor(transactions)
final transactionsProvider = TransactionsProvider._();

final class TransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Transaction>>,
          List<Transaction>,
          Stream<List<Transaction>>
        >
    with
        $FutureModifier<List<Transaction>>,
        $StreamProvider<List<Transaction>> {
  TransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionsHash();

  @$internal
  @override
  $StreamProviderElement<List<Transaction>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Transaction>> create(Ref ref) {
    return transactions(ref);
  }
}

String _$transactionsHash() => r'9b0708a0acde088ac8ffb46e8d5869e5d438d7da';

@ProviderFor(transactionById)
final transactionByIdProvider = TransactionByIdFamily._();

final class TransactionByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Transaction>,
          Transaction,
          FutureOr<Transaction>
        >
    with $FutureModifier<Transaction>, $FutureProvider<Transaction> {
  TransactionByIdProvider._({
    required TransactionByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'transactionByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transactionByIdHash();

  @override
  String toString() {
    return r'transactionByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Transaction> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Transaction> create(Ref ref) {
    final argument = this.argument as int;
    return transactionById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transactionByIdHash() => r'74ebc4743b0ae9c8d398cb113e9190eaca3bdcf1';

final class TransactionByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Transaction>, int> {
  TransactionByIdFamily._()
    : super(
        retry: null,
        name: r'transactionByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TransactionByIdProvider call(int id) =>
      TransactionByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'transactionByIdProvider';
}
