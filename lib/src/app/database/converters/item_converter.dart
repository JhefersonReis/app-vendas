import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:organik_vendas/src/features/sales/domain/item_model.dart';

class ItemModelConverter extends TypeConverter<List<ItemModel>, String> {
  const ItemModelConverter();

  @override
  List<ItemModel> fromSql(String fromDb) {
    return (jsonDecode(fromDb) as List)
        .map((e) => ItemModel.fromJson(e))
        .toList();
  }

  @override
  String toSql(List<ItemModel> value) {
    return jsonEncode(value.map((e) => e.toJson()).toList());
  }
}
