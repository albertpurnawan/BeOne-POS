// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/core/utilities/receipt_helper.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';

class HandleOpenPriceUseCase
    implements UseCase<ReceiptItemEntity, HandleOpenPriceUseCaseParams?> {
  HandleOpenPriceUseCase();

  @override
  Future<ReceiptItemEntity> call({HandleOpenPriceUseCaseParams? params}) async {
    try {
      if (params == null) throw "HandleOpenPriceUseCaseParams required";
      if (params.newPrice < 0) throw "Negative price not allowed";
      return ReceiptHelper.updateReceiptItemAggregateFields(
          params.receiptItemEntity.copyWith(
              itemEntity: params.receiptItemEntity.itemEntity.copyWith(
                  price: params.newPrice,
                  dpp: params.receiptItemEntity.itemEntity.includeTax == 1
                      ? params.newPrice *
                          (100 /
                              (100 +
                                  params.receiptItemEntity.itemEntity.taxRate))
                      : params.newPrice)));
    } catch (e) {
      rethrow;
    }
  }
}

class HandleOpenPriceUseCaseParams {
  ReceiptItemEntity receiptItemEntity;
  double newPrice;

  HandleOpenPriceUseCaseParams({
    required this.receiptItemEntity,
    required this.newPrice,
  });
}
