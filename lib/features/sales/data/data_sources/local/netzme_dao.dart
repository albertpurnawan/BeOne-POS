// import 'package:pos_fe/core/resources/base_dao.dart';
// import 'package:pos_fe/features/sales/data/models/netzme_data.dart';
// import 'package:sqflite/sqflite.dart';

// class NetzmeDao extends BaseDao<NetzmeModel> {
//   NetzmeDao(Database db)
//       : super(
//           db: db,
//           tableName: tableNetzme,
//           modelFields: NetzmeFields.values,
//         );

//   @override
//   Future<NetzmeModel?> readByDocId(String docId, Transaction? txn) async {
//     DatabaseExecutor dbExecutor = txn ?? db;
//     final res = await dbExecutor.query(
//       tableName,
//       columns: modelFields,
//       where: 'docid = ?',
//       whereArgs: [docId],
//     );

//     return res.isNotEmpty ? NetzmeModel.fromMap(res[0]) : null;
//   }

//   @override
//   Future<List<NetzmeModel>> readAll({Transaction? txn}) async {
//     if (txn != null) {
//       final result = await txn.query(tableName);

//       return result.map((itemData) => NetzmeModel.fromMap(itemData)).toList();
//     } else {
//       final result = await db.query(tableName);

//       return result.map((itemData) => NetzmeModel.fromMap(itemData)).toList();
//     }
//   }
// }
