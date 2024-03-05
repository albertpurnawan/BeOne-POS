// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoBertingkatDefaultPriceLevelEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprpId;
  final String promoType;
  final double minQuantity;
  final double promoValue;

  PromoBertingkatDefaultPriceLevelEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprpId,
    required this.promoType,
    required this.minQuantity,
    required this.promoValue,
  });

  PromoBertingkatDefaultPriceLevelEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprpId,
    String? promoType,
    double? minQuantity,
    double? promoValue,
  }) {
    return PromoBertingkatDefaultPriceLevelEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprpId: toprpId ?? this.toprpId,
      promoType: promoType ?? this.promoType,
      minQuantity: minQuantity ?? this.minQuantity,
      promoValue: promoValue ?? this.promoValue,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprpId': toprpId,
      'promoType': promoType,
      'minQuantity': minQuantity,
      'promoValue': promoValue,
    };
  }

  factory PromoBertingkatDefaultPriceLevelEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoBertingkatDefaultPriceLevelEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprpId: map['toprpId'] != null ? map['toprpId'] as String : null,
      promoType: map['promoType'] as String,
      minQuantity: map['minQuantity'] as double,
      promoValue: map['promoValue'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBertingkatDefaultPriceLevelEntity.fromJson(String source) =>
      PromoBertingkatDefaultPriceLevelEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBertingkatDefaultPriceLevelEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprpId: $toprpId, promoType: $promoType, minQuantity: $minQuantity, promoValue: $promoValue)';
  }

  @override
  bool operator ==(covariant PromoBertingkatDefaultPriceLevelEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprpId == toprpId &&
        other.promoType == promoType &&
        other.minQuantity == minQuantity &&
        other.promoValue == promoValue;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprpId.hashCode ^
        promoType.hashCode ^
        minQuantity.hashCode ^
        promoValue.hashCode;
  }
}
