// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CreditMemoHeaderEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tostrId;
  final String docNum;
  final int orderNo;
  final String? tocusId;
  final String? tohemId;
  final DateTime transDate;
  final DateTime transTime;
  final String timezone;
  final String? remarks;
  final double subTotal;
  final double discPrctg;
  final double discAmount;
  final double discountCard;
  final String coupon;
  final double discountCoupun;
  final double taxPrctg;
  final double taxAmount;
  final double addCost;
  final double rounding;
  final double grandTotal;
  final double changed;
  final double totalPayment;
  final String? tocsrId;
  final int docStatus;
  final int sync;
  final int syncCRM;
  final String? torinTohemId;

  CreditMemoHeaderEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tostrId,
    required this.docNum,
    required this.orderNo,
    required this.tocusId,
    required this.tohemId,
    required this.transDate,
    required this.transTime,
    required this.timezone,
    required this.remarks,
    required this.subTotal,
    required this.discPrctg,
    required this.discAmount,
    required this.discountCard,
    required this.coupon,
    required this.discountCoupun,
    required this.taxPrctg,
    required this.taxAmount,
    required this.addCost,
    required this.rounding,
    required this.grandTotal,
    required this.changed,
    required this.totalPayment,
    required this.tocsrId,
    required this.docStatus,
    required this.sync,
    required this.syncCRM,
    required this.torinTohemId,
  });

  CreditMemoHeaderEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tostrId,
    String? docNum,
    int? orderNo,
    String? tocusId,
    String? tohemId,
    DateTime? transDate,
    DateTime? transTime,
    String? timezone,
    String? remarks,
    double? subTotal,
    double? discPrctg,
    double? discAmount,
    double? discountCard,
    String? coupon,
    double? discountCoupun,
    double? taxPrctg,
    double? taxAmount,
    double? addCost,
    double? rounding,
    double? grandTotal,
    double? changed,
    double? totalPayment,
    String? tocsrId,
    int? docStatus,
    int? sync,
    int? syncCRM,
    String? torinTohemId,
  }) {
    return CreditMemoHeaderEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tostrId: tostrId ?? this.tostrId,
      docNum: docNum ?? this.docNum,
      orderNo: orderNo ?? this.orderNo,
      tocusId: tocusId ?? this.tocusId,
      tohemId: tohemId ?? this.tohemId,
      transDate: transDate ?? this.transDate,
      transTime: transTime ?? this.transTime,
      timezone: timezone ?? this.timezone,
      remarks: remarks ?? this.remarks,
      subTotal: subTotal ?? this.subTotal,
      discPrctg: discPrctg ?? this.discPrctg,
      discAmount: discAmount ?? this.discAmount,
      discountCard: discountCard ?? this.discountCard,
      coupon: coupon ?? this.coupon,
      discountCoupun: discountCoupun ?? this.discountCoupun,
      taxPrctg: taxPrctg ?? this.taxPrctg,
      taxAmount: taxAmount ?? this.taxAmount,
      addCost: addCost ?? this.addCost,
      rounding: rounding ?? this.rounding,
      grandTotal: grandTotal ?? this.grandTotal,
      changed: changed ?? this.changed,
      totalPayment: totalPayment ?? this.totalPayment,
      tocsrId: tocsrId ?? this.tocsrId,
      docStatus: docStatus ?? this.docStatus,
      sync: sync ?? this.sync,
      syncCRM: syncCRM ?? this.syncCRM,
      torinTohemId: torinTohemId ?? this.torinTohemId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tostrId': tostrId,
      'docNum': docNum,
      'orderNo': orderNo,
      'tocusId': tocusId,
      'tohemId': tohemId,
      'transDate': transDate.millisecondsSinceEpoch,
      'transTime': transTime.millisecondsSinceEpoch,
      'timezone': timezone,
      'remarks': remarks,
      'subTotal': subTotal,
      'discPrctg': discPrctg,
      'discAmount': discAmount,
      'discountCard': discountCard,
      'coupon': coupon,
      'discountCoupun': discountCoupun,
      'taxPrctg': taxPrctg,
      'taxAmount': taxAmount,
      'addCost': addCost,
      'rounding': rounding,
      'grandTotal': grandTotal,
      'changed': changed,
      'totalPayment': totalPayment,
      'tocsrId': tocsrId,
      'docStatus': docStatus,
      'sync': sync,
      'syncCRM': syncCRM,
      'torinTohemId': torinTohemId,
    };
  }

  factory CreditMemoHeaderEntity.fromMap(Map<String, dynamic> map) {
    return CreditMemoHeaderEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      docNum: map['docNum'] as String,
      orderNo: map['orderNo'] as int,
      tocusId: map['tocusId'] != null ? map['tocusId'] as String : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      transDate: DateTime.fromMillisecondsSinceEpoch(map['transDate'] as int),
      transTime: DateTime.fromMillisecondsSinceEpoch(map['transTime'] as int),
      timezone: map['timezone'] as String,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      subTotal: map['subTotal'] as double,
      discPrctg: map['discPrctg'] as double,
      discAmount: map['discAmount'] as double,
      discountCard: map['discountCard'] as double,
      coupon: map['coupon'] as String,
      discountCoupun: map['discountCoupun'] as double,
      taxPrctg: map['taxPrctg'] as double,
      taxAmount: map['taxAmount'] as double,
      addCost: map['addCost'] as double,
      rounding: map['rounding'] as double,
      grandTotal: map['grandTotal'] as double,
      changed: map['changed'] as double,
      totalPayment: map['totalPayment'] as double,
      tocsrId: map['tocsrId'] != null ? map['tocsrId'] as String : null,
      docStatus: map['docStatus'] as int,
      sync: map['sync'] as int,
      syncCRM: map['syncCRM'] as int,
      torinTohemId:
          map['torinTohemId'] != null ? map['torinTohemId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreditMemoHeaderEntity.fromJson(String source) =>
      CreditMemoHeaderEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreditMemoHeaderEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tostrId: $tostrId, docNum: $docNum, orderNo: $orderNo, tocusId: $tocusId, tohemId: $tohemId, transDate: $transDate, transTime: $transTime, timezone: $timezone, remarks: $remarks, subTotal: $subTotal, discPrctg: $discPrctg, discAmount: $discAmount, discountCard: $discountCard, coupon: $coupon, discountCoupun: $discountCoupun, taxPrctg: $taxPrctg, taxAmount: $taxAmount, addCost: $addCost, rounding: $rounding, grandTotal: $grandTotal, changed: $changed, totalPayment: $totalPayment, tocsrId: $tocsrId, docStatus: $docStatus, sync: $sync, syncCRM: $syncCRM, torinTohemId: $torinTohemId)';
  }

  @override
  bool operator ==(covariant CreditMemoHeaderEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tostrId == tostrId &&
        other.docNum == docNum &&
        other.orderNo == orderNo &&
        other.tocusId == tocusId &&
        other.tohemId == tohemId &&
        other.transDate == transDate &&
        other.transTime == transTime &&
        other.timezone == timezone &&
        other.remarks == remarks &&
        other.subTotal == subTotal &&
        other.discPrctg == discPrctg &&
        other.discAmount == discAmount &&
        other.discountCard == discountCard &&
        other.coupon == coupon &&
        other.discountCoupun == discountCoupun &&
        other.taxPrctg == taxPrctg &&
        other.taxAmount == taxAmount &&
        other.addCost == addCost &&
        other.rounding == rounding &&
        other.grandTotal == grandTotal &&
        other.changed == changed &&
        other.totalPayment == totalPayment &&
        other.tocsrId == tocsrId &&
        other.docStatus == docStatus &&
        other.sync == sync &&
        other.syncCRM == syncCRM &&
        other.torinTohemId == torinTohemId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tostrId.hashCode ^
        docNum.hashCode ^
        orderNo.hashCode ^
        tocusId.hashCode ^
        tohemId.hashCode ^
        transDate.hashCode ^
        transTime.hashCode ^
        timezone.hashCode ^
        remarks.hashCode ^
        subTotal.hashCode ^
        discPrctg.hashCode ^
        discAmount.hashCode ^
        discountCard.hashCode ^
        coupon.hashCode ^
        discountCoupun.hashCode ^
        taxPrctg.hashCode ^
        taxAmount.hashCode ^
        addCost.hashCode ^
        rounding.hashCode ^
        grandTotal.hashCode ^
        changed.hashCode ^
        totalPayment.hashCode ^
        tocsrId.hashCode ^
        docStatus.hashCode ^
        sync.hashCode ^
        syncCRM.hashCode ^
        torinTohemId.hashCode;
  }
}