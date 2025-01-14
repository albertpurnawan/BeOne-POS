// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pos_fe/features/sales/domain/entities/approval_invoice.dart';
import 'package:pos_fe/features/sales/domain/entities/customer.dart';
import 'package:pos_fe/features/sales/domain/entities/down_payment_entity.dart';
import 'package:pos_fe/features/sales/domain/entities/employee.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_selection.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_coupon_header.dart';
import 'package:pos_fe/features/sales/domain/entities/promotions.dart';
import 'package:pos_fe/features/sales/domain/entities/receipt_item.dart';
import 'package:pos_fe/features/sales/domain/entities/vouchers_selection.dart';

/// ========================================================================================================
///                                        !!! IMPORTANT !!!
/// ========================================================================================================
/// - <previousReceiptEntity> has customized code on the data class, thus automatic generation of data class
///   will lead to wrong behaviors on the app. Please make changes manually.
/// ========================================================================================================

class ReceiptEntity {
  String docNum;
  List<ReceiptItemEntity> receiptItems;
  List<MopSelectionEntity> mopSelections;
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
  List<PromotionsEntity> promos;
  double? discAmount;
  double? discPrctg;
  double? discHeaderManual;
  double? discHeaderPromo;
  ReceiptEntity? previousReceiptEntity;
  String? queuedInvoiceHeaderDocId;
  double rounding;
  String? remarks;
  String? toinvTohemId;
  String? salesTohemId;
  List<ApprovalInvoiceEntity>? approvals;
  List<PromoCouponHeaderEntity> coupons;
  int? includePromo;
  double couponDiscount = 0;
  String? refpos2;
  List<DownPaymentEntity>? downPayments;

  ReceiptEntity({
    required this.docNum,
    required this.receiptItems,
    this.mopSelections = const [],
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
    required this.promos,
    this.discAmount,
    this.discPrctg,
    this.discHeaderManual,
    this.discHeaderPromo,
    this.previousReceiptEntity,
    this.queuedInvoiceHeaderDocId,
    this.rounding = 0,
    this.remarks,
    this.toinvTohemId,
    this.salesTohemId,
    this.approvals,
    this.coupons = const [],
    this.includePromo,
    this.couponDiscount = 0,
    this.refpos2,
    this.downPayments,
  });

