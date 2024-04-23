import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/repository/item_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/queued_receipt_repository.dart';

class DeleteAllQueuedReceiptsUseCase implements UseCase<void, void> {
  final QueuedReceiptRepository _queuedReceiptRepository;

  DeleteAllQueuedReceiptsUseCase(this._queuedReceiptRepository);

  @override
  Future<void> call({void params}) async {
    // TODO: implement call
    return await _queuedReceiptRepository.deleteAll();
  }
}
