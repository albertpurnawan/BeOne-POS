import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/repository/queued_receipt_repository.dart';

class DeleteQueuedReceiptUseCase implements UseCase<void, String?> {
  final QueuedReceiptRepository _queuedReceiptRepository;

  DeleteQueuedReceiptUseCase(this._queuedReceiptRepository);

  @override
  Future<void> call({String? params}) async {
    return await _queuedReceiptRepository.deleteByDocId(params!);
  }
}
