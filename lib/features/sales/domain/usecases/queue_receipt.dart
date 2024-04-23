import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/repository/employee_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/queued_receipt_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QueueReceiptUseCase implements UseCase<void, ReceiptEntity> {
  final QueuedReceiptRepository _queuedReceiptRepository;

  QueueReceiptUseCase(this._queuedReceiptRepository);

  @override
  Future<ReceiptEntity?> call({ReceiptEntity? params}) async {
    // TODO: implement call
    return await _queuedReceiptRepository.createQueuedReceipt(params!);
  }
}
