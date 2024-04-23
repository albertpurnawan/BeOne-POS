import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/queued_receipt_repository.dart';

class GetQueuedReceiptsUseCase
    implements UseCase<List<ReceiptEntity>, String?> {
  final QueuedReceiptRepository _queuedReceiptRepository;

  GetQueuedReceiptsUseCase(this._queuedReceiptRepository);

  @override
  Future<List<ReceiptEntity>> call({String? params}) async {
    // TODO: implement call
    return await _queuedReceiptRepository.getQueuedReceipts();
  }
}
