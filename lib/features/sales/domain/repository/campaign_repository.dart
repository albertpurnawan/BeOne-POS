import 'package:pos_fe/features/sales/domain/entities/campaign.dart';

abstract class CampaignRepository {
  Future<CampaignEntity?> getCampaign(String docId);

  Future<List<CampaignEntity>> getCampaigns({String? searchKeyword});
}
