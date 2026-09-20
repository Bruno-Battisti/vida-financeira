import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/app/app.dart';
import 'package:vida_financeira/features/transactions/models/category.dart';

void main() {
  testWidgets('Formulário de nova transação não salva com campos vazios', (WidgetTester tester) async {
    await tester.pumpWidget(const VidaFinanceiraApp());

    await tester.tap(find.text('Transações').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Nova transação'), findsOneWidget);

    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Informe uma descrição.'), findsOneWidget);
    expect(find.text('Informe o valor.'), findsOneWidget);
    expect(find.text('Selecione uma categoria.'), findsOneWidget);
    expect(find.text('Nova transação'), findsOneWidget);
  });

  testWidgets('Preencher o formulário corretamente cria a transação e volta para a lista', (WidgetTester tester) async {
    await tester.pumpWidget(const VidaFinanceiraApp());

    await tester.tap(find.text('Transações').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Descrição'), 'Pizza da sexta');
    await tester.enterText(find.widgetWithText(TextFormField, 'Valor'), '55,90');

    await tester.tap(find.byType(DropdownButtonFormField<Category>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alimentação').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Salvar'));
    await tester.pumpAndSettle();

    expect(find.text('Nova transação'), findsNothing);
    expect(find.text('Transação criada com sucesso!'), findsOneWidget);
    expect(find.text('Pizza da sexta'), findsOneWidget);
  });
}
