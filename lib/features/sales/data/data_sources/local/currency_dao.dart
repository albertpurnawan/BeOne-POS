import 'package:pos_fe/core/resources/data_sources_enum.dart';
import 'package:pos_fe/features/sales/data/models/currency.dart';
import 'package:pos_fe/features/sales/data/models/item.dart';
import 'package:sqflite/sqflite.dart';

class CurrencyDao {
  final Database db;

  CurrencyDao(this.db);

  // Future<CurrencyModel> createItem(CurrencyModel itemModel) async {
  //   final id = await db.insert(tableCurrencies, itemModel.toMap());

  //   return CurrencyModel.fromEntity(itemModel.copyWith(id: id));
  // }

  Future<CurrencyModel> readCurrency(int id) async {
    final maps = await db.query(
      tableCurrencies,
      columns: CurrencyFields.values,
      where: '${CurrencyFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CurrencyModel.fromMapByDataSource(DataSource.local, maps.first);
    } else {
      throw Exception("ID $id is not found");
    }
  }

  Future<List<CurrencyModel>> readCurrencies() async {
    final result = await db.query(tableCurrencies);

    return result
        .map((itemData) =>
            CurrencyModel.fromMapByDataSource(DataSource.local, itemData))
        .toList();
  }
}
