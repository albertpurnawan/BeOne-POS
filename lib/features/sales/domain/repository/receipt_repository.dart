import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:sqflite/sqflite.dart';

abstract class ReceiptRepository {
  Future<ReceiptEntity?> createInvoiceHeaderAndDetail(ReceiptEntity receiptEntity);

  Future<ReceiptEntity?> getReceiptByInvoiceHeaderDocId(String docId, Transaction? txn);

  Future<List<ReceiptEntity>> getReceipts();

  Future<ReceiptEntity> recalculateTax(ReceiptEntity receiptEntity);

  // Future<ReceiptItemEntity> handlePromoDiskonItem();

  // Future<List<ReceiptEntity>> sendReceipt();
}
