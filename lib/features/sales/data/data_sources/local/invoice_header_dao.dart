import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceHeaderDao extends BaseDao<InvoiceHeaderModel> {
  InvoiceHeaderDao(Database db)
      : super(
          db: db,
          tableName: tableInvoiceHeader,
          modelFields: InvoiceHeaderFields.values,
        );

  @override
  Future<InvoiceHeaderModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? InvoiceHeaderModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<InvoiceHeaderModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => InvoiceHeaderModel.fromMap(itemData)).toList();
  }

  @override
  Future<InvoiceHeaderModel?> create({required InvoiceHeaderModel data, Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.insert(tableName, data.toMap());
    final List<Map<String, Object?>> createdData =
        await dbExecutor.query(tableName, where: "rowid = ?", whereArgs: [res]);

    if (createdData.isNotEmpty) {
      return InvoiceHeaderModel.fromMap(createdData.first);
    } else {
      return null;
    }
  }

  Future<List<InvoiceHeaderModel>> readByLastDate() async {
    final res = await db.query(
      tableName,
      orderBy: 'createdat DESC',
      limit: 1,
    );

    return res.map((itemData) => InvoiceHeaderModel.fromMap(itemData)).toList();
  }

  Future<List<InvoiceHeaderModel>> readByShift(String tcsr1Id) async {
    final res = await db.query(
      tableName,
      where: 'tcsr1Id = ?',
      whereArgs: [tcsr1Id],
    );

    if (res.isEmpty) {
      return [];
    }

    final List<InvoiceHeaderModel> invoices = res.map((e) => InvoiceHeaderModel.fromMap(e)).toList();

    return invoices;
  }

  Future<List<InvoiceHeaderModel>> readByShiftAndDatetime(DateTime datetime) async {
    final stringDatetime = DateFormat("yyyy-MM-dd HH:mm:ss").format(datetime.toUtc());
    // log(stringDatetime);
    final prefs = GetIt.instance<SharedPreferences>();
    final tcsr1Id = prefs.getString('tcsr1Id');
    final res = await db.query(
      tableName,
      where: 'tcsr1Id LIKE ? AND createdAt = ?',
      whereArgs: ['$tcsr1Id%', stringDatetime],
    );

    if (res.isEmpty) {
      return [];
    }

    final List<InvoiceHeaderModel> invoices = res.map((e) => InvoiceHeaderModel.fromMap(e)).toList();

    return invoices;
  }

  Future<List<InvoiceHeaderModel>?> readBetweenDate(DateTime start, DateTime end) async {
    final startDate = start.toUtc().toIso8601String();
    final endDate = end.toUtc().toIso8601String();

    final result = await db.query(
      tableName,
      where: 'createdat BETWEEN ? AND ?',
      whereArgs: [
        startDate,
        endDate,
      ],
    );

    final transactions = result.map((map) => InvoiceHeaderModel.fromMap(map)).toList();

    return transactions;
  }

  Future<List<dynamic>?> readByItemBetweenDate(DateTime start, DateTime end) async {
    final startDate = start.toUtc().toIso8601String();
    final endDate = end.toUtc().toIso8601String();

    final result = await db.rawQuery('''
      SELECT d.toitmId, i.itemname, SUM(d.quantity) AS totalquantity, SUM(d.totalamount) AS totalamount
      FROM $tableName AS d
      INNER JOIN toitm AS i ON d.toitmId = i.docid
      WHERE d.createdat BETWEEN ? AND ?
      GROUP BY d.toitmId
      ''', [startDate, endDate]);

    return result;
  }

  Future<List<dynamic>?> readByUserBetweenDate(DateTime start, DateTime end) async {
    final startDate = start.toUtc().toIso8601String();
    final endDate = end.toUtc().toIso8601String();

    final result = await db.rawQuery('''
      SELECT x1.docnum, x0.transdate, x0.transtime, x2.username, x0.grandtotal, x0.docnum as invdocnum, x0.timezone
      FROM $tableName AS x0
      INNER JOIN tcsr1 AS x1 ON  x1.docid = x0.tcsr1Id
      INNER JOIN tousr AS x2 ON x1.tousrId = x2.docid
      WHERE x0.createdat BETWEEN ? AND ?
      
      ''', [startDate, endDate]);

    return result;
  }

  Future<InvoiceHeaderModel?> readByDocNum(String docNum, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docnum = ?',
      whereArgs: [docNum],
    );

    return res.isNotEmpty ? InvoiceHeaderModel.fromMap(res[0]) : null;
  }

  Future<Map<String, List<Map<String, dynamic>>>> getTableData(String tcsr1Id, DateTime start, DateTime end) async {
    final Map<String, List<Map<String, dynamic>>> data = {};
    final rows = await db.rawQuery('''
      SELECT x0.* FROM $tableName x0
        INNER JOIN tcsr1 x1 ON x0.tcsr1Id = x1.docid
        WHERE (x0.createdat BETWEEN ? AND ?) 
        AND x0.synctobos NOT NULL
        AND x0.tcsr1Id = ?
    ''', [start.toString(), end.toString(), tcsr1Id]);
    data[tableName] = rows;

    return data;
  }

  Future<void> deleteArchived(String tcsr1Id, DateTime start, DateTime end) async {
    await db.rawDelete('''
      DELETE FROM $tableName
        WHERE (createdat BETWEEN ? AND ?)
        AND synctobos IS NOT NULL
        AND tcsr1Id = ?
    ''', [start.toString(), end.toString(), tcsr1Id]);
  }
}
