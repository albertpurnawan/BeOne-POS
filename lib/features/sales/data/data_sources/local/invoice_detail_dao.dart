import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/invoice_detail.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceDetailDao extends BaseDao<InvoiceDetailModel> {
  InvoiceDetailDao(Database db)
      : super(
          db: db,
          tableName: tableInvoiceDetail,
          modelFields: InvoiceDetailFields.values,
        );

  @override
  Future<InvoiceDetailModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? InvoiceDetailModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<InvoiceDetailModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => InvoiceDetailModel.fromMap(itemData)).toList();
  }

  Future<List<InvoiceDetailModel>> readByToinvId(String toinvId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(
      tableName,
      where: 'toinvId = ?',
      whereArgs: [toinvId],
    );

    return result.map((itemData) => InvoiceDetailModel.fromMap(itemData)).toList();
  }

  Future<List<dynamic>?> readByItemBetweenDate(DateTime start, DateTime end) async {
    final startDate = start.toUtc().toIso8601String();
    final endDate = end.toUtc().toIso8601String();

    final result = await db.rawQuery('''
    SELECT x0.toitmId, x1.itemname, x1.itemcode, x0.taxprctg, x0.discamount, x1.shortname, x0.sellingprice,
      SUM(x0.quantity) AS totalquantity, SUM(x0.totalamount) AS totalamount, 
      (SUM(x0.totalamount) * x0.taxprctg / 100) AS taxamount, SUM(x2.discheadermanual) AS discHeader
      FROM tinv1 AS x0
      INNER JOIN toitm AS x1 ON x0.toitmId = x1.docid
      INNER JOIN toinv AS x2 ON x0.toinvId = x2.docid
      WHERE x0.createdat BETWEEN ? AND ?
      GROUP BY x0.toitmId
    ''', [startDate, endDate]);

    return result;
  }

  Future<List<dynamic>> readByToinvIdAddQtyBarcode(String toinvId) async {
    final result = await db.rawQuery('''
    SELECT x0.*, x1.quantity AS qtybarcode FROM tinv1 AS x0 
      INNER JOIN tbitm AS x1 ON x0.toitmId = x1.toitmId 
      WHERE x0.toinvId = ?
    ''', [toinvId]);

    return result;
  }

  Future<Map<String, List<Map<String, dynamic>>>> getTableData(String toinvId, DateTime start, DateTime end) async {
    final Map<String, List<Map<String, dynamic>>> data = {};
    final rows = await db.rawQuery('''
      SELECT x0.* FROM $tableName x0
        INNER JOIN toinv x1 ON x0.toinvId = x1.docid
        WHERE (x0.createdat BETWEEN ? AND ?) 
        AND x0.toinvId = ?
    ''', [start.toString(), end.toString(), toinvId]);
    data[tableName] = rows;

    return data;
  }

  Future<void> deleteArchived(String toinvId, DateTime start, DateTime end) async {
    await db.rawDelete('''
      DELETE FROM $tableName
        WHERE (createdat BETWEEN ? AND ?)
        AND toinvId = ?
    ''', [start.toString(), end.toString(), toinvId]);
  }

  Future<List<InvoiceDetailModel>?> readByRefpos2(String docNum, Transaction? txn) async {
    final res = await db.rawQuery('''
      SELECT x0.* FROM tinv1 AS x0 INNER JOIN toinv AS x1 ON x0.toinvId = x1.docid
        WHERE x1.synctobos = "" AND x0.quantity = -1 AND x1.docnum LIKE '%$docNum%'
    ''');

    List<InvoiceDetailModel> transactions = [];
    if (res.isNotEmpty) {
      transactions = res.map((map) => InvoiceDetailModel.fromMap(map)).toList();
    }
    return transactions;
  }
}
