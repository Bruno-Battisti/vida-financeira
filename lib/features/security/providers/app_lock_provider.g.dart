// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appLockListenable)
final appLockListenableProvider = AppLockListenableProvider._();

final class AppLockListenableProvider
    extends
        $FunctionalProvider<
          AppLockListenable,
          AppLockListenable,
          AppLockListenable
        >
    with $Provider<AppLockListenable> {
  AppLockListenableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockListenableProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockListenableHash();

  @$internal
  @override
  $ProviderElement<AppLockListenable> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppLockListenable create(Ref ref) {
    return appLockListenable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLockListenable value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLockListenable>(value),
    );
  }
}

String _$appLockListenableHash() => r'e10af1619f4c5ef61d518717b375165fc6a1f99c';

@ProviderFor(appLockStorage)
final appLockStorageProvider = AppLockStorageProvider._();

final class AppLockStorageProvider
    extends $FunctionalProvider<AppLockStorage, AppLockStorage, AppLockStorage>
    with $Provider<AppLockStorage> {
  AppLockStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockStorageHash();

  @$internal
  @override
  $ProviderElement<AppLockStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppLockStorage create(Ref ref) {
    return appLockStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLockStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLockStorage>(value),
    );
  }
}

String _$appLockStorageHash() => r'a332620f5e196d6fb30e100cab3f97979e7038d3';

@ProviderFor(AppLockNotifier)
final appLockProvider = AppLockNotifierProvider._();

final class AppLockNotifierProvider
    extends $NotifierProvider<AppLockNotifier, AppLockState> {
  AppLockNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLockNotifierHash();

  @$internal
  @override
  AppLockNotifier create() => AppLockNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLockState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLockState>(value),
    );
  }
}

String _$appLockNotifierHash() => r'1bed66389904040e0f44bf476011d52853a00318';

abstract class _$AppLockNotifier extends $Notifier<AppLockState> {
  AppLockState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppLockState, AppLockState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppLockState, AppLockState>,
              AppLockState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
