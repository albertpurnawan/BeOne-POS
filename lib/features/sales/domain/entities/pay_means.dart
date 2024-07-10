// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PayMeantEntity {
  final String docId;
  final DateTime? createDate;
  final DateTime? updateDate;
  final String? toinvId;
  final int lineNum;
  final String? tpmt3Id;
  final double amount;
  final String? tpmt2Id;
  final String? cardNo;
  final String? cardHolder;
  final double? sisaVoucher;
  final String? rrn;

  PayMeantEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toinvId,
    required this.lineNum,
    required this.tpmt3Id,
    required this.amount,
    required this.tpmt2Id,
    required this.cardNo,
    required this.cardHolder,
    required this.sisaVoucher,
    required this.rrn,
  });

  PayMeantEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toinvId,
    int? lineNum,
    String? tpmt3Id,
    double? amount,
    String? tpmt2Id,
    String? cardNo,
    String? cardHolder,
    double? sisaVoucher,
    String? rrn,
  }) {
    return PayMeantEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toinvId: toinvId ?? this.toinvId,
      lineNum: lineNum ?? this.lineNum,
      tpmt3Id: tpmt3Id ?? this.tpmt3Id,
      amount: amount ?? this.amount,
      tpmt2Id: tpmt2Id ?? this.tpmt2Id,
      cardNo: cardNo ?? this.cardNo,
      cardHolder: cardHolder ?? this.cardHolder,
      sisaVoucher: sisaVoucher ?? this.sisaVoucher,
      rrn: rrn ?? this.rrn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate?.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toinvId': toinvId,
      'lineNum': lineNum,
      'tpmt3Id': tpmt3Id,
      'amount': amount,
      'tpmt2Id': tpmt2Id,
      'cardNo': cardNo,
      'cardHolder': cardHolder,
      'sisaVoucher': sisaVoucher,
      'rrn': rrn,
    };
  }

  factory PayMeantEntity.fromMap(Map<String, dynamic> map) {
    return PayMeantEntity(
      docId: map['docId'] as String,
      createDate: map['createDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int)
          : null,
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toinvId: map['toinvId'] != null ? map['toinvId'] as String : null,
      lineNum: map['lineNum'] as int,
      tpmt3Id: map['tpmt3Id'] != null ? map['tpmt3Id'] as String : null,
      amount: map['amount'] as double,
      tpmt2Id: map['tpmt2Id'] != null ? map['tpmt2Id'] as String : null,
      cardNo: map['cardNo'] != null ? map['cardNo'] as String : null,
      cardHolder:
          map['cardHolder'] != null ? map['cardHolder'] as String : null,
      sisaVoucher:
          map['sisaVoucher'] != null ? map['sisaVoucher'] as double : null,
      rrn: map['rrn'] != null ? map['rrn'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PayMeantEntity.fromJson(String source) =>
      PayMeantEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PayMeantEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toinvId: $toinvId, lineNum: $lineNum, tpmt3Id: $tpmt3Id, amount: $amount, tpmt2Id: $tpmt2Id, cardNo: $cardNo, cardHolder: $cardHolder, sisaVoucher: $sisaVoucher, rrn: $rrn)';
  }

  @override
  bool operator ==(covariant PayMeantEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toinvId == toinvId &&
        other.lineNum == lineNum &&
        other.tpmt3Id == tpmt3Id &&
        other.amount == amount &&
        other.tpmt2Id == tpmt2Id &&
        other.cardNo == cardNo &&
        other.cardHolder == cardHolder &&
        other.sisaVoucher == sisaVoucher &&
        other.rrn == rrn;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toinvId.hashCode ^
        lineNum.hashCode ^
        tpmt3Id.hashCode ^
        amount.hashCode ^
        tpmt2Id.hashCode ^
        cardNo.hashCode ^
        cardHolder.hashCode ^
        sisaVoucher.hashCode ^
        rrn.hashCode;
  }
}
