import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/currency.dart';
import 'package:sqflite/sqflite.dart';

class CurrencyDao extends BaseDao<CurrencyModel> {
  CurrencyDao(Database db)
      : super(
            db: db,
            tableName: tableCurrencies,
            modelFields: CurrencyFields.values);

  @override
  Future<CurrencyModel?> readByDocId(String docId) async {
    final res = await db.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? CurrencyModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<CurrencyModel>> readAll() async {
    final result = await db.query(tableName);

    return result.map((itemData) => CurrencyModel.fromMap(itemData)).toList();
  }

  // Future<CurrencyModel> create(CurrencyModel currencyModel) async {
  //   final res = await db.insert(tableName, currencyModel.toMap());
  //   return currencyModel;
  // }

  // Future<void> bulkCreate(List<CurrencyModel> data) async {
  //   await DaoHelper.bulkCreate(db, tableName, data);
  // }

  // Future<CurrencyModel> readByDocId(String docId) async {
  //   final maps = await db.query(
  //     tableName,
  //     columns: CurrencyFields.values,
  //     where: '${CurrencyFields.docId} = ?',
  //     whereArgs: [docId],
  //   );

  //   if (maps.isNotEmpty) {
  //     return CurrencyModel.fromMap(maps.first);
  //   } else {
  //     throw Exception("ID $docId is not found");
  //   }
  // }

  // Future<List<CurrencyModel>> readAll() async {
  //   final result = await db.query(tableName);

  //   return result.map((itemData) => CurrencyModel.fromMap(itemData)).toList();
  // }
}
