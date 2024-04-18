import 'package:pos_fe/core/resources/receipt_printer.dart';
import 'package:pos_fe/core/usecases/usecase.dart';

class OpenCashDrawerUseCase implements UseCase<void, void> {
  final ReceiptPrinter _receiptPrinter;

  OpenCashDrawerUseCase(this._receiptPrinter);

  @override
  Future<void> call({void params}) async {
    await _receiptPrinter.openCashDrawer();
  }
}
