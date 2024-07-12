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
  final String? refpos1;
  final String? refpos2;
  final String? voidTohemId;
  final String? channel;

  CreditMemoHeaderEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    this.tostrId,
    required this.docNum,
    required this.orderNo,
    this.tocusId,
    this.tohemId,
    required this.transDate,
    required this.transTime,
    required this.timezone,
    this.remarks,
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
    this.tocsrId,
    required this.docStatus,
    required this.sync,
    required this.syncCRM,
    this.torinTohemId,
    this.refpos1,
    this.refpos2,
    this.voidTohemId,
    this.channel,
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
    String? refpos1,
    String? refpos2,
    String? voidTohemId,
    String? channel,
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
      refpos1: refpos1 ?? this.refpos1,
      refpos2: refpos2 ?? this.refpos2,
      voidTohemId: voidTohemId ?? this.voidTohemId,
      channel: channel ?? this.channel,
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
      'refpos1': refpos1,
      'refpos2': refpos2,
      'voidTohemId': voidTohemId,
      'channel': channel,
    };
  }

  factory CreditMemoHeaderEntity.fromMap(Map<String, dynamic> map) {
    return CreditMemoHeaderEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
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
      torinTohemId: map['torinTohemId'] != null ? map['torinTohemId'] as String : null,
      refpos1: map['refpos1'] != null ? map['refpos1'] as String : null,
      refpos2: map['refpos2'] != null ? map['refpos2'] as String : null,
      voidTohemId: map['voidTohemId'] != null ? map['voidTohemId'] as String : null,
      channel: map['channel'] != null ? map['channel'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreditMemoHeaderEntity.fromJson(String source) =>
      CreditMemoHeaderEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreditMemoHeaderEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tostrId: $tostrId, docNum: $docNum, orderNo: $orderNo, tocusId: $tocusId, tohemId: $tohemId, transDate: $transDate, transTime: $transTime, timezone: $timezone, remarks: $remarks, subTotal: $subTotal, discPrctg: $discPrctg, discAmount: $discAmount, discountCard: $discountCard, coupon: $coupon, discountCoupun: $discountCoupun, taxPrctg: $taxPrctg, taxAmount: $taxAmount, addCost: $addCost, rounding: $rounding, grandTotal: $grandTotal, changed: $changed, totalPayment: $totalPayment, tocsrId: $tocsrId, docStatus: $docStatus, sync: $sync, syncCRM: $syncCRM, torinTohemId: $torinTohemId, refpos1: $refpos1, refpos2: $refpos2, voidTohemId: $voidTohemId, channel: $channel)';
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
        other.torinTohemId == torinTohemId &&
        other.refpos1 == refpos1 &&
        other.refpos2 == refpos2 &&
        other.voidTohemId == voidTohemId &&
        other.channel == channel;
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
        torinTohemId.hashCode ^
        refpos1.hashCode ^
        refpos2.hashCode ^
        voidTohemId.hashCode ^
        channel.hashCode;
  }
}
