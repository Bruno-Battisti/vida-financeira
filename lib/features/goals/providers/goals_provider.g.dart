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
          AsyncValue<List<GoalProgress>>,
          List<GoalProgress>,
          Stream<List<GoalProgress>>
        >
    with
        $FutureModifier<List<GoalProgress>>,
        $StreamProvider<List<GoalProgress>> {
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
  $StreamProviderElement<List<GoalProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<GoalProgress>> create(Ref ref) {
    return goals(ref);
  }
}

String _$goalsHash() => r'0b7ab87110548bbf1e15fb87be0bccd49932753c';

@ProviderFor(goalById)
final goalByIdProvider = GoalByIdFamily._();

final class GoalByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<GoalProgress>,
          GoalProgress,
          FutureOr<GoalProgress>
        >
    with $FutureModifier<GoalProgress>, $FutureProvider<GoalProgress> {
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
  $FutureProviderElement<GoalProgress> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GoalProgress> create(Ref ref) {
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

String _$goalByIdHash() => r'e796d822227ce60b860bd756a0b2d2050591423d';

final class GoalByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<GoalProgress>, int> {
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

@ProviderFor(goalEntries)
final goalEntriesProvider = GoalEntriesFamily._();

final class GoalEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GoalTransaction>>,
          List<GoalTransaction>,
          Stream<List<GoalTransaction>>
        >
    with
        $FutureModifier<List<GoalTransaction>>,
        $StreamProvider<List<GoalTransaction>> {
  GoalEntriesProvider._({
    required GoalEntriesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'goalEntriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$goalEntriesHash();

  @override
  String toString() {
    return r'goalEntriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<GoalTransaction>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<GoalTransaction>> create(Ref ref) {
    final argument = this.argument as int;
    return goalEntries(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GoalEntriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$goalEntriesHash() => r'c3c6e8db619a60a2c73bf64500b74f1f8ce7933a';

final class GoalEntriesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<GoalTransaction>>, int> {
  GoalEntriesFamily._()
    : super(
        retry: null,
        name: r'goalEntriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GoalEntriesProvider call(int goalId) =>
      GoalEntriesProvider._(argument: goalId, from: this);

  @override
  String toString() => r'goalEntriesProvider';
}
