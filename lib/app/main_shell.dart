import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/responsive_center.dart';
import '../features/accounts/providers/accounts_provider.dart';
import '../features/household/providers/household_provider.dart';
import '../features/notifications/providers/notifications_provider.dart';
import '../features/recurring/providers/recurring_rules_provider.dart';

class _NavItem {
  const _NavItem(
      {required this.icon, required this.selectedIcon, required this.label});

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _items = [
    _NavItem(
        icon: Icons.home_outlined, selectedIcon: Icons.home, label: 'Início'),
    _NavItem(
        icon: Icons.swap_horiz_outlined,
        selectedIcon: Icons.swap_horiz,
        label: 'Transações'),
    _NavItem(
        icon: Icons.flag_outlined, selectedIcon: Icons.flag, label: 'Metas'),
    _NavItem(
        icon: Icons.bar_chart_outlined,
        selectedIcon: Icons.bar_chart,
        label: 'Relatórios'),
  ];

  void _onDestinationSelected(int index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dispara, uma única vez por sessão, a geração de transações de
    // recorrências já vencidas (ver recurringGenerationProvider).
    // Garante que o usuário tenha um household (solo, por padrão) antes de
    // qualquer repositório tentar resolver o uid efetivo dos dados.
    ref.watch(ensureHouseholdProvider);
    ref.watch(recurringGenerationProvider);
    // Mantém os lembretes de vencimento/metas em dia conforme os dados mudam.
    ref.watch(reminderSchedulingProvider);
    // Garante que a conta "Principal" exista antes de qualquer tela abrir.
    ref.watch(ensureDefaultAccountProvider);
    final wide = isWideScreen(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_items[navigationShell.currentIndex].label),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Configurações',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: wide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: _onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  destinations: _items
                      .map((item) => NavigationRailDestination(
                            icon: Icon(item.icon),
                            selectedIcon: Icon(item.selectedIcon),
                            label: Text(item.label),
                          ))
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: ResponsiveCenter(child: navigationShell)),
              ],
            )
          : navigationShell,
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _onDestinationSelected,
              destinations: _items
                  .map((item) => NavigationDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.selectedIcon),
                        label: item.label,
                      ))
                  .toList(),
            ),
    );
  }
}
