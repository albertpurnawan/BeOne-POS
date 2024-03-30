import 'package:pos_fe/features/settings/domain/entities/receipt_content.dart';

abstract class ReceiptContentRepository {
  Future<List<ReceiptContentEntity?>> getReceiptContents();
}
