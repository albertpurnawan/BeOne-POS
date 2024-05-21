// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/check_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_without_promos.dart';
import 'package:pos_fe/features/sales/domain/usecases/recalculate_receipt_by_new_receipt_items.dart';

class HandlePromosUseCase
    implements UseCase<List<ReceiptItemEntity>, HandlePromosUseCaseParams> {
  HandleWithoutPromosUseCase _handleWithoutPromosUseCase;

  HandlePromosUseCase(this._handleWithoutPromosUseCase);

  @override
  Future<List<ReceiptItemEntity>> call(
      {HandlePromosUseCaseParams? params}) async {
    // TODO: implement call
    try {
      if (params == null) throw "HandlePromosUseCase requires params";
      // final List<PromotionsEntity?> availablePromos;
      // List<ReceiptItemEntity> newReceiptItems;
      // ReceiptItemEntity newReceiptItemEntity;

      // availablePromos = await _checkPromoUseCase(
      //     params: params.receiptItemEntity.itemEntity.toitmId);

      // if (availablePromos.isEmpty) {
      //   newReceiptItems =
      //       await _handleWithoutPromosUseCase.call(params: params);
      // } else {
      //   for (final availablePromo in availablePromos) {
      //     switch (availablePromo!.promoType) {
      //       case 103:
      //       case 202:
      //       default:
      //     }
      //   }
      // }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}

class HandlePromosUseCaseParams {
  ReceiptItemEntity receiptItemEntity;
  ReceiptEntity receiptEntity;
  PromotionsEntity? promo;

  HandlePromosUseCaseParams({
    required this.receiptItemEntity,
    required this.receiptEntity,
    this.promo,
  });
}
