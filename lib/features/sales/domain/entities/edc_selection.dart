// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pos_fe/features/sales/domain/entities/credit_card.dart';

class EDCSelectionEntity {
  final String docId;
  final CreditCardEntity creditCard;
  String? tpmt1Id;
  String? tpmt2Id;
  final String cardNoPrefix;
  final String cardNoSuffix;
  String? campaign;
  final double? amount;

  EDCSelectionEntity({
    required this.docId,
    required this.creditCard,
    this.tpmt1Id,
    this.tpmt2Id,
    required this.cardNoPrefix,
    required this.cardNoSuffix,
    this.campaign,
    required this.amount,
  });

  EDCSelectionEntity copyWith({
    String? docId,
    CreditCardEntity? creditCard,
    String? tpmt1Id,
    String? tpmt2Id,
    String? cardNoPrefix,
    String? cardNoSuffix,
    String? campaign,
    double? amount,
  }) {
    return EDCSelectionEntity(
      docId: docId ?? this.docId,
      creditCard: creditCard ?? this.creditCard,
      tpmt1Id: tpmt1Id ?? this.tpmt1Id,
      tpmt2Id: tpmt2Id ?? this.tpmt2Id,
      cardNoPrefix: cardNoPrefix ?? this.cardNoPrefix,
      cardNoSuffix: cardNoSuffix ?? this.cardNoSuffix,
      campaign: campaign ?? this.campaign,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'creditCard': creditCard.toMap(),
      'tpmt1Id': tpmt1Id,
      'tpmt2Id': tpmt2Id,
      'cardNoPrefix': cardNoPrefix,
      'cardNoSuffix': cardNoSuffix,
      'campaign': campaign,
      'amount': amount,
    };
  }

  factory EDCSelectionEntity.fromMap(Map<String, dynamic> map) {
    return EDCSelectionEntity(
      docId: map['docId'] as String,
      creditCard:
          CreditCardEntity.fromMap(map['creditCard'] as Map<String, dynamic>),
      tpmt1Id: map['tpmt1Id'] != null ? map['tpmt1Id'] as String : null,
      tpmt2Id: map['tpmt2Id'] != null ? map['tpmt2Id'] as String : null,
      cardNoPrefix: map['cardNoPrefix'] as String,
      cardNoSuffix: map['cardNoSuffix'] as String,
      campaign: map['campaign'] != null ? map['campaign'] as String : null,
      amount: map['amount'] != null ? map['amount'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EDCSelectionEntity.fromJson(String source) =>
      EDCSelectionEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EDCSelectionEntity(docId: $docId, creditCard: $creditCard, tpmt1Id: $tpmt1Id, tpmt2Id: $tpmt2Id, cardNoPrefix: $cardNoPrefix, cardNoSuffix: $cardNoSuffix, campaign: $campaign, amount: $amount)';
  }

  @override
  bool operator ==(covariant EDCSelectionEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.creditCard == creditCard &&
        other.tpmt1Id == tpmt1Id &&
        other.tpmt2Id == tpmt2Id &&
        other.cardNoPrefix == cardNoPrefix &&
        other.cardNoSuffix == cardNoSuffix &&
        other.campaign == campaign &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        creditCard.hashCode ^
        tpmt1Id.hashCode ^
        tpmt2Id.hashCode ^
        cardNoPrefix.hashCode ^
        cardNoSuffix.hashCode ^
        campaign.hashCode ^
        amount.hashCode;
  }
}
