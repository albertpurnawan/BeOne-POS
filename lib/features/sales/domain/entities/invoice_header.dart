import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class InvoiceHeaderEntity {
  final String? docId;
  final DateTime? createDate;
  final DateTime? updateDate;
  final String? tostrId;
  final String docnum;
  final int orderNo;
  final String? tocusId;
  final String? tohemId;
  final DateTime? transDateTime;
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
  final String? toinvTohemId;
  final String? refpos1;
  final String? refpos2;
  final String? tcsr1Id;
  final double? discHeaderManual;
  final double? discHeaderPromo;
  final String? syncToBos;

  InvoiceHeaderEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tostrId,
    required this.docnum,
    required this.orderNo,
    required this.tocusId,
    required this.tohemId,
    required this.transDateTime,
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
    required this.toinvTohemId,
    required this.refpos1,
    required this.refpos2,
    required this.tcsr1Id,
    required this.discHeaderManual,
    required this.discHeaderPromo,
    required this.syncToBos,
  });

  InvoiceHeaderEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tostrId,
    String? docnum,
    int? orderNo,
    String? tocusId,
    String? tohemId,
    DateTime? transDateTime,
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
    String? toinvTohemId,
    String? refpos1,
    String? refpos2,
    String? tcsr1Id,
    double? discHeaderManual,
    double? discHeaderPromo,
    String? syncToBos,
  }) {
    return InvoiceHeaderEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tostrId: tostrId ?? this.tostrId,
      docnum: docnum ?? this.docnum,
      orderNo: orderNo ?? this.orderNo,
      tocusId: tocusId ?? this.tocusId,
      tohemId: tohemId ?? this.tohemId,
      transDateTime: transDateTime ?? this.transDateTime,
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
      toinvTohemId: toinvTohemId ?? this.toinvTohemId,
      refpos1: refpos1 ?? this.refpos1,
      refpos2: refpos2 ?? this.refpos2,
      tcsr1Id: tcsr1Id ?? this.tcsr1Id,
      discHeaderManual: discHeaderManual ?? this.discHeaderManual,
      discHeaderPromo: discHeaderPromo ?? this.discHeaderPromo,
      syncToBos: syncToBos ?? this.syncToBos,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate?.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tostrId': tostrId,
      'docnum': docnum,
      'orderNo': orderNo,
      'tocusId': tocusId,
      'tohemId': tohemId,
      'transDateTime': transDateTime?.millisecondsSinceEpoch,
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
      'toinvTohemId': toinvTohemId,
      'refpos1': refpos1,
      'refpos2': refpos2,
      'tcsr1Id': tcsr1Id,
      'discHeaderManual': discHeaderManual,
      'discHeaderPromo': discHeaderPromo,
      'syncToBos': syncToBos,
    };
  }

  factory InvoiceHeaderEntity.fromMap(Map<String, dynamic> map) {
    return InvoiceHeaderEntity(
      docId: map['docId'] != null ? map['docId'] as String : null,
      createDate: map['createDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int)
          : null,
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      docnum: map['docnum'] as String,
      orderNo: map['orderNo'] as int,
      tocusId: map['tocusId'] != null ? map['tocusId'] as String : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      transDateTime: map['transDateTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['transDateTime'] as int)
          : null,
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
      toinvTohemId:
          map['toinvTohemId'] != null ? map['toinvTohemId'] as String : null,
      refpos1: map['refpos1'] != null ? map['refpos1'] as String : null,
      refpos2: map['refpos2'] != null ? map['refpos2'] as String : null,
      tcsr1Id: map['tcsr1Id'] != null ? map['tcsr1Id'] as String : null,
      discHeaderManual: map['discHeaderManual'] != null
          ? map['discHeaderManual'] as double
          : null,
      discHeaderPromo: map['discHeaderPromo'] != null
          ? map['discHeaderPromo'] as double
          : null,
      syncToBos: map['syncToBos'] != null ? map['syncToBos'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvoiceHeaderEntity.fromJson(String source) =>
      InvoiceHeaderEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InvoiceHeaderEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tostrId: $tostrId, docnum: $docnum, orderNo: $orderNo, tocusId: $tocusId, tohemId: $tohemId, transDateTime: $transDateTime, timezone: $timezone, remarks: $remarks, subTotal: $subTotal, discPrctg: $discPrctg, discAmount: $discAmount, discountCard: $discountCard, coupon: $coupon, discountCoupun: $discountCoupun, taxPrctg: $taxPrctg, taxAmount: $taxAmount, addCost: $addCost, rounding: $rounding, grandTotal: $grandTotal, changed: $changed, totalPayment: $totalPayment, tocsrId: $tocsrId, docStatus: $docStatus, sync: $sync, syncCRM: $syncCRM, toinvTohemId: $toinvTohemId, refpos1: $refpos1, refpos2: $refpos2, tcsr1Id: $tcsr1Id, discHeaderManual: $discHeaderManual, discHeaderPromo: $discHeaderPromo, syncToBos: $syncToBos)';
  }

  @override
  bool operator ==(covariant InvoiceHeaderEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tostrId == tostrId &&
        other.docnum == docnum &&
        other.orderNo == orderNo &&
        other.tocusId == tocusId &&
        other.tohemId == tohemId &&
        other.transDateTime == transDateTime &&
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
        other.toinvTohemId == toinvTohemId &&
        other.refpos1 == refpos1 &&
        other.refpos2 == refpos2 &&
        other.tcsr1Id == tcsr1Id &&
        other.discHeaderManual == discHeaderManual &&
        other.discHeaderPromo == discHeaderPromo &&
        other.syncToBos == syncToBos;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tostrId.hashCode ^
        docnum.hashCode ^
        orderNo.hashCode ^
        tocusId.hashCode ^
        tohemId.hashCode ^
        transDateTime.hashCode ^
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
        toinvTohemId.hashCode ^
        refpos1.hashCode ^
        refpos2.hashCode ^
        tcsr1Id.hashCode ^
        discHeaderManual.hashCode ^
        discHeaderPromo.hashCode ^
        syncToBos.hashCode;
  }
}
