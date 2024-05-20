import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_repository.dart';

class RecalculateTaxUseCase implements UseCase<void, ReceiptEntity> {
  final ReceiptRepository _receiptRepository;

  RecalculateTaxUseCase(this._receiptRepository);

  @override
  Future<ReceiptEntity> call({ReceiptEntity? params}) async {
    return await _receiptRepository.recalculateTax(params!);
  }
}
