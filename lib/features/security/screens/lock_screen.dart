import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../providers/app_lock_provider.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen> {
  final _pinController = TextEditingController();
  final _localAuth = LocalAuthentication();
  bool _checking = false;
  String? _errorMessage;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submitPin() async {
    setState(() {
      _checking = true;
      _errorMessage = null;
    });

    final correct = await ref.read(appLockProvider.notifier).verifyPin(_pinController.text);

    if (!mounted) return;
    if (correct) {
      ref.read(appLockProvider.notifier).unlock();
    } else {
      setState(() {
        _errorMessage = 'PIN incorreto.';
        _checking = false;
      });
      _pinController.clear();
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Desbloqueie o Vida Financeira',
      );
      if (authenticated && mounted) {
        ref.read(appLockProvider.notifier).unlock();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Não foi possível usar a biometria: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockState = ref.watch(appLockProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'App bloqueado',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Digite seu PIN para continuar',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _pinController,
                  decoration: const InputDecoration(labelText: 'PIN'),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  onSubmitted: (_) => _submitPin(),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _checking ? null : _submitPin,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: _checking
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Desbloquear'),
                  ),
                ),
                if (lockState.biometricsEnabled) ...[
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: _authenticateWithBiometrics,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Usar biometria'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
