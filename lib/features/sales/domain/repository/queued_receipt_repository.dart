import 'package:pos_fe/features/sales/domain/entities/receipt.dart';

abstract class QueuedReceiptRepository {
  Future<ReceiptEntity?> createQueuedReceipt(ReceiptEntity receiptEntity);

  Future<ReceiptEntity?> getQueuedReceiptByDocId(String docId);

  Future<List<ReceiptEntity>> getQueuedReceipts();

  Future<void> deleteByDocId(String docId);

  Future<void> deleteAll();
}
