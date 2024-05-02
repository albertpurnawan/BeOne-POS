// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromotionsEntity {
  final String? toitmId;
  final int promoType;
  final String? promoId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String? tocrgId;

  PromotionsEntity({
    required this.toitmId,
    required this.promoType,
    required this.promoId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.tocrgId,
  });

  PromotionsEntity copyWith({
    String? toitmId,
    int? promoType,
    String? promoId,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? tocrgId,
  }) {
    return PromotionsEntity(
      toitmId: toitmId ?? this.toitmId,
      promoType: promoType ?? this.promoType,
      promoId: promoId ?? this.promoId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      tocrgId: tocrgId ?? this.tocrgId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'toitmId': toitmId,
      'promoType': promoType,
      'promoId': promoId,
      'date': date.millisecondsSinceEpoch,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'tocrgId': tocrgId,
    };
  }

  factory PromotionsEntity.fromMap(Map<String, dynamic> map) {
    return PromotionsEntity(
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      promoType: map['promoType'] as int,
      promoId: map['promoId'] != null ? map['promoId'] as String : null,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['endTime'] as int),
      tocrgId: map['tocrgId'] != null ? map['tocrgId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromotionsEntity.fromJson(String source) =>
      PromotionsEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromotionsEntity(toitmId: $toitmId, promoType: $promoType, promoId: $promoId, date: $date, startTime: $startTime, endTime: $endTime, tocrgId: $tocrgId)';
  }

  @override
  bool operator ==(covariant PromotionsEntity other) {
    if (identical(this, other)) return true;

    return other.toitmId == toitmId &&
        other.promoType == promoType &&
        other.promoId == promoId &&
        other.date == date &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.tocrgId == tocrgId;
  }

  @override
  int get hashCode {
    return toitmId.hashCode ^
        promoType.hashCode ^
        promoId.hashCode ^
        date.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        tocrgId.hashCode;
  }
}
