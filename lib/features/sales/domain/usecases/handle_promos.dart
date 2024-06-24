// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/usecases/handle_without_promos.dart';

class HandlePromosUseCase
    implements UseCase<List<ReceiptItemEntity>, HandlePromosUseCaseParams> {
  final HandleWithoutPromosUseCase handleWithoutPromosUseCase;

  HandlePromosUseCase(this.handleWithoutPromosUseCase);

  @override
  Future<List<ReceiptItemEntity>> call(
      {HandlePromosUseCaseParams? params}) async {
    try {
      if (params == null) throw "HandlePromosUseCase requires params";

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
