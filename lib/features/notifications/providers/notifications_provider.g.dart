// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationService)
final notificationServiceProvider = NotificationServiceProvider._();

final class NotificationServiceProvider
    extends
        $FunctionalProvider<
          NotificationService,
          NotificationService,
          NotificationService
        >
    with $Provider<NotificationService> {
  NotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationServiceHash();

  @$internal
  @override
  $ProviderElement<NotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationService create(Ref ref) {
    return notificationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationService>(value),
    );
  }
}

String _$notificationServiceHash() =>
    r'585c1e42ea844e71a2b76b80b165adfe2c5c8529';

@ProviderFor(RemindersEnabledNotifier)
final remindersEnabledProvider = RemindersEnabledNotifierProvider._();

final class RemindersEnabledNotifierProvider
    extends $NotifierProvider<RemindersEnabledNotifier, bool> {
  RemindersEnabledNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remindersEnabledProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remindersEnabledNotifierHash();

  @$internal
  @override
  RemindersEnabledNotifier create() => RemindersEnabledNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$remindersEnabledNotifierHash() =>
    r'c56a101e2dca767dc4b4cca77f2796edcfcf9410';

abstract class _$RemindersEnabledNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Reagenda (ou cancela) os lembretes de vencimento de contas e de prazo de
/// metas. Roda uma vez por sessão — como `recurringGenerationProvider` — e
/// de novo sempre que o usuário alterna a preferência em Configurações.

@ProviderFor(reminderScheduling)
final reminderSchedulingProvider = ReminderSchedulingProvider._();

/// Reagenda (ou cancela) os lembretes de vencimento de contas e de prazo de
/// metas. Roda uma vez por sessão — como `recurringGenerationProvider` — e
/// de novo sempre que o usuário alterna a preferência em Configurações.

final class ReminderSchedulingProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Reagenda (ou cancela) os lembretes de vencimento de contas e de prazo de
  /// metas. Roda uma vez por sessão — como `recurringGenerationProvider` — e
  /// de novo sempre que o usuário alterna a preferência em Configurações.
  ReminderSchedulingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderSchedulingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderSchedulingHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return reminderScheduling(ref);
  }
}

String _$reminderSchedulingHash() =>
    r'ddb1cdca08cae829662fba9b1ff19f0374b8d737';
