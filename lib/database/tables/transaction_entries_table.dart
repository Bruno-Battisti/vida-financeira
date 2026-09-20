import 'package:drift/drift.dart';

import 'categories_table.dart';

@DataClassName('TransactionRow')
class TransactionEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text()();
  RealColumn get amount => real()();
  TextColumn get type => text()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
}
