import 'package:drift/drift.dart';

import 'goals_table.dart';

@DataClassName('GoalEntryRow')
class GoalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get goalId => integer().references(Goals, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
}
