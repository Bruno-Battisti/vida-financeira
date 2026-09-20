import 'package:flutter/material.dart';

/// Larguras de referência do Material 3 para decidir quando o layout
/// deixa de ser "telefone" e passa a ter espaço de tablet/desktop/web.
class Breakpoints {
  Breakpoints._();

  static const compact = 600.0;
}

bool isWideScreen(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= Breakpoints.compact;

/// Centraliza e limita a largura do conteúdo em telas grandes, para listas
/// e formulários não ficarem esticados borda a borda em tablet/desktop/web.
/// Em telas pequenas se comporta como o [child] normalmente se comportaria.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({super.key, required this.child, this.maxWidth = 700});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
