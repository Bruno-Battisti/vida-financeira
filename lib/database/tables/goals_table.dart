import 'package:drift/drift.dart';

@DataClassName('GoalRow')
class Goals extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get targetAmount => real()();
  DateTimeColumn get deadline => dateTime().nullable()();
}
