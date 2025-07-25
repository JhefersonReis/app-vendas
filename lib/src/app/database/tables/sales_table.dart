import 'package:drift/drift.dart';
import 'package:zello/src/app/database/converters/item_converter.dart';
import 'package:zello/src/app/database/tables/customers_table.dart';

class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId => integer().references(Customers, #id, onDelete: KeyAction.cascade)();
  TextColumn get customerName => text()();
  DateTimeColumn get saleDate => dateTime()();
  TextColumn get items => text().map(const ItemModelConverter())();
  RealColumn get total => real()();
  BoolColumn get isPaid => boolean()();
  BoolColumn get isInstallment => boolean().withDefault(const Constant(false))();
  IntColumn get installments => integer().withDefault(const Constant(0))();
  TextColumn get observation => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
