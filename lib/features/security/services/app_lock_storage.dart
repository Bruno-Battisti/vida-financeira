import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppLockStorage {
  AppLockStorage(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  static const _pinKey = 'app_lock_pin';

  Future<void> savePin(String pin) => _secureStorage.write(key: _pinKey, value: pin);

  Future<String?> readPin() => _secureStorage.read(key: _pinKey);

  Future<void> clearPin() => _secureStorage.delete(key: _pinKey);
}
