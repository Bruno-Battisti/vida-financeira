import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vida_financeira/core/providers/shared_preferences_provider.dart';
import 'package:vida_financeira/features/security/providers/app_lock_provider.dart';
import 'package:vida_financeira/features/security/services/app_lock_storage.dart';

class _FakeSecureStorage extends FlutterSecureStorage {
  final _values = <String, String>{};

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _values.remove(key);
    } else {
      _values[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _values[key];

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _values.remove(key);
  }
}

Future<ProviderContainer> _buildContainer() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      appLockStorageProvider.overrideWithValue(AppLockStorage(_FakeSecureStorage())),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  test('build() começa destravado quando o PIN não está habilitado', () async {
    final container = await _buildContainer();

    final state = container.read(appLockProvider);

    expect(state.pinEnabled, isFalse);
    expect(state.isLocked, isFalse);
  });

  test('setupPin habilita o PIN e mantém o app destravado', () async {
    final container = await _buildContainer();

    await container.read(appLockProvider.notifier).setupPin('1234');

    final state = container.read(appLockProvider);
    expect(state.pinEnabled, isTrue);
    expect(state.isLocked, isFalse);
  });

  test('lock() só trava quando o PIN está habilitado', () async {
    final container = await _buildContainer();

    container.read(appLockProvider.notifier).lock();
    expect(container.read(appLockProvider).isLocked, isFalse);

    await container.read(appLockProvider.notifier).setupPin('1234');
    container.read(appLockProvider.notifier).lock();
    expect(container.read(appLockProvider).isLocked, isTrue);
  });

  test('verifyPin confirma o PIN correto e rejeita o incorreto', () async {
    final container = await _buildContainer();
    await container.read(appLockProvider.notifier).setupPin('1234');

    final notifier = container.read(appLockProvider.notifier);
    expect(await notifier.verifyPin('1234'), isTrue);
    expect(await notifier.verifyPin('0000'), isFalse);
  });

  test('disablePin remove o PIN e desliga a biometria', () async {
    final container = await _buildContainer();
    await container.read(appLockProvider.notifier).setupPin('1234');
    await container.read(appLockProvider.notifier).setBiometricsEnabled(true);

    await container.read(appLockProvider.notifier).disablePin();

    final state = container.read(appLockProvider);
    expect(state.pinEnabled, isFalse);
    expect(state.biometricsEnabled, isFalse);
    expect(state.isLocked, isFalse);
  });
}
