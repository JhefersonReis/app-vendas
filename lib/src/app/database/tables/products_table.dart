import 'package:drift/drift.dart';

class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  RealColumn get weight => real()();
  TextColumn get weightUnit => text()();
  TextColumn get description => text()();
  DateTimeColumn get createdAt => dateTime()();
}
