import 'package:pos_fe/features/sales/domain/entities/receipt.dart';

abstract class ReceiptRepository {
  Future<ReceiptEntity?> createInvoiceHeaderAndDetail(
      ReceiptEntity receiptEntity);

  Future<ReceiptEntity?> getReceiptByInvoiceHeaderDocId(String docId);

  Future<List<ReceiptEntity>> getReceipts();

  // Future<ReceiptItemEntity> handlePromoDiskonItem();

  // Future<List<ReceiptEntity>> sendReceipt();
}
