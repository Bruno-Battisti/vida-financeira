import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../support/fake_repositories.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  testWidgets('Criar meta, adicionar aporte e ver o progresso atualizado', (WidgetTester tester) async {
    await tester.pumpWidget(await appWithFakeRepositories());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Metas'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Nova meta'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Nome da meta'), 'Curso de Flutter');
    await tester.enterText(find.widgetWithText(TextFormField, 'Valor objetivo'), '1000');

    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Nova meta'), findsNothing);
    expect(find.text('Curso de Flutter'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);

    await tester.tap(find.text('Curso de Flutter'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Adicionar aporte'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Valor'), '250');
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();

    expect(find.text('25%'), findsOneWidget);
    expect(find.text('Aporte'), findsOneWidget);
  });
}
