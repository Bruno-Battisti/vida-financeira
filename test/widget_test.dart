import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vida_financeira/app/app.dart';
import 'package:vida_financeira/features/goals/providers/goals_provider.dart';
import 'package:vida_financeira/features/transactions/providers/categories_provider.dart';
import 'package:vida_financeira/features/transactions/providers/transactions_provider.dart';

import 'support/fake_repositories.dart';

Widget _appWithFakeRepositories() {
  return ProviderScope(
    overrides: [
      transactionsRepositoryProvider.overrideWithValue(FakeTransactionsRepository()),
      categoriesRepositoryProvider.overrideWithValue(FakeCategoriesRepository()),
      goalsRepositoryProvider.overrideWithValue(FakeGoalsRepository()),
    ],
    child: const VidaFinanceiraApp(),
  );
}

void main() {
  testWidgets('App inicia no Dashboard e navega para Transações', (WidgetTester tester) async {
    await tester.pumpWidget(_appWithFakeRepositories());
    await tester.pumpAndSettle();

    expect(find.text('Início'), findsWidgets);
    expect(find.text('Saldo disponível'), findsOneWidget);

    await tester.tap(find.text('Transações'));
    await tester.pumpAndSettle();

    expect(find.text('Todas'), findsOneWidget);
  });

  testWidgets('Abrir detalhes de uma transação e voltar pela rota', (WidgetTester tester) async {
    await tester.pumpWidget(_appWithFakeRepositories());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Transações').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Livro técnico'));
    await tester.pumpAndSettle();

    expect(find.text('Detalhes da transação'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.check_circle_outline));
    await tester.pumpAndSettle();

    expect(find.text('Detalhes da transação'), findsNothing);
    expect(find.text('Transação marcada como revisada.'), findsOneWidget);
  });
}
