// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CreditMemoDetailEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? torinId;
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

  CreditMemoDetailEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.torinId,
    required this.lineNum,
    required this.docNum,
    required this.idNumber,
    required this.toitmId,
    required this.quantity,
    required this.sellingPrice,
    required this.discPrctg,
    required this.discAmount,
    required this.totalAmount,
    required this.taxPrctg,
    required this.promotionType,
    required this.promotionId,
    required this.remarks,
    required this.editTime,
    required this.cogs,
    required this.tovatId,
    required this.promotionTingkat,
    required this.promoVoucherNo,
    required this.baseDocId,
    required this.baseLineDocId,
    required this.includeTax,
    required this.tovenId,
    required this.tbitmId,
  });

  CreditMemoDetailEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? torinId,
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
  }) {
    return CreditMemoDetailEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      torinId: torinId ?? this.torinId,
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
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'torinId': torinId,
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
    };
  }

  factory CreditMemoDetailEntity.fromMap(Map<String, dynamic> map) {
    return CreditMemoDetailEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      torinId: map['torinId'] != null ? map['torinId'] as String : null,
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
      promotionTingkat: map['promotionTingkat'] != null
          ? map['promotionTingkat'] as String
          : null,
      promoVoucherNo: map['promoVoucherNo'] != null
          ? map['promoVoucherNo'] as String
          : null,
      baseDocId: map['baseDocId'] != null ? map['baseDocId'] as String : null,
      baseLineDocId:
          map['baseLineDocId'] != null ? map['baseLineDocId'] as String : null,
      includeTax: map['includeTax'] as int,
      tovenId: map['tovenId'] != null ? map['tovenId'] as String : null,
      tbitmId: map['tbitmId'] != null ? map['tbitmId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreditMemoDetailEntity.fromJson(String source) =>
      CreditMemoDetailEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreditMemoDetailEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, torinId: $torinId, lineNum: $lineNum, docNum: $docNum, idNumber: $idNumber, toitmId: $toitmId, quantity: $quantity, sellingPrice: $sellingPrice, discPrctg: $discPrctg, discAmount: $discAmount, totalAmount: $totalAmount, taxPrctg: $taxPrctg, promotionType: $promotionType, promotionId: $promotionId, remarks: $remarks, editTime: $editTime, cogs: $cogs, tovatId: $tovatId, promotionTingkat: $promotionTingkat, promoVoucherNo: $promoVoucherNo, baseDocId: $baseDocId, baseLineDocId: $baseLineDocId, includeTax: $includeTax, tovenId: $tovenId, tbitmId: $tbitmId)';
  }

  @override
  bool operator ==(covariant CreditMemoDetailEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.torinId == torinId &&
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
        other.tbitmId == tbitmId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        torinId.hashCode ^
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
        tbitmId.hashCode;
  }
}
