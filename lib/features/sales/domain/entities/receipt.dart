// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pos_fe/features/sales/data/models/vouchers_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';

class ReceiptEntity {
  String docNum;
  List<ReceiptItemEntity> receiptItems;
  MopSelectionEntity? mopSelection;
  CustomerEntity? customerEntity;
  EmployeeEntity? employeeEntity;
  double totalTax;
  DateTime? transDateTime;
  DateTime transStart;
  DateTime? transEnd;
  double subtotal;
  double taxAmount;
  double grandTotal;
  double? totalPayment;
  double? changed;
  String? toinvId;
  List<VouchersSelectionEntity> vouchers;
  int? totalVoucher;
  double? totalNonVoucher;

  ReceiptEntity({
    required this.docNum,
    required this.receiptItems,
    this.mopSelection,
    this.customerEntity,
    this.employeeEntity,
    required this.totalTax,
    this.transDateTime,
    required this.transStart,
    this.transEnd,
    required this.subtotal,
    required this.taxAmount,
    required this.grandTotal,
    this.totalPayment,
    this.changed,
    this.toinvId,
    required this.vouchers,
    this.totalVoucher,
    this.totalNonVoucher,
  });

  ReceiptEntity copyWith({
    String? docNum,
    List<ReceiptItemEntity>? receiptItems,
    MopSelectionEntity? mopSelection,
    CustomerEntity? customerEntity,
    EmployeeEntity? employeeEntity,
    double? totalTax,
    DateTime? transDateTime,
    DateTime? transStart,
    DateTime? transEnd,
    double? subtotal,
    double? taxAmount,
    double? grandTotal,
    double? totalPayment,
    double? changed,
    String? toinvId,
    List<VouchersSelectionEntity>? vouchers,
    int? totalVoucher,
    double? totalNonVoucher,
  }) {
    return ReceiptEntity(
      docNum: docNum ?? this.docNum,
      receiptItems: receiptItems ?? this.receiptItems,
      mopSelection: mopSelection ?? this.mopSelection,
      customerEntity: customerEntity ?? this.customerEntity,
      employeeEntity: employeeEntity ?? this.employeeEntity,
      totalTax: totalTax ?? this.totalTax,
      transDateTime: transDateTime ?? this.transDateTime,
      transStart: transStart ?? this.transStart,
      transEnd: transEnd ?? this.transEnd,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      totalPayment: totalPayment ?? this.totalPayment,
      changed: changed ?? this.changed,
      toinvId: toinvId ?? this.toinvId,
      vouchers: vouchers ?? this.vouchers,
      totalVoucher: totalVoucher ?? this.totalVoucher,
      totalNonVoucher: totalNonVoucher ?? this.totalNonVoucher,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docNum': docNum,
      'receiptItems': receiptItems.map((x) => x.toMap()).toList(),
      'mopSelection': mopSelection?.toMap(),
      'customerEntity': customerEntity?.toMap(),
      'employeeEntity': employeeEntity?.toMap(),
      'totalTax': totalTax,
      'transDateTime': transDateTime?.millisecondsSinceEpoch,
      'transStart': transStart.millisecondsSinceEpoch,
      'transEnd': transEnd?.millisecondsSinceEpoch,
      'subtotal': subtotal,
      'taxAmount': taxAmount,
      'grandTotal': grandTotal,
      'totalPayment': totalPayment,
      'changed': changed,
      'toinvId': toinvId,
      'vouchers': vouchers.map((x) => x.toMap()).toList(),
      'totalVoucher': totalVoucher,
      'totalNonVoucher': totalNonVoucher,
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
      mopSelection: map['mopSelection'] != null
          ? MopSelectionEntity.fromMap(
              map['mopSelection'] as Map<String, dynamic>)
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
      transDateTime: map['transDateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['transDateTime'] as int)
          : null,
      transStart: DateTime.fromMillisecondsSinceEpoch(map['transStart'] as int),
      transEnd: map['transEnd'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['transEnd'] as int)
          : null,
      subtotal: map['subtotal'] as double,
      taxAmount: map['taxAmount'] as double,
      grandTotal: map['grandTotal'] as double,
      totalPayment:
          map['totalPayment'] != null ? map['totalPayment'] as double : null,
      changed: map['changed'] != null ? map['changed'] as double : null,
      toinvId: map['toinvId'] != null ? map['toinvId'] as String : null,
      vouchers: List<VouchersSelectionModel>.from(
        (map['vouchers'] as List<int>).map<VouchersSelectionModel>(
          (x) => VouchersSelectionModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalVoucher:
          map['totalVoucher'] != null ? map['totalVoucher'] as int : null,
      totalNonVoucher: map['totalNonVoucher'] != null
          ? map['totalNonVoucher'] as double
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReceiptEntity.fromJson(String source) =>
      ReceiptEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ReceiptEntity(docNum: $docNum, receiptItems: $receiptItems, mopSelection: $mopSelection, customerEntity: $customerEntity, employeeEntity: $employeeEntity, totalTax: $totalTax, transDateTime: $transDateTime, transStart: $transStart, transEnd: $transEnd, subtotal: $subtotal, taxAmount: $taxAmount, grandTotal: $grandTotal, totalPayment: $totalPayment, changed: $changed, toinvId: $toinvId, vouchers: $vouchers, totalVoucher: $totalVoucher, totalNonVoucher: $totalNonVoucher)';
  }

  @override
  bool operator ==(covariant ReceiptEntity other) {
    if (identical(this, other)) return true;

    return other.docNum == docNum &&
        listEquals(other.receiptItems, receiptItems) &&
        other.mopSelection == mopSelection &&
        other.customerEntity == customerEntity &&
        other.employeeEntity == employeeEntity &&
        other.totalTax == totalTax &&
        other.transDateTime == transDateTime &&
        other.transStart == transStart &&
        other.transEnd == transEnd &&
        other.subtotal == subtotal &&
        other.taxAmount == taxAmount &&
        other.grandTotal == grandTotal &&
        other.totalPayment == totalPayment &&
        other.changed == changed &&
        other.toinvId == toinvId &&
        listEquals(other.vouchers, vouchers) &&
        other.totalVoucher == totalVoucher &&
        other.totalNonVoucher == totalNonVoucher;
  }

  @override
  int get hashCode {
    return docNum.hashCode ^
        receiptItems.hashCode ^
        mopSelection.hashCode ^
        customerEntity.hashCode ^
        employeeEntity.hashCode ^
        totalTax.hashCode ^
        transDateTime.hashCode ^
        transStart.hashCode ^
        transEnd.hashCode ^
        subtotal.hashCode ^
        taxAmount.hashCode ^
        grandTotal.hashCode ^
        totalPayment.hashCode ^
        changed.hashCode ^
        toinvId.hashCode ^
        vouchers.hashCode ^
        totalVoucher.hashCode ^
        totalNonVoucher.hashCode;
  }
}
