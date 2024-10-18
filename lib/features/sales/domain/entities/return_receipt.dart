// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt.dart';
import 'package:pos_fe/features/sales/domain/entities/store_master.dart';

class ReturnReceiptEntity {
  final ReceiptEntity receiptEntity;
  final StoreMasterEntity storeMasterEntity;
  final CustomerEntity customerEntity;
  final DateTime transDateTime;
  final String timezone;

  ReturnReceiptEntity({
    required this.receiptEntity,
    required this.storeMasterEntity,
    required this.customerEntity,
    required this.transDateTime,
    required this.timezone,
  });

  ReturnReceiptEntity copyWith({
    ReceiptEntity? receiptEntity,
    StoreMasterEntity? storeMasterEntity,
    CustomerEntity? customerEntity,
    DateTime? transDateTime,
    String? timezone,
  }) {
    return ReturnReceiptEntity(
      receiptEntity: receiptEntity ?? this.receiptEntity,
      storeMasterEntity: storeMasterEntity ?? this.storeMasterEntity,
      customerEntity: customerEntity ?? this.customerEntity,
      transDateTime: transDateTime ?? this.transDateTime,
      timezone: timezone ?? this.timezone,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'receiptEntity': receiptEntity.toMap(),
      'storeMasterEntity': storeMasterEntity.toMap(),
      'customerEntity': customerEntity.toMap(),
      'transDateTime': transDateTime.millisecondsSinceEpoch,
      'timezone': timezone,
    };
  }

  factory ReturnReceiptEntity.fromMap(Map<String, dynamic> map) {
    return ReturnReceiptEntity(
      receiptEntity: ReceiptEntity.fromMap(map['receiptEntity'] as Map<String, dynamic>),
      storeMasterEntity: StoreMasterEntity.fromMap(map['storeMasterEntity'] as Map<String, dynamic>),
      customerEntity: CustomerEntity.fromMap(map['customerEntity'] as Map<String, dynamic>),
      transDateTime: DateTime.fromMillisecondsSinceEpoch(map['transDateTime'] as int),
      timezone: map['timezone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReturnReceiptEntity.fromJson(String source) =>
      ReturnReceiptEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReturnReceiptEntity(receiptEntity: $receiptEntity, storeMasterEntity: $storeMasterEntity, customerEntity: $customerEntity, transDateTime: $transDateTime, timezone: $timezone)';
  }

  @override
  bool operator ==(covariant ReturnReceiptEntity other) {
    if (identical(this, other)) return true;

    return other.receiptEntity == receiptEntity &&
        other.storeMasterEntity == storeMasterEntity &&
        other.customerEntity == customerEntity &&
        other.transDateTime == transDateTime &&
        other.timezone == timezone;
  }

  @override
  int get hashCode {
    return receiptEntity.hashCode ^
        storeMasterEntity.hashCode ^
        customerEntity.hashCode ^
        transDateTime.hashCode ^
        timezone.hashCode;
  }
}
