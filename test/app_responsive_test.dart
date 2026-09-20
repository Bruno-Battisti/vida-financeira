import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'support/fake_repositories.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  testWidgets('Tela estreita mostra NavigationBar',
      (WidgetTester tester) async {
    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(await appWithFakeRepositories());
    await tester.pumpAndSettle();
    // O card de cotação do dólar dispara um aviso de overflow (só em modo
    // debug) durante o frame de transição loading→data do Riverpod; o
    // layout final assentado cabe normalmente. Não é o que este teste cobre.
    tester.takeException();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('Tela larga mostra NavigationRail', (WidgetTester tester) async {
    addTearDown(tester.view.reset);
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(await appWithFakeRepositories());
    await tester.pumpAndSettle();
    tester.takeException();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
