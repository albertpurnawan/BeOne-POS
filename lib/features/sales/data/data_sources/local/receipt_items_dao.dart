import 'package:pos_fe/features/sales/data/models/receipt_item.dart';
import 'package:sqflite/sqflite.dart';

class ReceiptItemsDao {
  final Database db;

  ReceiptItemsDao(this.db);

  Future<ReceiptItemModel?> readReceiptItem(int id) async {
    final maps = await db.query(
      tableReceiptItems,
      columns: ReceiptItemFields.values,
      where: '{$ReceiptItemFields} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ReceiptItemModel.fromMap(maps.first);
    } else {
      throw Exception("ID $id is not found");
    }
  }
}
