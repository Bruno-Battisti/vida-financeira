import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';
import 'theme.dart';

class VidaFinanceiraApp extends StatefulWidget {
  const VidaFinanceiraApp({super.key});

  @override
  State<VidaFinanceiraApp> createState() => _VidaFinanceiraAppState();
}

class _VidaFinanceiraAppState extends State<VidaFinanceiraApp> {
  late final GoRouter _router = createRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vida Financeira',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: _router,
    );
  }
}
