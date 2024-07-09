import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_fe/features/sales/domain/entities/campaign.dart';
import 'package:pos_fe/features/sales/domain/usecases/get_campaigns_usecase.dart';

part 'campaign_state.dart';

class CampaignCubit extends Cubit<List<CampaignEntity>> {
  final GetCampaignUseCase _getCampaignUseCase;

  CampaignCubit(this._getCampaignUseCase) : super([]);

  void getCampaigns({required String searchKeyword}) async {
    final List<CampaignEntity> newState =
        await _getCampaignUseCase.call(params: searchKeyword);
    emit(newState);
  }

  void clearCampaigns() async {
    emit([]);
  }
}
