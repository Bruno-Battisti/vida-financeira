import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';
import 'theme.dart';
import 'theme_mode_provider.dart';

class VidaFinanceiraApp extends ConsumerStatefulWidget {
  const VidaFinanceiraApp({super.key});

  @override
  ConsumerState<VidaFinanceiraApp> createState() => _VidaFinanceiraAppState();
}

class _VidaFinanceiraAppState extends ConsumerState<VidaFinanceiraApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(ref);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Vida Financeira',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}
