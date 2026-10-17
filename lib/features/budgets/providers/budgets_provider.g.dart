// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budgets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(budgetsRepository)
final budgetsRepositoryProvider = BudgetsRepositoryProvider._();

final class BudgetsRepositoryProvider
    extends
        $FunctionalProvider<
          BudgetsRepository,
          BudgetsRepository,
          BudgetsRepository
        >
    with $Provider<BudgetsRepository> {
  BudgetsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetsRepositoryHash();

  @$internal
  @override
  $ProviderElement<BudgetsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BudgetsRepository create(Ref ref) {
    return budgetsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetsRepository>(value),
    );
  }
}

String _$budgetsRepositoryHash() => r'daf35a30a25cd56685845512d42081b2e17ca4d9';

@ProviderFor(budgets)
final budgetsProvider = BudgetsProvider._();

final class BudgetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Budget>>,
          List<Budget>,
          Stream<List<Budget>>
        >
    with $FutureModifier<List<Budget>>, $StreamProvider<List<Budget>> {
  BudgetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetsHash();

  @$internal
  @override
  $StreamProviderElement<List<Budget>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Budget>> create(Ref ref) {
    return budgets(ref);
  }
}

String _$budgetsHash() => r'283986afa77f605cf91876949c34845b3c48611c';

/// Orçamentos cruzados com o gasto do mês atual em cada categoria.

@ProviderFor(budgetProgress)
final budgetProgressProvider = BudgetProgressProvider._();

/// Orçamentos cruzados com o gasto do mês atual em cada categoria.

final class BudgetProgressProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BudgetProgress>>,
          List<BudgetProgress>,
          FutureOr<List<BudgetProgress>>
        >
    with
        $FutureModifier<List<BudgetProgress>>,
        $FutureProvider<List<BudgetProgress>> {
  /// Orçamentos cruzados com o gasto do mês atual em cada categoria.
  BudgetProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetProgressHash();

  @$internal
  @override
  $FutureProviderElement<List<BudgetProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BudgetProgress>> create(Ref ref) {
    return budgetProgress(ref);
  }
}

String _$budgetProgressHash() => r'f3a4f6fa14412c75ce48e2ab75b9c5eb9d2d9f09';
