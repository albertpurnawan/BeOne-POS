import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/helpers.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_promos.dart';

class HandleWithoutPromosUseCase
    implements UseCase<ReceiptEntity, HandlePromosUseCaseParams> {
  HandleWithoutPromosUseCase();

  @override
  Future<ReceiptEntity> call({HandlePromosUseCaseParams? params}) async {
    // TODO: implement call
    try {
      if (params == null) throw "HandleWithoutPromosUseCase requires params";

      var SplitListResult(falseResult: otherItems, trueResult: existingItem) =
          ReceiptHelper.splitReceiptItemEntities(
              params.receiptEntity.receiptItems,
              params.receiptItemEntity.itemEntity.barcode);

      if (existingItem.isNotEmpty) {
        existingItem[0] = ReceiptHelper.updateReceiptItemAggregateFields(
            existingItem[0]..quantity += params.receiptItemEntity.quantity);
      } else {
        existingItem.add(ReceiptHelper.updateReceiptItemAggregateFields(
            params.receiptItemEntity));
      }

      return params.receiptEntity
          .copyWith(receiptItems: [...otherItems, ...existingItem]);
    } catch (e) {
      rethrow;
    }
  }
}
