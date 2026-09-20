import 'package:intl/intl.dart';

final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
final _dateFormat = DateFormat('dd/MM/yyyy', 'pt_BR');

String formatCurrency(double value) => _currencyFormat.format(value);

String formatDate(DateTime date) => _dateFormat.format(date);
