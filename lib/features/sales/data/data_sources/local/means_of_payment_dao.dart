import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/means_of_payment.dart';
import 'package:pos_fe/features/sales/data/models/mop_selection.dart';
import 'package:sqflite/sqflite.dart';

class MeansOfPaymentDao extends BaseDao<MeansOfPaymentModel> {
  MeansOfPaymentDao(Database db)
      : super(
          db: db,
          tableName: tableMOP,
          modelFields: MeansOfPaymentFields.values,
        );

  @override
  Future<MeansOfPaymentModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? MeansOfPaymentModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<MeansOfPaymentModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => MeansOfPaymentModel.fromMap(itemData)).toList();
  }

  Future<MeansOfPaymentModel?> readByDescription(String description, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'description = ?',
      whereArgs: [description],
    );

    return res.isNotEmpty ? MeansOfPaymentModel.fromMap(res[0]) : null;
  }

  Future<List<MopSelectionModel>> readByPaytypeCode(String payTypeCode, String edc) async {
    final result = await db.rawQuery('''
      SELECT p3.docid AS tpmt3Id, p3.tpmt1Id, p1.mopalias, p1.bankcharge, p.paytypecode, 
              p.description, p1.subtype,p4.docid AS tpmt4Id, p4.description AS edcdesc
            FROM tpmt3 AS p3
            INNER JOIN (
                SELECT mopalias, bankcharge, docid, topmtId, subtype, tpmt4Id
                FROM tpmt1
            ) AS p1 ON p3.tpmt1Id = p1.docid
            INNER JOIN (
                SELECT paytypecode, description, docid 
                FROM topmt
                WHERE paytypecode = ? 
            ) AS p ON p1.topmtId = p.docid
            LEFT JOIN (
                SELECT docid, description 
                FROM tpmt4
            ) AS p4 ON p1.tpmt4Id = p4.docid
            WHERE p4.docid = ?
    ''', [payTypeCode, edc]);

    return result.map((e) => MopSelectionModel.fromMap(e)).toList();
  }
}
