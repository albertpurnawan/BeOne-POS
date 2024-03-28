import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/settings/domain/entities/receipt_content.dart';

class PrintReceiptDetail {
  final ReceiptEntity receiptEntity;
  final POSParameterEntity posParameterEntity;
  final StoreMasterEntity storeMasterEntity;
  final List<ReceiptContentEntity?> receiptContentEntities;

  PrintReceiptDetail(
      {required this.receiptEntity,
      required this.posParameterEntity,
      required this.storeMasterEntity,
      required this.receiptContentEntities});
}
