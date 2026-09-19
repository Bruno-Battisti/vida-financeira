import 'package:flutter/material.dart';

import 'main_shell.dart';
import 'theme.dart';

class VidaFinanceiraApp extends StatelessWidget {
  const VidaFinanceiraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vida Financeira',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const MainShell(),
    );
  }
}
