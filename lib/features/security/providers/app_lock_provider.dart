import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../services/app_lock_storage.dart';

part 'app_lock_provider.g.dart';

const _pinEnabledKey = 'pin_enabled';
const _biometricsEnabledKey = 'biometrics_enabled';

typedef AppLockState = ({bool isLocked, bool pinEnabled, bool biometricsEnabled});

/// Ponte entre o [AppLockNotifier] e o `refreshListenable` do GoRouter —
/// o GoRouter só recalcula `redirect` quando um [Listenable] notifica.
class AppLockListenable extends ChangeNotifier {
  void ping() => notifyListeners();
}

@Riverpod(keepAlive: true)
AppLockListenable appLockListenable(Ref ref) => AppLockListenable();

@Riverpod(keepAlive: true)
AppLockStorage appLockStorage(Ref ref) => AppLockStorage(const FlutterSecureStorage());

@Riverpod(keepAlive: true)
class AppLockNotifier extends _$AppLockNotifier {
  @override
  AppLockState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final pinEnabled = prefs.getBool(_pinEnabledKey) ?? false;
    final biometricsEnabled = prefs.getBool(_biometricsEnabledKey) ?? false;
    return (isLocked: pinEnabled, pinEnabled: pinEnabled, biometricsEnabled: biometricsEnabled);
  }

  void lock() {
    if (!state.pinEnabled || state.isLocked) return;
    state = (isLocked: true, pinEnabled: state.pinEnabled, biometricsEnabled: state.biometricsEnabled);
    ref.read(appLockListenableProvider).ping();
  }

  void unlock() {
    state = (isLocked: false, pinEnabled: state.pinEnabled, biometricsEnabled: state.biometricsEnabled);
    ref.read(appLockListenableProvider).ping();
  }

  Future<void> setupPin(String pin) async {
    await ref.read(appLockStorageProvider).savePin(pin);
    await ref.read(sharedPreferencesProvider).setBool(_pinEnabledKey, true);
    state = (isLocked: false, pinEnabled: true, biometricsEnabled: state.biometricsEnabled);
    ref.read(appLockListenableProvider).ping();
  }

  Future<void> disablePin() async {
    await ref.read(appLockStorageProvider).clearPin();
    await ref.read(sharedPreferencesProvider).setBool(_pinEnabledKey, false);
    await ref.read(sharedPreferencesProvider).setBool(_biometricsEnabledKey, false);
    state = (isLocked: false, pinEnabled: false, biometricsEnabled: false);
    ref.read(appLockListenableProvider).ping();
  }

  Future<void> setBiometricsEnabled(bool value) async {
    await ref.read(sharedPreferencesProvider).setBool(_biometricsEnabledKey, value);
    state = (isLocked: state.isLocked, pinEnabled: state.pinEnabled, biometricsEnabled: value);
  }

  Future<bool> verifyPin(String pin) async {
    final saved = await ref.read(appLockStorageProvider).readPin();
    return saved != null && saved == pin;
  }
}
