import 'dart:convert';

import 'package:pos_fe/core/resources/promotion_detail.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PromotionsEntity {
  final String docId;
  final String? toitmId;
  final int promoType;
  final String? promoId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String? tocrgId;
  final String promoDescription;
  final String? tocatId;
  final String? remarks;
  double? discAmount;
  double? discPrctg;
  PromotionDetails? promotionDetails;

  PromotionsEntity({
    required this.docId,
    this.toitmId,
    required this.promoType,
    this.promoId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.tocrgId,
    required this.promoDescription,
    this.tocatId,
    this.remarks,
    this.discAmount,
    this.discPrctg,
    this.promotionDetails,
  });

  PromotionsEntity copyWith({
    String? docId,
    String? toitmId,
    int? promoType,
    String? promoId,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? tocrgId,
    String? promoDescription,
    String? tocatId,
    String? remarks,
    double? discAmount,
    double? discPrctg,
    PromotionDetails? promotionDetails,
  }) {
    return PromotionsEntity(
      docId: docId ?? this.docId,
      toitmId: toitmId ?? this.toitmId,
      promoType: promoType ?? this.promoType,
      promoId: promoId ?? this.promoId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      tocrgId: tocrgId ?? this.tocrgId,
      promoDescription: promoDescription ?? this.promoDescription,
      tocatId: tocatId ?? this.tocatId,
      remarks: remarks ?? this.remarks,
      discAmount: discAmount ?? this.discAmount,
      discPrctg: discPrctg ?? this.discPrctg,
      promotionDetails: promotionDetails ?? this.promotionDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'toitmId': toitmId,
      'promoType': promoType,
      'promoId': promoId,
      'date': date.millisecondsSinceEpoch,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'tocrgId': tocrgId,
      'promoDescription': promoDescription,
      'tocatId': tocatId,
      'remarks': remarks,
      'discAmount': discAmount,
      'discPrctg': discPrctg,
      // 'promotionDetails': promotionDetails?.toMap(),
    };
  }

  factory PromotionsEntity.fromMap(Map<String, dynamic> map) {
    return PromotionsEntity(
      docId: map['docId'] as String,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      promoType: map['promoType'] as int,
      promoId: map['promoId'] != null ? map['promoId'] as String : null,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int),
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
      promoDescription: map['promoDescription'] as String,
      tocatId: map['tocatId'] != null ? map['tocatId'] as String : null,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      discAmount:
          map['discAmount'] != null ? map['discAmount'] as double : null,
      discPrctg: map['discPrctg'] != null ? map['discPrctg'] as double : null,
      // promotionDetails: map['promotionDetails'] != null
      //     ? PromotionDetails.fromMap(
      //         map['promotionDetails'] as Map<String, dynamic>)
      //     : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromotionsEntity.fromJson(String source) =>
      PromotionsEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromotionsEntity(docId: $docId, toitmId: $toitmId, promoType: $promoType, promoId: $promoId, date: $date, startTime: $startTime, endTime: $endTime, tocrgId: $tocrgId, promoDescription: $promoDescription, tocatId: $tocatId, remarks: $remarks, discAmount: $discAmount, discPrctg: $discPrctg)';
  }

  @override
  bool operator ==(covariant PromotionsEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.toitmId == toitmId &&
        other.promoType == promoType &&
        other.promoId == promoId &&
        other.date == date &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.tocrgId == tocrgId &&
        other.promoDescription == promoDescription &&
        other.tocatId == tocatId &&
        other.remarks == remarks &&
        other.discAmount == discAmount &&
        other.discPrctg == discPrctg &&
        other.promotionDetails == promotionDetails;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        toitmId.hashCode ^
        promoType.hashCode ^
        promoId.hashCode ^
        date.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        tocrgId.hashCode ^
        promoDescription.hashCode ^
        tocatId.hashCode ^
        remarks.hashCode ^
        discAmount.hashCode ^
        discPrctg.hashCode ^
        promotionDetails.hashCode;
  }
}
