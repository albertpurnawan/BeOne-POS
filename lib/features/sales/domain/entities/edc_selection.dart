// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pos_fe/features/sales/domain/entities/campaign.dart';
import 'package:pos_fe/features/sales/domain/entities/credit_card.dart';

class EDCSelectionEntity {
  final String docId;
  final CreditCardEntity creditCard;
  String? tpmt1Id;
  final String cardNoPrefix;
  final String cardNoSuffix;
  final CampaignEntity? campaign;
  final double? amount;

  EDCSelectionEntity({
    required this.docId,
    required this.creditCard,
    this.tpmt1Id,
    required this.cardNoPrefix,
    required this.cardNoSuffix,
    required this.campaign,
    required this.amount,
  });

  EDCSelectionEntity copyWith({
    String? docId,
    CreditCardEntity? creditCard,
    String? tpmt1Id,
    String? cardNoPrefix,
    String? cardNoSuffix,
    CampaignEntity? campaign,
    double? amount,
  }) {
    return EDCSelectionEntity(
      docId: docId ?? this.docId,
      creditCard: creditCard ?? this.creditCard,
      tpmt1Id: tpmt1Id ?? this.tpmt1Id,
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
      'cardNoPrefix': cardNoPrefix,
      'cardNoSuffix': cardNoSuffix,
      'campaign': campaign?.toMap(),
      'amount': amount,
    };
  }

  factory EDCSelectionEntity.fromMap(Map<String, dynamic> map) {
    return EDCSelectionEntity(
      docId: map['docId'] as String,
      creditCard:
          CreditCardEntity.fromMap(map['creditCard'] as Map<String, dynamic>),
      tpmt1Id: map['tpmt1Id'] != null ? map['tpmt1Id'] as String : null,
      cardNoPrefix: map['cardNoPrefix'] as String,
      cardNoSuffix: map['cardNoSuffix'] as String,
      campaign: map['campaign'] != null
          ? CampaignEntity.fromMap(map['campaign'] as Map<String, dynamic>)
          : null,
      amount: map['amount'] != null ? map['amount'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EDCSelectionEntity.fromJson(String source) =>
      EDCSelectionEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EDCSelectionEntity(docId: $docId, creditCard: $creditCard, tpmt1Id: $tpmt1Id, cardNoPrefix: $cardNoPrefix, cardNoSuffix: $cardNoSuffix, campaign: $campaign, amount: $amount)';
  }

  @override
  bool operator ==(covariant EDCSelectionEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.creditCard == creditCard &&
        other.tpmt1Id == tpmt1Id &&
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
        cardNoPrefix.hashCode ^
        cardNoSuffix.hashCode ^
        campaign.hashCode ^
        amount.hashCode;
  }
}
