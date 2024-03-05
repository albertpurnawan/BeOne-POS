// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CreditMemoPayMeansEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? torinId;
  final int lineNum;
  final String? tpmt3Id;
  final int amount;
  final String? tpmt2Id;
  final String? cardNo;
  final String? cardHolder;
  final double? sisaVoucher;

  CreditMemoPayMeansEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.torinId,
    required this.lineNum,
    required this.tpmt3Id,
    required this.amount,
    required this.tpmt2Id,
    required this.cardNo,
    required this.cardHolder,
    required this.sisaVoucher,
  });

  CreditMemoPayMeansEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? torinId,
    int? lineNum,
    String? tpmt3Id,
    int? amount,
    String? tpmt2Id,
    String? cardNo,
    String? cardHolder,
    double? sisaVoucher,
  }) {
    return CreditMemoPayMeansEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      torinId: torinId ?? this.torinId,
      lineNum: lineNum ?? this.lineNum,
      tpmt3Id: tpmt3Id ?? this.tpmt3Id,
      amount: amount ?? this.amount,
      tpmt2Id: tpmt2Id ?? this.tpmt2Id,
      cardNo: cardNo ?? this.cardNo,
      cardHolder: cardHolder ?? this.cardHolder,
      sisaVoucher: sisaVoucher ?? this.sisaVoucher,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'torinId': torinId,
      'lineNum': lineNum,
      'tpmt3Id': tpmt3Id,
      'amount': amount,
      'tpmt2Id': tpmt2Id,
      'cardNo': cardNo,
      'cardHolder': cardHolder,
      'sisaVoucher': sisaVoucher,
    };
  }

  factory CreditMemoPayMeansEntity.fromMap(Map<String, dynamic> map) {
    return CreditMemoPayMeansEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      torinId: map['torinId'] != null ? map['torinId'] as String : null,
      lineNum: map['lineNum'] as int,
      tpmt3Id: map['tpmt3Id'] != null ? map['tpmt3Id'] as String : null,
      amount: map['amount'] as int,
      tpmt2Id: map['tpmt2Id'] != null ? map['tpmt2Id'] as String : null,
      cardNo: map['cardNo'] != null ? map['cardNo'] as String : null,
      cardHolder:
          map['cardHolder'] != null ? map['cardHolder'] as String : null,
      sisaVoucher:
          map['sisaVoucher'] != null ? map['sisaVoucher'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreditMemoPayMeansEntity.fromJson(String source) =>
      CreditMemoPayMeansEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CreditMemoPayMeansEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, torinId: $torinId, lineNum: $lineNum, tpmt3Id: $tpmt3Id, amount: $amount, tpmt2Id: $tpmt2Id, cardNo: $cardNo, cardHolder: $cardHolder, sisaVoucher: $sisaVoucher)';
  }

  @override
  bool operator ==(covariant CreditMemoPayMeansEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.torinId == torinId &&
        other.lineNum == lineNum &&
        other.tpmt3Id == tpmt3Id &&
        other.amount == amount &&
        other.tpmt2Id == tpmt2Id &&
        other.cardNo == cardNo &&
        other.cardHolder == cardHolder &&
        other.sisaVoucher == sisaVoucher;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        torinId.hashCode ^
        lineNum.hashCode ^
        tpmt3Id.hashCode ^
        amount.hashCode ^
        tpmt2Id.hashCode ^
        cardNo.hashCode ^
        cardHolder.hashCode ^
        sisaVoucher.hashCode;
  }
}
