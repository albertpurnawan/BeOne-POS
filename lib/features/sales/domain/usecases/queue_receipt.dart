import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/repository/queued_receipt_repository.dart';

class QueueReceiptUseCase implements UseCase<void, ReceiptEntity> {
  final QueuedReceiptRepository _queuedReceiptRepository;

  QueueReceiptUseCase(this._queuedReceiptRepository);

  @override
  Future<ReceiptEntity?> call({ReceiptEntity? params}) async {
    return await _queuedReceiptRepository.createQueuedReceipt(params!);
  }
}
