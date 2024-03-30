import 'package:pos_fe/features/sales/domain/entities/item.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';

abstract class ReceiptRepository {
  Future<void> createInvoiceHeaderAndDetail(ReceiptEntity receiptEntity);

  Future<ItemEntity?> getInvoiceByDocId(String docId);

  Future<List<ItemEntity>> getInvoices();
}
