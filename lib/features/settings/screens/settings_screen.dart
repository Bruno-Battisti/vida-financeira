import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/theme_mode_provider.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/widgets/responsive_center.dart';
import '../../security/providers/app_lock_provider.dart';
import '../../transactions/providers/categories_provider.dart';
import '../../transactions/providers/transactions_provider.dart';
import '../../transactions/services/transaction_csv_exporter.dart';
import '../../transactions/services/transaction_csv_importer.dart';
import '../../transactions/services/transaction_pdf_exporter.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final user = ref.watch(firebaseAuthProvider).currentUser;
    final lockState = ref.watch(appLockProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ResponsiveCenter(
        child: ListView(
          children: [
            const _SectionLabel('Conta'),
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: Text(user?.email ?? 'Não autenticado'),
              subtitle:
                  const Text('Seus dados ficam sincronizados nesta conta'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () => ref.read(firebaseAuthProvider).signOut(),
            ),
            const Divider(),
            const _SectionLabel('Aparência'),
            ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text('Tema'),
              subtitle: Text(_themeModeLabel(themeMode)),
              onTap: () => _showThemeDialog(context, ref, themeMode),
            ),
            const Divider(),
            const _SectionLabel('Segurança'),
            SwitchListTile(
              secondary: const Icon(Icons.lock_outline),
              title: const Text('Bloqueio por PIN'),
              subtitle: const Text('Exige um PIN ao reabrir o app'),
              value: lockState.pinEnabled,
              onChanged: (value) => value
                  ? _setupPinFlow(context, ref)
                  : ref.read(appLockProvider.notifier).disablePin(),
            ),
            if (lockState.pinEnabled)
              FutureBuilder<bool>(
                future: LocalAuthentication().canCheckBiometrics,
                builder: (context, snapshot) {
                  if (snapshot.data != true) return const SizedBox.shrink();
                  return SwitchListTile(
                    secondary: const Icon(Icons.fingerprint),
                    title: const Text('Desbloqueio por biometria'),
                    subtitle: const Text(
                        'Usa digital ou reconhecimento facial do aparelho'),
                    value: lockState.biometricsEnabled,
                    onChanged: (value) => ref
                        .read(appLockProvider.notifier)
                        .setBiometricsEnabled(value),
                  );
                },
              ),
            const Divider(),
            const _SectionLabel('Preferências'),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Moeda'),
              subtitle: const Text('Real (R\$)'),
              onTap: () => _showComingSoon(context),
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notificações'),
              subtitle: const Text('Disponível na Fase 12'),
              onTap: () => _showComingSoon(context),
            ),
            const Divider(),
            const _SectionLabel('Dados'),
            ListTile(
              leading: const Icon(Icons.upload_outlined),
              title: const Text('Exportar dados'),
              subtitle: const Text('Baixa suas transações em um arquivo CSV'),
              onTap: () => _exportData(context, ref),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: const Text('Exportar PDF'),
              subtitle:
                  const Text('Gera um relatório em PDF das suas transações'),
              onTap: () => _exportPdf(context, ref),
            ),
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: const Text('Importar dados'),
              subtitle: const Text('Importa transações de um arquivo CSV'),
              onTap: () => _importData(context, ref),
            ),
            const Divider(),
            const _SectionLabel('Sobre'),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre o Vida Financeira'),
              onTap: () => _showAbout(context),
            ),
          ],
        ),
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Padrão do sistema';
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Escuro';
    }
  }

  Future<void> _showThemeDialog(
      BuildContext context, WidgetRef ref, ThemeMode current) async {
    final selected = await showDialog<ThemeMode>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Tema'),
        children: [
          RadioGroup<ThemeMode>(
            groupValue: current,
            onChanged: (value) => Navigator.of(context).pop(value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ThemeMode.values.map((mode) {
                return RadioListTile<ThemeMode>(
                  title: Text(_themeModeLabel(mode)),
                  value: mode,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );

    if (selected != null) {
      await ref.read(themeModeProvider.notifier).setThemeMode(selected);
    }
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    try {
      final transactions = await ref.read(transactionsProvider.future);
      final categories = await ref.read(categoriesProvider.future);
      final categoryMap = {for (final c in categories) c.id: c};

      if (transactions.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Nenhuma transação para exportar ainda.')),
          );
        }
        return;
      }

      final csv = TransactionCsvExporter.build(transactions, categoryMap);
      final bytes = utf8.encode(csv);

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(bytes, name: 'transacoes.csv', mimeType: 'text/csv')
          ],
          subject: 'Transações — Vida Financeira',
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível exportar: $e')),
        );
      }
    }
  }

  Future<void> _exportPdf(BuildContext context, WidgetRef ref) async {
    try {
      final transactions = await ref.read(transactionsProvider.future);
      final categories = await ref.read(categoriesProvider.future);
      final categoryMap = {for (final c in categories) c.id: c};

      if (transactions.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Nenhuma transação para exportar ainda.')),
          );
        }
        return;
      }

      final bytes = await TransactionPdfExporter.build(transactions, categoryMap);

      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(bytes,
                name: 'transacoes.pdf', mimeType: 'application/pdf')
          ],
          subject: 'Transações — Vida Financeira',
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível exportar: $e')),
        );
      }
    }
  }

  Future<void> _importData(BuildContext context, WidgetRef ref) async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (files.isEmpty) return;

      final bytes = await files.first.readAsBytes();
      final content = utf8.decode(bytes);
      final categories = await ref.read(categoriesProvider.future);
      final parsed = TransactionCsvImporter.parse(content, categories);

      if (context.mounted) {
        context.push('/settings/import-preview', extra: parsed);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível importar: $e')),
        );
      }
    }
  }

  Future<void> _setupPinFlow(BuildContext context, WidgetRef ref) async {
    final pinController = TextEditingController();
    final confirmController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Definir PIN'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: pinController,
                decoration: const InputDecoration(labelText: 'PIN (4 a 6 dígitos)'),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value == null || !RegExp(r'^\d{4,6}$').hasMatch(value)) {
                    return 'Informe de 4 a 6 dígitos.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: confirmController,
                decoration: const InputDecoration(labelText: 'Confirme o PIN'),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value != pinController.text) {
                    return 'Os PINs não coincidem.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(appLockProvider.notifier).setupPin(pinController.text);
    }
    pinController.dispose();
    confirmController.dispose();
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Disponível em uma fase futura do projeto.')),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Vida Financeira',
      applicationVersion: 'v0.1 — Protótipo',
      applicationLegalese: 'Projeto de aprendizado de Flutter e Dart.',
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
