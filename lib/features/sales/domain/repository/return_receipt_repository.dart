import 'package:pos_fe/features/sales/domain/entities/return_receipt.dart';

abstract class ReturnReceiptRepository {
  Future<ReturnReceiptEntity> getReturnReceiptByDocNum({required String invoiceDocNum});
}
