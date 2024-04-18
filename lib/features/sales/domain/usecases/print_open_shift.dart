import 'package:pos_fe/core/resources/receipt_printer.dart';
import 'package:pos_fe/core/usecases/usecase.dart';
import 'package:pos_fe/features/sales/domain/entities/cashier_balance_transaction.dart';

class PrintOpenShiftUsecase
    implements UseCase<void, CashierBalanceTransactionEntity?> {
  // POS Parameter
  final ReceiptPrinter _receiptPrinter;

  PrintOpenShiftUsecase(this._receiptPrinter);

  @override
  Future<void> call({CashierBalanceTransactionEntity? params}) async {
    await _receiptPrinter.printOpenShift();
  }
}
