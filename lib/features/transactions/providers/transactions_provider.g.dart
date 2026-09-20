// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransactionsNotifier)
final transactionsProvider = TransactionsNotifierProvider._();

final class TransactionsNotifierProvider
    extends $NotifierProvider<TransactionsNotifier, List<Transaction>> {
  TransactionsNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$transactionsNotifierHash();

  @$internal
  @override
  TransactionsNotifier create() => TransactionsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Transaction> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Transaction>>(value),
    );
  }
}

String _$transactionsNotifierHash() =>
    r'078e4b4c41a4f10c7044291de7b4a2ac9d2b3296';

abstract class _$TransactionsNotifier extends $Notifier<List<Transaction>> {
  List<Transaction> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<Transaction>, List<Transaction>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Transaction>, List<Transaction>>,
              List<Transaction>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(transactionById)
final transactionByIdProvider = TransactionByIdFamily._();

final class TransactionByIdProvider
    extends $FunctionalProvider<Transaction, Transaction, Transaction>
    with $Provider<Transaction> {
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
  $ProviderElement<Transaction> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Transaction create(Ref ref) {
    final argument = this.argument as int;
    return transactionById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Transaction value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Transaction>(value),
    );
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

String _$transactionByIdHash() => r'053a21d51d13ddb101fcec7183f88a5961df20b2';

final class TransactionByIdFamily extends $Family
    with $FunctionalFamilyOverride<Transaction, int> {
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
