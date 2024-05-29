import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';

class ApplyRoundingUseCase implements UseCase<ReceiptEntity, ReceiptEntity> {
  ApplyRoundingUseCase();

  @override
  Future<ReceiptEntity> call({ReceiptEntity? params}) {
    try {
      throw "";
    } catch (e) {
      rethrow;
    }
  }
}