  ReceiptEntity copyWith({
    String? docNum,
    List<ReceiptItemEntity>? receiptItems,
    List<MopSelectionEntity>? mopSelections,
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
    List<PromotionsEntity>? promos,
    double? discAmount,
    double? discPrctg,
    double? discHeaderManual,
    double? discHeaderPromo,
    ReceiptEntity? previousReceiptEntity,
    String? queuedInvoiceHeaderDocId,
    double? rounding,
    String? remarks,
    String? toinvTohemId,
    String? salesTohemId,
    List<ApprovalInvoiceEntity>? approvals,
    List<PromoCouponHeaderEntity>? coupons,
    int? includePromo,
    double? couponDiscount,
    String? refpos2,
    List<DownPaymentEntity>? downPayments,
  }) {
    return ReceiptEntity(
      docNum: docNum ?? this.docNum,
      receiptItems: receiptItems ?? this.receiptItems,
      mopSelections: mopSelections ?? this.mopSelections,
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
      promos: promos ?? this.promos,
      discAmount: discAmount ?? this.discAmount,
      discPrctg: discPrctg ?? this.discPrctg,
      discHeaderManual: discHeaderManual ?? this.discHeaderManual,
      discHeaderPromo: discHeaderPromo ?? this.discHeaderPromo,
      previousReceiptEntity: previousReceiptEntity,
      queuedInvoiceHeaderDocId: queuedInvoiceHeaderDocId ?? this.queuedInvoiceHeaderDocId,
      rounding: rounding ?? this.rounding,
      remarks: remarks ?? this.remarks,
      toinvTohemId: toinvTohemId ?? this.toinvTohemId,
      salesTohemId: salesTohemId ?? this.salesTohemId,
      approvals: approvals ?? this.approvals,
      coupons: coupons ?? this.coupons,
      includePromo: includePromo ?? this.includePromo,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      refpos2: refpos2 ?? this.refpos2,
      downPayments: downPayments ?? this.downPayments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docNum': docNum,
      'receiptItems': receiptItems.map((x) => x.toMap()).toList(),
      'mopSelection': mopSelections.map((e) => e.toMap()),
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
      'promos': promos.map((x) => x.toMap()).toList(),
      'discAmount': discAmount,
      'discPrctg': discPrctg,
      'discHeaderManual': discHeaderManual,
      'discHeaderPromo': discHeaderPromo,
      'remarks': remarks,
      'toinvTohemId': toinvTohemId,
      'salesTohemId': salesTohemId,
      'approvals': approvals?.map((x) => x.toMap()).toList(),
      'coupons': coupons.map((x) => x.toMap()).toList(),
      'includePromo': includePromo,
      'couponDiscount': couponDiscount,
      'refpos2': refpos2,
      'downPayments': downPayments,
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
      mopSelections: map['mopSelections'].isNotEmpty
          ? map['mopSelections'].map((e) => MopSelectionEntity.fromMap(e as Map<String, dynamic>))
          : [],
      customerEntity:
          map['customerEntity'] != null ? CustomerEntity.fromMap(map['customerEntity'] as Map<String, dynamic>) : null,
      employeeEntity:
          map['employeeEntity'] != null ? EmployeeEntity.fromMap(map['employeeEntity'] as Map<String, dynamic>) : null,
      totalTax: map['totalTax'] as double,
      transDateTime:
          map['transDateTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['transDateTime'] as int) : null,
      transStart: DateTime.fromMillisecondsSinceEpoch(map['transStart'] as int),
      transEnd: map['transEnd'] != null ? DateTime.fromMillisecondsSinceEpoch(map['transEnd'] as int) : null,
      subtotal: map['subtotal'] as double,
      taxAmount: map['taxAmount'] as double,
      grandTotal: map['grandTotal'] as double,
      totalPayment: map['totalPayment'] != null ? map['totalPayment'] as double : null,
      changed: map['changed'] != null ? map['changed'] as double : null,
      toinvId: map['toinvId'] != null ? map['toinvId'] as String : null,
      vouchers: List<VouchersSelectionEntity>.from(
        (map['vouchers'] as List<int>).map<VouchersSelectionEntity>(
          (x) => VouchersSelectionEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalVoucher: map['totalVoucher'] != null ? map['totalVoucher'] as int : null,
      totalNonVoucher: map['totalNonVoucher'] != null ? map['totalNonVoucher'] as double : null,
      promos: List<PromotionsEntity>.from(
        (map['promos'] as List<int>).map<PromotionsEntity>(
          (x) => PromotionsEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
      discAmount: map['discAmount'] != null ? map['discAmount'] as double : null,
      discPrctg: map['discPrctg'] != null ? map['discPrctg'] as double : null,
      discHeaderManual: map['discHeaderManual'] != null ? map['discHeaderManual'] as double : null,
      discHeaderPromo: map['discHeaderPromo'] != null ? map['discHeaderPromo'] as double : null,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      toinvTohemId: map['toinvTohemId'] != null ? map['toinvTohemId'] as String : null,
      salesTohemId: map['salesTohemId'] != null ? map['salesTohemId'] as String : null,
      approvals:
          (map['approvals'] as List).map((x) => ApprovalInvoiceEntity.fromMap(x as Map<String, dynamic>)).toList(),
      coupons: (map['coupons'] as List).map((x) => PromoCouponHeaderEntity.fromMap(x as Map<String, dynamic>)).toList(),
      includePromo: map['includePromo'] != null ? map['includePromo'] as int : null,
      couponDiscount: map['couponDiscount'] != null ? map['couponDiscount'] as double : 0,
      refpos2: map['refpos2'] != null ? map['refpos2'] as String : null,
      downPayments:
          (map['downPayments'] as List).map((x) => DownPaymentEntity.fromMap(x as Map<String, dynamic>)).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReceiptEntity.fromJson(String source) => ReceiptEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return """ReceiptEntity(docNum: $docNum,
    receiptItems: $receiptItems,
    mopSelection: $mopSelections,
    customerEntity: $customerEntity,
    employeeEntity: $employeeEntity,
    totalTax: $totalTax,
    transDateTime: $transDateTime,
    transStart: $transStart,
    transEnd: $transEnd,
    subtotal: $subtotal,
    taxAmount: $taxAmount,
    grandTotal: $grandTotal,
    totalPayment: $totalPayment,
    changed: $changed,
    toinvId: $toinvId,
    vouchers: $vouchers,
    totalVoucher: $totalVoucher,
    totalNonVoucher: $totalNonVoucher,
    promos: $promos,
    discAmount: $discAmount,
    discPrctg: $discPrctg,
    discHeaderManual: $discHeaderManual,
    discHeaderPromo: $discHeaderPromo,
    remarks: $remarks,
    toinvTohemId: $toinvTohemId,
    salesTohemId: $salesTohemId,
    approvals: $approvals,
    coupons: $coupons,
    includePromo: $includePromo,
    rounding: $rounding,
    couponDiscount: $couponDiscount,
    refpos2: $refpos2,
    downPayments: $downPayments,
    
    previousReceiptEntity: $previousReceiptEntity)""";
  }

  @override
  bool operator ==(covariant ReceiptEntity other) {
    if (identical(this, other)) return true;

    return other.docNum == docNum &&
        listEquals(other.receiptItems, receiptItems) &&
        other.mopSelections == mopSelections &&
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
        other.totalNonVoucher == totalNonVoucher &&
        listEquals(other.promos, promos) &&
        other.discAmount == discAmount &&
        other.discPrctg == discPrctg &&
        other.discHeaderManual == discHeaderManual &&
        other.discHeaderPromo == discHeaderPromo &&
        other.remarks == remarks &&
        other.toinvTohemId == toinvTohemId &&
        other.salesTohemId == salesTohemId &&
        other.approvals == approvals &&
        other.coupons == coupons &&
        other.includePromo == includePromo &&
        other.couponDiscount == couponDiscount &&
        other.refpos2 == refpos2 &&
        other.downPayments == downPayments;
    // other.previousReceiptEntity == previousReceiptEntity; kalau tidak ada perubahan apa2 previous gak ke emit
  }

  @override
  int get hashCode {
    return docNum.hashCode ^
        receiptItems.hashCode ^
        mopSelections.hashCode ^
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
        totalNonVoucher.hashCode ^
        promos.hashCode ^
        discAmount.hashCode ^
        discPrctg.hashCode ^
        discHeaderManual.hashCode ^
        discHeaderPromo.hashCode ^
        remarks.hashCode ^
        toinvTohemId.hashCode ^
        salesTohemId.hashCode ^
        approvals.hashCode ^
        coupons.hashCode ^
        includePromo.hashCode ^
        couponDiscount.hashCode ^
        refpos2.hashCode ^
        downPayments.hashCode;
    // previousReceiptEntity.hashCode;
  }
}
