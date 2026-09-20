// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(goalsRepository)
final goalsRepositoryProvider = GoalsRepositoryProvider._();

final class GoalsRepositoryProvider
    extends
        $FunctionalProvider<GoalsRepository, GoalsRepository, GoalsRepository>
    with $Provider<GoalsRepository> {
  GoalsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalsRepositoryHash();

  @$internal
  @override
  $ProviderElement<GoalsRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoalsRepository create(Ref ref) {
    return goalsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoalsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoalsRepository>(value),
    );
  }
}

String _$goalsRepositoryHash() => r'b89a2fed1835226180f3d801e44f53096e4d551d';

@ProviderFor(goals)
final goalsProvider = GoalsProvider._();

final class GoalsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Goal>>,
          List<Goal>,
          Stream<List<Goal>>
        >
    with $FutureModifier<List<Goal>>, $StreamProvider<List<Goal>> {
  GoalsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalsHash();

  @$internal
  @override
  $StreamProviderElement<List<Goal>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Goal>> create(Ref ref) {
    return goals(ref);
  }
}

String _$goalsHash() => r'0de6803cf30c9a65e1fa7e034f59eeafae53a514';

@ProviderFor(goalById)
final goalByIdProvider = GoalByIdFamily._();

final class GoalByIdProvider
    extends $FunctionalProvider<AsyncValue<Goal>, Goal, FutureOr<Goal>>
    with $FutureModifier<Goal>, $FutureProvider<Goal> {
  GoalByIdProvider._({
    required GoalByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'goalByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$goalByIdHash();

  @override
  String toString() {
    return r'goalByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Goal> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Goal> create(Ref ref) {
    final argument = this.argument as int;
    return goalById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GoalByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$goalByIdHash() => r'45d132432abbb61592baf622869950bea7cf18e6';

final class GoalByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Goal>, int> {
  GoalByIdFamily._()
    : super(
        retry: null,
        name: r'goalByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GoalByIdProvider call(int id) => GoalByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'goalByIdProvider';
}
