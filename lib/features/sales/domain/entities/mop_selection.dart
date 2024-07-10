// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pos_fe/features/sales/domain/entities/credit_card.dart';

class MopSelectionEntity {
  final String tpmt3Id;
  final String tpmt1Id;
  final String mopAlias;
  final double? bankCharge;
  final String? payTypeCode;
  final String description;
  final double? amount;
  final int subType;
  final String? tinv2Id;
  final String? tpmt4Id;
  final String? edcDesc;
  final CreditCardEntity? creditCard;
  final String? cardNo;
  final String? cardHolder;
  final String? rrn;

  MopSelectionEntity({
    required this.tpmt3Id,
    required this.tpmt1Id,
    required this.mopAlias,
    this.bankCharge,
    this.payTypeCode,
    required this.description,
    this.amount,
    required this.subType,
    this.tinv2Id,
    this.tpmt4Id,
    this.edcDesc,
    this.creditCard,
    this.cardNo,
    this.cardHolder,
    this.rrn,
  });

  MopSelectionEntity copyWith({
    String? tpmt3Id,
    String? tpmt1Id,
    String? mopAlias,
    double? bankCharge,
    String? payTypeCode,
    String? description,
    double? amount,
    int? subType,
    String? tinv2Id,
    String? tpmt4Id,
    String? edcDesc,
    CreditCardEntity? creditCard,
    String? cardNo,
    String? cardHolder,
    String? rrn,
  }) {
    return MopSelectionEntity(
      tpmt3Id: tpmt3Id ?? this.tpmt3Id,
      tpmt1Id: tpmt1Id ?? this.tpmt1Id,
      mopAlias: mopAlias ?? this.mopAlias,
      bankCharge: bankCharge ?? this.bankCharge,
      payTypeCode: payTypeCode ?? this.payTypeCode,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      subType: subType ?? this.subType,
      tinv2Id: tinv2Id ?? this.tinv2Id,
      tpmt4Id: tpmt4Id ?? this.tpmt4Id,
      edcDesc: edcDesc ?? this.edcDesc,
      creditCard: creditCard ?? this.creditCard,
      cardNo: cardNo ?? this.cardNo,
      cardHolder: cardHolder ?? this.cardHolder,
      rrn: rrn ?? this.rrn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tpmt3Id': tpmt3Id,
      'tpmt1Id': tpmt1Id,
      'mopAlias': mopAlias,
      'bankCharge': bankCharge,
      'payTypeCode': payTypeCode,
      'description': description,
      'amount': amount,
      'subType': subType,
      'tinv2Id': tinv2Id,
      'tpmt4Id': tpmt4Id,
      'edcDesc': edcDesc,
      'creditCard': creditCard?.toMap(),
      'cardNo': cardNo,
      'cardHolder': cardHolder,
      'rrn': rrn,
    };
  }

  factory MopSelectionEntity.fromMap(Map<String, dynamic> map) {
    return MopSelectionEntity(
      tpmt3Id: map['tpmt3Id'] as String,
      tpmt1Id: map['tpmt1Id'] as String,
      mopAlias: map['mopAlias'] as String,
      bankCharge: map['bankCharge'] != null ? map['bankCharge'] as double : null,
      payTypeCode: map['payTypeCode'] != null ? map['payTypeCode'] as String : null,
      description: map['description'] as String,
      amount: map['amount'] != null ? map['amount'] as double : null,
      subType: map['subType'] as int,
      tinv2Id: map['tinv2Id'] != null ? map['tinv2Id'] as String : null,
      tpmt4Id: map['tpmt4Id'] != null ? map['tpmt4Id'] as String : null,
      edcDesc: map['edcDesc'] != null ? map['edcDesc'] as String : null,
      creditCard: map['creditCard'] != null ? CreditCardEntity.fromMap(map['creditCard'] as Map<String, dynamic>) : null,
      cardNo: map['cardNo'] != null ? map['cardNo'] as String : null,
      cardHolder: map['cardHolder'] != null ? map['cardHolder'] as String : null,
      rrn: map['rrn'] != null ? map['rrn'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MopSelectionEntity.fromJson(String source) => MopSelectionEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MopSelectionEntity(tpmt3Id: $tpmt3Id, tpmt1Id: $tpmt1Id, mopAlias: $mopAlias, bankCharge: $bankCharge, payTypeCode: $payTypeCode, description: $description, amount: $amount, subType: $subType, tinv2Id: $tinv2Id, tpmt4Id: $tpmt4Id, edcDesc: $edcDesc, creditCard: $creditCard, cardNo: $cardNo, cardHolder: $cardHolder, rrn: $rrn)';
  }

  @override
  bool operator ==(covariant MopSelectionEntity other) {
    if (identical(this, other)) return true;

    return other.tpmt3Id == tpmt3Id &&
        other.tpmt1Id == tpmt1Id &&
        other.mopAlias == mopAlias &&
        other.bankCharge == bankCharge &&
        other.payTypeCode == payTypeCode &&
        other.description == description &&
        other.amount == amount &&
        other.subType == subType &&
        other.tinv2Id == tinv2Id &&
        other.tpmt4Id == tpmt4Id &&
        other.edcDesc == edcDesc &&
        other.creditCard == creditCard &&
        other.cardNo == cardNo &&
        other.cardHolder == cardHolder &&
        other.rrn == rrn;
  }

  @override
  int get hashCode {
    return tpmt3Id.hashCode ^
        tpmt1Id.hashCode ^
        mopAlias.hashCode ^
        bankCharge.hashCode ^
        payTypeCode.hashCode ^
        description.hashCode ^
        amount.hashCode ^
        subType.hashCode ^
        tinv2Id.hashCode ^
        tpmt4Id.hashCode ^
        edcDesc.hashCode ^
        creditCard.hashCode ^
        cardNo.hashCode ^
        cardHolder.hashCode ^
        rrn.hashCode;
  }
}
