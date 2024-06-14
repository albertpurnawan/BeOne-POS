// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class HandlePromoDiscItemByItemUseCase
    implements UseCase<ReceiptEntity, HandlePromosUseCaseParams> {
  HandlePromoDiscItemByItemUseCase();

  @override
  Future<ReceiptEntity> call({HandlePromosUseCaseParams? params}) async {
    try {
      if (params == null) {
        throw "HandlePromoDiscItemByItemUseCase requires params";
      }

      // Check applicability

      // Handle calculations

      throw "";
    } catch (e) {
      rethrow;
    }
  }
}
