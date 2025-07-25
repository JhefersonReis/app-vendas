import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:zello/src/app/database/converters/item_converter.dart';
import 'package:zello/src/features/sales/domain/item_model.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/customers_table.dart';
import 'tables/products_table.dart';
import 'tables/installments_table.dart';
import 'tables/sales_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Customers, Products, Sales, Installments])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationSupportDirectory();
      final file = File('${dbFolder.path}/app_database.sqlite');
      return NativeDatabase(file, setup: (db) => db.execute('PRAGMA foreign_keys = ON'));
    });
  }
}
