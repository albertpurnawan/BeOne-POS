import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/invoice_header.dart';
import 'package:pos_fe/features/sales/data/models/receipt.dart';
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
  Future<InvoiceHeaderModel?> readByDocId(
      String docId, Transaction? txn) async {
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

    return result
        .map((itemData) => InvoiceHeaderModel.fromMap(itemData))
        .toList();
  }

  @override
  Future<InvoiceHeaderModel?> create(
      {required InvoiceHeaderModel data, Transaction? txn}) async {
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

  Future<List<InvoiceHeaderModel>> readByShift() async {
    final prefs = GetIt.instance<SharedPreferences>();
    final tcsr1Id = prefs.getString('tcsr1Id');

    final res = await db.query(
      tableName,
      where: 'tcsr1Id LIKE ?',
      whereArgs: ['$tcsr1Id%'],
    );

    if (res.isEmpty) {
      return [];
    }

    final List<InvoiceHeaderModel> invoices =
        res.map((e) => InvoiceHeaderModel.fromMap(e)).toList();

    return invoices;
  }
}
