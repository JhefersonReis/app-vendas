import 'package:drift/drift.dart';
import 'package:zello/src/app/database/tables/sales_table.dart';

class Installments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(Sales, #id, onDelete: KeyAction.cascade)();
  IntColumn get installmentNumber => integer()();
  RealColumn get value => real()();
  DateTimeColumn get dueDate => dateTime()();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
}
