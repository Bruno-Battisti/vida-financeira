import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../support/fake_repositories.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  testWidgets('Relatórios mostra o gráfico de pizza e o de evolução mensal', (WidgetTester tester) async {
    await tester.pumpWidget(await appWithFakeRepositories());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Relatórios'));
    await tester.pumpAndSettle();

    expect(find.text('Distribuição de despesas'), findsOneWidget);
    expect(find.byType(PieChart), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.text('Evolução mensal (últimos 6 meses)'), findsOneWidget);
    expect(find.byType(BarChart), findsOneWidget);
  });
}
