// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';

class ReceiptEntity {
  String docNum;
  List<ReceiptItemEntity> receiptItems;
  double totalPrice;
  DateTime? createdAt;
  MopSelectionEntity? mopSelection;
  double? amountReceived;
  CustomerEntity? customerEntity;
  EmployeeEntity? employeeEntity;
  double totalTax;

  ReceiptEntity({
    required this.docNum,
    required this.receiptItems,
    required this.totalPrice,
    this.createdAt,
    this.mopSelection,
    this.amountReceived,
    this.customerEntity,
    this.employeeEntity,
    required this.totalTax,
  });

  ReceiptEntity copyWith({
    String? docNum,
    List<ReceiptItemEntity>? receiptItems,
    double? totalPrice,
    DateTime? createdAt,
    MopSelectionEntity? mopSelection,
    double? amountReceived,
    CustomerEntity? customerEntity,
    EmployeeEntity? employeeEntity,
    double? totalTax,
  }) {
    return ReceiptEntity(
      docNum: docNum ?? this.docNum,
      receiptItems: receiptItems ?? this.receiptItems,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
      mopSelection: mopSelection ?? this.mopSelection,
      amountReceived: amountReceived ?? this.amountReceived,
      customerEntity: customerEntity ?? this.customerEntity,
      employeeEntity: employeeEntity ?? this.employeeEntity,
      totalTax: totalTax ?? this.totalTax,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docNum': docNum,
      'receiptItems': receiptItems.map((x) => x.toMap()).toList(),
      'totalPrice': totalPrice,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'mopSelection': mopSelection?.toMap(),
      'amountReceived': amountReceived,
      'customerEntity': customerEntity?.toMap(),
      'employeeEntity': employeeEntity?.toMap(),
      'totalTax': totalTax,
    };
  }

  factory ReceiptEntity.fromMap(Map<String, dynamic> map) {
    return ReceiptEntity(
      docNum: map['docNum'] as String,
      receiptItems: List<ReceiptItemEntity>.from(
        (map['receiptItems'] as List<int>).map<ReceiptItemEntity>(
          (x) => ReceiptItemEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalPrice: map['totalPrice'] as double,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      mopSelection: map['mopSelection'] != null
          ? MopSelectionEntity.fromMap(
              map['mopSelection'] as Map<String, dynamic>)
          : null,
      amountReceived: map['amountReceived'] != null
          ? map['amountReceived'] as double
          : null,
      customerEntity: map['customerEntity'] != null
          ? CustomerEntity.fromMap(
              map['customerEntity'] as Map<String, dynamic>)
          : null,
      employeeEntity: map['employeeEntity'] != null
          ? EmployeeEntity.fromMap(
              map['employeeEntity'] as Map<String, dynamic>)
          : null,
      totalTax: map['totalTax'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReceiptEntity.fromJson(String source) =>
      ReceiptEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReceiptEntity(docNum: $docNum, receiptItems: $receiptItems, totalPrice: $totalPrice, createdAt: $createdAt, mopSelection: $mopSelection, amountReceived: $amountReceived, customerEntity: $customerEntity, employeeEntity: $employeeEntity, totalTax: $totalTax)';
  }

  @override
  bool operator ==(covariant ReceiptEntity other) {
    if (identical(this, other)) return true;

    return other.docNum == docNum &&
        listEquals(other.receiptItems, receiptItems) &&
        other.totalPrice == totalPrice &&
        other.createdAt == createdAt &&
        other.mopSelection == mopSelection &&
        other.amountReceived == amountReceived &&
        other.customerEntity == customerEntity &&
        other.employeeEntity == employeeEntity &&
        other.totalTax == totalTax;
  }

  @override
  int get hashCode {
    return docNum.hashCode ^
        receiptItems.hashCode ^
        totalPrice.hashCode ^
        createdAt.hashCode ^
        mopSelection.hashCode ^
        amountReceived.hashCode ^
        customerEntity.hashCode ^
        employeeEntity.hashCode ^
        totalTax.hashCode;
  }
}
