import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/return_receipt.dart';

class ReturnReceiptModel extends ReturnReceiptEntity implements BaseModel {
  ReturnReceiptModel({
    required super.customerEntity,
    required super.storeMasterEntity,
    required super.receiptEntity,
    required super.transDateTime,
    required super.timezone,
  });
}
