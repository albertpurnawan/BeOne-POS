import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/features/sales/domain/entities/campaign.dart';
import 'package:pos_fe/features/sales/domain/repository/campaign_repository.dart';

class CampaignRepositoryImpl extends CampaignRepository {
  final AppDatabase _appDatabase;
  CampaignRepositoryImpl(this._appDatabase);

  @override
  Future<CampaignEntity?> getCampaign(String docId) {
    return _appDatabase.campaignDao.readByDocId(docId, null);
  }

  @override
  Future<List<CampaignEntity>> getCampaigns({String? searchKeyword}) {
    return _appDatabase.campaignDao
        .readAllWithSearch(searchKeyword: searchKeyword);
  }
}
