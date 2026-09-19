import 'package:flutter/material.dart';

import 'routes.dart';
import 'theme.dart';

class VidaFinanceiraApp extends StatelessWidget {
  const VidaFinanceiraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vida Financeira',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
    );
  }
}
