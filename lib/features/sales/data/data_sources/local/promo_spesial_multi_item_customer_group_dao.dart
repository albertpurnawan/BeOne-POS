import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/promo_spesial_multi_item_customer_group.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PromoSpesialMultiItemCustomerGroupDao extends BaseDao<PromoSpesialMultiItemCustomerGroupModel> {
  PromoSpesialMultiItemCustomerGroupDao(Database db)
      : super(
            db: db,
            tableName: tablePromoSpesialMultiItemCustomerGroup,
            modelFields: PromoSpesialMultiItemCustomerGroupFields.values);

  @override
  Future<PromoSpesialMultiItemCustomerGroupModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? PromoSpesialMultiItemCustomerGroupModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<PromoSpesialMultiItemCustomerGroupModel>> readAll({Transaction? txn}) async {
    if (txn != null) {
      final result = await txn.query(tableName);

      return result.map((itemData) => PromoSpesialMultiItemCustomerGroupModel.fromMap(itemData)).toList();
    } else {
      final result = await db.query(tableName);

      return result.map((itemData) => PromoSpesialMultiItemCustomerGroupModel.fromMap(itemData)).toList();
    }
  }

  Future<List<PromoSpesialMultiItemCustomerGroupModel>> readByTopsmId(String topsmId, Transaction? txn) async {
    if (txn != null) {
      final result = await txn.query(
        tableName,
        columns: modelFields,
        where: 'topsmId = ?',
        whereArgs: [topsmId],
      );
      return result.map((itemData) => PromoSpesialMultiItemCustomerGroupModel.fromMap(itemData)).toList();
    } else {
      final result = await db.query(
        tableName,
        columns: modelFields,
        where: 'topsmId = ?',
        whereArgs: [topsmId],
      );
      return result.map((itemData) => PromoSpesialMultiItemCustomerGroupModel.fromMap(itemData)).toList();
    }
  }
}
