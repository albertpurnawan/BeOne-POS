import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class HandleWithoutPromosUseCase implements UseCase<ReceiptEntity, HandlePromosUseCaseParams> {
  HandleWithoutPromosUseCase();

  @override
  Future<ReceiptEntity> call({HandlePromosUseCaseParams? params}) async {
    try {
      if (params == null) throw "HandleWithoutPromosUseCase requires params";
      if (params.receiptItemEntity == null) throw "Receipt item entity required";

      var SplitListResult(falseResult: otherItems, trueResult: existingItem) = ReceiptHelper.splitReceiptItemEntities(
          params.receiptEntity.receiptItems, params.receiptItemEntity!.itemEntity.barcode);

      if (existingItem.isNotEmpty) {
        if (params.receiptItemEntity!.itemEntity.barcode == "99" &&
            (params.receiptItemEntity!.quantity + existingItem[0].quantity < -1 ||
                params.receiptItemEntity!.quantity + existingItem[0].quantity > 1)) {
          throw "Down payment quantity must be -1 or 1";
        }
        existingItem[0] = ReceiptHelper.updateReceiptItemAggregateFields(
            existingItem[0]..quantity += params.receiptItemEntity!.quantity);
      } else {
        if (params.receiptItemEntity!.itemEntity.barcode == "99" &&
            (params.receiptItemEntity!.quantity < -1 || params.receiptItemEntity!.quantity > 1)) {
          throw "Down payment quantity must be -1 or 1";
        }
        existingItem.add(ReceiptHelper.updateReceiptItemAggregateFields(params.receiptItemEntity!));
      }

      return params.receiptEntity.copyWith(receiptItems: [...otherItems, ...existingItem]);
    } catch (e) {
      rethrow;
    }
  }
}
