import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/mop_by_store.dart';
import 'package:pos_fe/features/sales/data/models/mop_selection.dart';
import 'package:sqflite/sqflite.dart';

class MOPByStoreDao extends BaseDao<MOPByStoreModel> {
  MOPByStoreDao(Database db)
      : super(
          db: db,
          tableName: tableMOPByStore,
          modelFields: MOPByStoreFields.values,
        );

  @override
  Future<MOPByStoreModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? MOPByStoreModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<MOPByStoreModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => MOPByStoreModel.fromMap(itemData)).toList();
  }

  Future<List<MopSelectionModel>> readAllIncludeRelations({String? payTypeCode}) async {
    final result = await db.rawQuery("""
      SELECT p3.docid as tpmt3Id, p3.tpmt1Id, p1.mopalias, p1.bankcharge, p.paytypecode, p.description, p1.subtype,
      CASE WHEN p.paytypecode = 2 OR 3 THEN p4.tpmt4Id ELSE NULL END as tpmt4Id, 
      CASE WHEN p.paytypecode = 2 OR 3 THEN p4.edcDesc ELSE NULL END as edcdesc
      FROM tpmt3 as p3
        INNER JOIN (
        SELECT mopalias, bankcharge, docid, topmtId, subtype, tpmt4Id FROM tpmt1
        ) as p1 ON p3.tpmt1Id = p1.docid
        INNER JOIN (
        SELECT paytypecode, description, docid FROM topmt
        ${payTypeCode == null ? "" : "WHERE paytypecode = '$payTypeCode'"}
        ) as p ON p1.topmtId = p.docid
        LEFT JOIN (
          SELECT docid as tpmt4Id, description as edcDesc 
          FROM tpmt4
        ) as p4 ON p1.tpmt4Id = p4.tpmt4Id;
    """);

    return result.map((itemData) => MopSelectionModel.fromMap(itemData)).toList();
  }

  Future<MopSelectionModel?> readByDocIdIncludeRelations(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.rawQuery("""
SELECT p3.docid as tpmt3Id, p3.tpmt1Id, p1.mopalias, p1.bankcharge, p.paytypecode, p.description, p1.subtype FROM tpmt3 as p3
INNER JOIN (
SELECT mopalias, bankcharge, docid, topmtId, subtype FROM tpmt1
) as p1 ON p3.tpmt1Id = p1.docid
INNER JOIN (
SELECT paytypecode, description, docid FROM topmt
) as p ON p1.topmtId = p.docid
WHERE p3.docid = '$docId';
""");

    return result.isNotEmpty ? MopSelectionModel.fromMap(result[0]) : null;
  }

  Future<MOPByStoreModel?> readByTpmt1Id(String tpmt1Id, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'tpmt1Id = ?',
      whereArgs: [tpmt1Id],
    );

    return res.isNotEmpty ? MOPByStoreModel.fromMap(res[0]) : null;
  }
}
