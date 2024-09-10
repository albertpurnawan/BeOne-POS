// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';

class ReturnBaseReceiptEntity {
  final String docNum;
  final DateTime transDateTime;
  final String timezone;
  final StoreMasterEntity storeMasterEntity;
  final double grandTotal;
  final CustomerEntity customerEntity;
  final List<ReceiptItemEntity> availableItems;

  ReturnBaseReceiptEntity({
    required this.docNum,
    required this.transDateTime,
    required this.timezone,
    required this.storeMasterEntity,
    required this.grandTotal,
    required this.customerEntity,
    required this.availableItems,
  });
}
