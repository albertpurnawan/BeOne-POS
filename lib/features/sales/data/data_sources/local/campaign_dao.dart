import 'package:pos_fe/core/resources/base_dao.dart';
import 'package:pos_fe/features/sales/data/models/campaign.dart';
import 'package:sqflite/sqflite.dart';

class CampaignDao extends BaseDao<CampaignModel> {
  String statusActive = "AND statusactive = 1";
  CampaignDao(Database db)
      : super(
            db: db,
            tableName: tableCampaign,
            modelFields: CampaignFields.values);

  @override
  Future<CampaignModel?> readByDocId(String docId, Transaction? txn) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final res = await dbExecutor.query(
      tableName,
      columns: modelFields,
      where: 'docid = ?',
      whereArgs: [docId],
    );

    return res.isNotEmpty ? CampaignModel.fromMap(res[0]) : null;
  }

  @override
  Future<List<CampaignModel>> readAll({Transaction? txn}) async {
    DatabaseExecutor dbExecutor = txn ?? db;
    final result = await dbExecutor.query(tableName);

    return result.map((itemData) => CampaignModel.fromMap(itemData)).toList();
  }

  Future<List<CampaignModel>> readAllWithSearch(
      {String? searchKeyword, Transaction? txn}) async {
    final result = await db.query(tableName,
        where:
            "(${CampaignFields.description} LIKE ? OR ${CampaignFields.campaignCode} LIKE ?)",
        whereArgs: ["%$searchKeyword%", "%$searchKeyword%"]);

    return result.map((itemData) => CampaignModel.fromMap(itemData)).toList();
  }
}
