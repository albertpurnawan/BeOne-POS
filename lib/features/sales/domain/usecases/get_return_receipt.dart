import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/return_receipt.dart';
import 'package:pos_fe/features/sales/domain/repository/return_receipt_repository.dart';

class GetReturnReceiptUseCase implements UseCase<ReturnReceiptEntity, String> {
  final ReturnReceiptRepository _returnReceiptRepository;

  GetReturnReceiptUseCase(this._returnReceiptRepository);

  @override
  Future<ReturnReceiptEntity> call({String? params}) async {
    try {
      if (params == null) throw "Empty invoice document number";
      final ReturnReceiptEntity returnReceiptModel =
          await _returnReceiptRepository.getReturnReceiptByDocNum(invoiceDocNum: params);

      return ReturnReceiptEntity(
        receiptEntity: returnReceiptModel.receiptEntity,
        customerEntity: returnReceiptModel.customerEntity,
        storeMasterEntity: returnReceiptModel.storeMasterEntity,
        transDateTime: returnReceiptModel.transDateTime,
        timezone: returnReceiptModel.timezone,
      );
    } catch (e) {
      rethrow;
    }
  }
}
