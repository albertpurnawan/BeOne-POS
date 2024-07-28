// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class InvoiceDetailEntity {
  final String docId;
  final DateTime? createDate;
  final DateTime? updateDate;
  final String? toinvId;
  final int lineNum;
  final String docNum;
  final int idNumber;
  final String? toitmId;
  final double quantity;
  final double sellingPrice;
  final double discPrctg;
  final double discAmount;
  final double totalAmount;
  final double taxPrctg;
  final String promotionType;
  final String promotionId;
  final String? remarks;
  final DateTime editTime;
  final double cogs;
  final String? tovatId;
  final String? promotionTingkat;
  final String? promoVoucherNo;
  final String? baseDocId;
  final String? baseLineDocId;
  final int includeTax;
  final String? tovenId;
  final String? tbitmId;
  final double? discHeaderAmount;
  final double? subtotalAfterDiscHeader;
  final String? tohemId;

  InvoiceDetailEntity({
    required this.docId,
    this.createDate,
    this.updateDate,
    this.toinvId,
    required this.lineNum,
    required this.docNum,
    required this.idNumber,
    this.toitmId,
    required this.quantity,
    required this.sellingPrice,
    required this.discPrctg,
    required this.discAmount,
    required this.totalAmount,
    required this.taxPrctg,
    required this.promotionType,
    required this.promotionId,
    this.remarks,
    required this.editTime,
    required this.cogs,
    this.tovatId,
    this.promotionTingkat,
    this.promoVoucherNo,
    this.baseDocId,
    this.baseLineDocId,
    required this.includeTax,
    this.tovenId,
    this.tbitmId,
    this.discHeaderAmount,
    this.subtotalAfterDiscHeader,
    this.tohemId,
  });

  InvoiceDetailEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toinvId,
    int? lineNum,
    String? docNum,
    int? idNumber,
    String? toitmId,
    double? quantity,
    double? sellingPrice,
    double? discPrctg,
    double? discAmount,
    double? totalAmount,
    double? taxPrctg,
    String? promotionType,
    String? promotionId,
    String? remarks,
    DateTime? editTime,
    double? cogs,
    String? tovatId,
    String? promotionTingkat,
    String? promoVoucherNo,
    String? baseDocId,
    String? baseLineDocId,
    int? includeTax,
    String? tovenId,
    String? tbitmId,
    double? discHeaderAmount,
    double? subtotalAfterDiscHeader,
    String? tohemId,
  }) {
    return InvoiceDetailEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toinvId: toinvId ?? this.toinvId,
      lineNum: lineNum ?? this.lineNum,
      docNum: docNum ?? this.docNum,
      idNumber: idNumber ?? this.idNumber,
      toitmId: toitmId ?? this.toitmId,
      quantity: quantity ?? this.quantity,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      discPrctg: discPrctg ?? this.discPrctg,
      discAmount: discAmount ?? this.discAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      taxPrctg: taxPrctg ?? this.taxPrctg,
      promotionType: promotionType ?? this.promotionType,
      promotionId: promotionId ?? this.promotionId,
      remarks: remarks ?? this.remarks,
      editTime: editTime ?? this.editTime,
      cogs: cogs ?? this.cogs,
      tovatId: tovatId ?? this.tovatId,
      promotionTingkat: promotionTingkat ?? this.promotionTingkat,
      promoVoucherNo: promoVoucherNo ?? this.promoVoucherNo,
      baseDocId: baseDocId ?? this.baseDocId,
      baseLineDocId: baseLineDocId ?? this.baseLineDocId,
      includeTax: includeTax ?? this.includeTax,
      tovenId: tovenId ?? this.tovenId,
      tbitmId: tbitmId ?? this.tbitmId,
      discHeaderAmount: discHeaderAmount ?? this.discHeaderAmount,
      subtotalAfterDiscHeader: subtotalAfterDiscHeader ?? this.subtotalAfterDiscHeader,
      tohemId: tohemId ?? this.tohemId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate?.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toinvId': toinvId,
      'lineNum': lineNum,
      'docNum': docNum,
      'idNumber': idNumber,
      'toitmId': toitmId,
      'quantity': quantity,
      'sellingPrice': sellingPrice,
      'discPrctg': discPrctg,
      'discAmount': discAmount,
      'totalAmount': totalAmount,
      'taxPrctg': taxPrctg,
      'promotionType': promotionType,
      'promotionId': promotionId,
      'remarks': remarks,
      'editTime': editTime.millisecondsSinceEpoch,
      'cogs': cogs,
      'tovatId': tovatId,
      'promotionTingkat': promotionTingkat,
      'promoVoucherNo': promoVoucherNo,
      'baseDocId': baseDocId,
      'baseLineDocId': baseLineDocId,
      'includeTax': includeTax,
      'tovenId': tovenId,
      'tbitmId': tbitmId,
      'discHeaderAmount': discHeaderAmount,
      'subtotalAfterDiscHeader': subtotalAfterDiscHeader,
      'tohemId': tohemId,
    };
  }

  factory InvoiceDetailEntity.fromMap(Map<String, dynamic> map) {
    return InvoiceDetailEntity(
      docId: map['docId'] as String,
      createDate: map['createDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int) : null,
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
      toinvId: map['toinvId'] != null ? map['toinvId'] as String : null,
      lineNum: map['lineNum'] as int,
      docNum: map['docNum'] as String,
      idNumber: map['idNumber'] as int,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      sellingPrice: map['sellingPrice'] as double,
      discPrctg: map['discPrctg'] as double,
      discAmount: map['discAmount'] as double,
      totalAmount: map['totalAmount'] as double,
      taxPrctg: map['taxPrctg'] as double,
      promotionType: map['promotionType'] as String,
      promotionId: map['promotionId'] as String,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      editTime: DateTime.fromMillisecondsSinceEpoch(map['editTime'] as int),
      cogs: map['cogs'] as double,
      tovatId: map['tovatId'] != null ? map['tovatId'] as String : null,
      promotionTingkat: map['promotionTingkat'] != null ? map['promotionTingkat'] as String : null,
      promoVoucherNo: map['promoVoucherNo'] != null ? map['promoVoucherNo'] as String : null,
      baseDocId: map['baseDocId'] != null ? map['baseDocId'] as String : null,
      baseLineDocId: map['baseLineDocId'] != null ? map['baseLineDocId'] as String : null,
      includeTax: map['includeTax'] as int,
      tovenId: map['tovenId'] != null ? map['tovenId'] as String : null,
      tbitmId: map['tbitmId'] != null ? map['tbitmId'] as String : null,
      discHeaderAmount: map['discHeaderAmount'] != null ? map['discHeaderAmount'] as double : null,
      subtotalAfterDiscHeader: map['subtotalAfterDiscHeader'] != null ? map['subtotalAfterDiscHeader'] as double : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory InvoiceDetailEntity.fromJson(String source) =>
      InvoiceDetailEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InvoiceDetailEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toinvId: $toinvId, lineNum: $lineNum, docNum: $docNum, idNumber: $idNumber, toitmId: $toitmId, quantity: $quantity, sellingPrice: $sellingPrice, discPrctg: $discPrctg, discAmount: $discAmount, totalAmount: $totalAmount, taxPrctg: $taxPrctg, promotionType: $promotionType, promotionId: $promotionId, remarks: $remarks, editTime: $editTime, cogs: $cogs, tovatId: $tovatId, promotionTingkat: $promotionTingkat, promoVoucherNo: $promoVoucherNo, baseDocId: $baseDocId, baseLineDocId: $baseLineDocId, includeTax: $includeTax, tovenId: $tovenId, tbitmId: $tbitmId, discHeaderAmount: $discHeaderAmount, subtotalAfterDiscHeader: $subtotalAfterDiscHeader, tohemId: $tohemId)';
  }

  @override
  bool operator ==(covariant InvoiceDetailEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toinvId == toinvId &&
        other.lineNum == lineNum &&
        other.docNum == docNum &&
        other.idNumber == idNumber &&
        other.toitmId == toitmId &&
        other.quantity == quantity &&
        other.sellingPrice == sellingPrice &&
        other.discPrctg == discPrctg &&
        other.discAmount == discAmount &&
        other.totalAmount == totalAmount &&
        other.taxPrctg == taxPrctg &&
        other.promotionType == promotionType &&
        other.promotionId == promotionId &&
        other.remarks == remarks &&
        other.editTime == editTime &&
        other.cogs == cogs &&
        other.tovatId == tovatId &&
        other.promotionTingkat == promotionTingkat &&
        other.promoVoucherNo == promoVoucherNo &&
        other.baseDocId == baseDocId &&
        other.baseLineDocId == baseLineDocId &&
        other.includeTax == includeTax &&
        other.tovenId == tovenId &&
        other.tbitmId == tbitmId &&
        other.discHeaderAmount == discHeaderAmount &&
        other.subtotalAfterDiscHeader == subtotalAfterDiscHeader &&
        other.tohemId == tohemId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toinvId.hashCode ^
        lineNum.hashCode ^
        docNum.hashCode ^
        idNumber.hashCode ^
        toitmId.hashCode ^
        quantity.hashCode ^
        sellingPrice.hashCode ^
        discPrctg.hashCode ^
        discAmount.hashCode ^
        totalAmount.hashCode ^
        taxPrctg.hashCode ^
        promotionType.hashCode ^
        promotionId.hashCode ^
        remarks.hashCode ^
        editTime.hashCode ^
        cogs.hashCode ^
        tovatId.hashCode ^
        promotionTingkat.hashCode ^
        promoVoucherNo.hashCode ^
        baseDocId.hashCode ^
        baseLineDocId.hashCode ^
        includeTax.hashCode ^
        tovenId.hashCode ^
        tbitmId.hashCode ^
        discHeaderAmount.hashCode ^
        subtotalAfterDiscHeader.hashCode ^
        tohemId.hashCode;
  }
}
