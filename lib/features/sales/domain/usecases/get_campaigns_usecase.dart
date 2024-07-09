import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/campaign.dart';
import 'package:pos_fe/features/sales/domain/repository/campaign_repository.dart';

class GetCampaignUseCase implements UseCase<List<CampaignEntity>, String?> {
  final CampaignRepository _campaignRepository;
  GetCampaignUseCase(this._campaignRepository);

  @override
  Future<List<CampaignEntity>> call({String? params}) {
    return _campaignRepository.getCampaigns(searchKeyword: params);
  }
}
