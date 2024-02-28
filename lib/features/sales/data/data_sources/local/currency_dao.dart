import 'package:pos_fe/features/sales/data/models/currency.dart';
import 'package:sqflite/sqflite.dart';

class CurrencyDao {
  final Database db;

  CurrencyDao(this.db);

  // Future<CurrencyModel> createItem(CurrencyModel itemModel) async {
  //   final id = await db.insert(tableCurrencies, itemModel.toMap());

  //   return CurrencyModel.fromEntity(itemModel.copyWith(id: id));
  // }

  Future<CurrencyModel> readCurrency(String docId) async {
    final maps = await db.query(
      tableCurrencies,
      columns: CurrencyFields.values,
      where: '${CurrencyFields.docId} = ?',
      whereArgs: [docId],
    );

    if (maps.isNotEmpty) {
      return CurrencyModel.fromMap(maps.first);
    } else {
      throw Exception("ID $docId is not found");
    }
  }

  Future<List<CurrencyModel>> readCurrencies() async {
    final result = await db.query(tableCurrencies);

    return result
        .map((itemData) =>
            CurrencyModel.fromMap(itemData))
        .toList();
  }
}
