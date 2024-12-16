import 'package:get_it/get_it.dart';
import 'package:pos_fe/core/database/app_database.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class HandlePromoSpesialMultiItemUseCase implements UseCase<ReceiptEntity, HandlePromosUseCaseParams> {
  HandlePromoSpesialMultiItemUseCase();

  @override
  Future<ReceiptEntity> call({HandlePromosUseCaseParams? params}) async {
    try {
      if (params == null) {
        throw "HandlePromoSpesialMultiItemUseCase requires params";
      }

      if (params.promo == null) {
        throw "Promotion entity required";
      }

      if (params.receiptItemEntity == null) throw "Receipt item entity required";

      List<ReceiptItemEntity> newReceiptItems = [];
      List<PromotionsEntity> promotionsApplied = [];
      bool isNewReceiptItem = true;
      final promo = params.promo!;
      final itemEntity = params.receiptItemEntity!.itemEntity;
      final quantity = params.receiptItemEntity!.quantity;

      final topsm =
          await GetIt.instance<AppDatabase>().promoSpesialMultiItemHeaderDao.readByDocId(promo.promoId!, null);
      final tpsm1 =
          await GetIt.instance<AppDatabase>().promoSpesialMultiItemDetailDao.readByTopsmId(promo.promoId!, null);
      final tpsm1s =
          await GetIt.instance<AppDatabase>().promoSpesialMultiItemDetailDao.readAllByTopsmId(promo.promoId!, null);

      return params.receiptEntity.copyWith();
    } catch (e) {
      rethrow;
    }
  }
}
