import 'package:pos_fe/features/sales/domain/entities/cash_register.dart';
import 'package:pos_fe/features/sales/domain/entities/pos_parameter.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';
import 'package:pos_fe/features/settings/domain/entities/receipt_content.dart';

class PrintReceiptDetail {
  final ReceiptEntity receiptEntity;
  final POSParameterEntity posParameterEntity;
  final StoreMasterEntity storeMasterEntity;
  final CashRegisterEntity cashRegisterEntity;
  final List<ReceiptContentEntity?> receiptContentEntities;
  final bool isDraft;

  PrintReceiptDetail({
    required this.receiptEntity,
    required this.posParameterEntity,
    required this.storeMasterEntity,
    required this.cashRegisterEntity,
    required this.receiptContentEntities,
    required this.isDraft,
  });
}
