// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DownPaymentItemsEntity {
  final String docId;
  final DateTime? createDate;
  final DateTime? updateDate;
  final String? toinvId;
  final String docNum;
  final int idNumber;
  final String? toitmId;
  final double quantity;
  final double sellingPrice;
  final double totalAmount;
  // final double taxPrctg;
  final String? remarks;
  final String? tovatId;
  final int includeTax;
  final String? tovenId;
  final String? tbitmId;
  final String? tohemId;
  final String? refpos2;
  final double? qtySelected;
  final int? isSelected;

  DownPaymentItemsEntity({
    required this.docId,
    this.createDate,
    this.updateDate,
    this.toinvId,
    required this.docNum,
    required this.idNumber,
    this.toitmId,
    required this.quantity,
    required this.sellingPrice,
    required this.totalAmount,
    // required this.taxPrctg,
    this.remarks,
    this.tovatId,
    required this.includeTax,
    this.tovenId,
    this.tbitmId,
    this.tohemId,
    this.refpos2,
    this.qtySelected,
    this.isSelected,
  });

  DownPaymentItemsEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toinvId,
    String? docNum,
    int? idNumber,
    String? toitmId,
    double? quantity,
    double? sellingPrice,
    double? totalAmount,
    // double? taxPrctg,
    String? remarks,
    String? tovatId,
    int? includeTax,
    String? tovenId,
    String? tbitmId,
    String? tohemId,
    String? refpos2,
    double? qtySelected,
    int? isSelected,
  }) {
    return DownPaymentItemsEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toinvId: toinvId ?? this.toinvId,
      docNum: docNum ?? this.docNum,
      idNumber: idNumber ?? this.idNumber,
      toitmId: toitmId ?? this.toitmId,
      quantity: quantity ?? this.quantity,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      // taxPrctg: taxPrctg ?? this.taxPrctg,
      remarks: remarks ?? this.remarks,
      tovatId: tovatId ?? this.tovatId,
      includeTax: includeTax ?? this.includeTax,
      tovenId: tovenId ?? this.tovenId,
      tbitmId: tbitmId ?? this.tbitmId,
      tohemId: tohemId ?? this.tohemId,
      refpos2: refpos2 ?? this.refpos2,
      qtySelected: qtySelected ?? this.qtySelected,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate?.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toinvId': toinvId,
      'docNum': docNum,
      'idNumber': idNumber,
      'toitmId': toitmId,
      'quantity': quantity,
      'sellingPrice': sellingPrice,
      'totalAmount': totalAmount,
      // 'taxPrctg': taxPrctg,
      'remarks': remarks,
      'tovatId': tovatId,
      'includeTax': includeTax,
      'tovenId': tovenId,
      'tbitmId': tbitmId,
      'tohemId': tohemId,
      'refpos2': refpos2,
      'qtySelected': qtySelected,
      'isSelected': isSelected,
    };
  }

  factory DownPaymentItemsEntity.fromMap(Map<String, dynamic> map) {
    return DownPaymentItemsEntity(
      docId: map['docId'] as String,
      createDate: map['createDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int) : null,
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
      toinvId: map['toinvId'] != null ? map['toinvId'] as String : null,
      docNum: map['docNum'] as String,
      idNumber: map['idNumber'] as int,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      sellingPrice: map['sellingPrice'] as double,
      totalAmount: map['totalAmount'] as double,
      // taxPrctg: map['taxPrctg'] as double,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      tovatId: map['tovatId'] != null ? map['tovatId'] as String : null,
      includeTax: map['includeTax'] as int,
      tovenId: map['tovenId'] != null ? map['tovenId'] as String : null,
      tbitmId: map['tbitmId'] != null ? map['tbitmId'] as String : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      refpos2: map['refpos2'] != null ? map['refpos2'] as String : null,
      qtySelected: map['qtySelected'] != null ? map['qtySelected'] as double : null,
      isSelected: map['isSelected'] != null ? map['isSelected'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DownPaymentItemsEntity.fromJson(String source) =>
      DownPaymentItemsEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DownPaymentItemsEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toinvId: $toinvId, docNum: $docNum, idNumber: $idNumber, toitmId: $toitmId, quantity: $quantity, sellingPrice: $sellingPrice, totalAmount: $totalAmount, remarks: $remarks, tovatId: $tovatId, includeTax: $includeTax, tovenId: $tovenId, tbitmId: $tbitmId, tohemId: $tohemId, refpos2: $refpos2, qtySelected: $qtySelected, isSelected: $isSelected)';
  }

  @override
  bool operator ==(covariant DownPaymentItemsEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toinvId == toinvId &&
        other.docNum == docNum &&
        other.idNumber == idNumber &&
        other.toitmId == toitmId &&
        other.quantity == quantity &&
        other.sellingPrice == sellingPrice &&
        other.totalAmount == totalAmount &&
        // other.taxPrctg == taxPrctg &&
        other.remarks == remarks &&
        other.tovatId == tovatId &&
        other.includeTax == includeTax &&
        other.tovenId == tovenId &&
        other.tbitmId == tbitmId &&
        other.tohemId == tohemId &&
        other.refpos2 == refpos2 &&
        other.qtySelected == qtySelected &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toinvId.hashCode ^
        docNum.hashCode ^
        idNumber.hashCode ^
        toitmId.hashCode ^
        quantity.hashCode ^
        sellingPrice.hashCode ^
        totalAmount.hashCode ^
        // taxPrctg.hashCode ^
        remarks.hashCode ^
        tovatId.hashCode ^
        includeTax.hashCode ^
        tovenId.hashCode ^
        tbitmId.hashCode ^
        tohemId.hashCode ^
        refpos2.hashCode ^
        qtySelected.hashCode ^
        isSelected.hashCode;
  }
}
