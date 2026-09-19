import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        children: [
          const _SectionLabel('Aparência'),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Tema claro e escuro'),
            subtitle: const Text('Disponível na Fase 9'),
            onTap: () => _showComingSoon(context),
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
            subtitle: const Text('Disponível na Fase 12'),
            onTap: () => _showComingSoon(context),
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Importar dados'),
            subtitle: const Text('Disponível na Fase 12'),
            onTap: () => _showComingSoon(context),
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
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Disponível em uma fase futura do projeto.')),
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
