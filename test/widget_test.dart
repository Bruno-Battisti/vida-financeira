import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/app/app.dart';

void main() {
  testWidgets('App inicia no Dashboard e navega para Transações', (WidgetTester tester) async {
    await tester.pumpWidget(const VidaFinanceiraApp());

    expect(find.text('Início'), findsWidgets);
    expect(find.text('Saldo disponível'), findsOneWidget);

    await tester.tap(find.text('Transações'));
    await tester.pumpAndSettle();

    expect(find.text('Todas'), findsOneWidget);
  });
}
