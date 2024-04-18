import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/repository/employee_repository.dart';
import 'package:pos_fe/features/sales/domain/repository/receipt_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveReceiptUseCase implements UseCase<void, ReceiptEntity> {
  final ReceiptRepository _receiptRepository;

  SaveReceiptUseCase(this._receiptRepository);

  @override
  Future<ReceiptEntity?> call({ReceiptEntity? params}) async {
    // TODO: implement call
    return await _receiptRepository.createInvoiceHeaderAndDetail(params!);
  }
}
