// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GoalsNotifier)
final goalsProvider = GoalsNotifierProvider._();

final class GoalsNotifierProvider
    extends $NotifierProvider<GoalsNotifier, List<Goal>> {
  GoalsNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$goalsNotifierHash();

  @$internal
  @override
  GoalsNotifier create() => GoalsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Goal> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Goal>>(value),
    );
  }
}

String _$goalsNotifierHash() => r'b13a81c787fd728f68aa7f7d386a199ca0bf174c';

abstract class _$GoalsNotifier extends $Notifier<List<Goal>> {
  List<Goal> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<Goal>, List<Goal>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Goal>, List<Goal>>,
              List<Goal>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(goalById)
final goalByIdProvider = GoalByIdFamily._();

final class GoalByIdProvider extends $FunctionalProvider<Goal, Goal, Goal>
    with $Provider<Goal> {
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
  $ProviderElement<Goal> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Goal create(Ref ref) {
    final argument = this.argument as int;
    return goalById(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Goal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Goal>(value),
    );
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

String _$goalByIdHash() => r'5d6502ffd01a0644a7f38b6d3140aebd6b4b2c25';

final class GoalByIdFamily extends $Family
    with $FunctionalFamilyOverride<Goal, int> {
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
