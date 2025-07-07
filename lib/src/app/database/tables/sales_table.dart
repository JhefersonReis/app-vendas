import 'package:drift/drift.dart';
import 'package:organik_vendas/src/app/database/converters/item_converter.dart';
import 'package:organik_vendas/src/app/database/tables/customers_table.dart';

class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId => integer().references(Customers, #id, onDelete: KeyAction.cascade)();
  TextColumn get customerName => text()();
  DateTimeColumn get saleDate => dateTime()();
  TextColumn get items => text().map(const ItemModelConverter())();
  RealColumn get total => real()();
  BoolColumn get isPaid => boolean()();
  TextColumn get observation => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
