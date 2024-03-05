// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoBertingkatDetailEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprpId;
  final String? toitmId;
  final String promoType;
  final double minQuantity;
  final double promoValue;
  final double? itemPrice;

  PromoBertingkatDetailEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprpId,
    required this.toitmId,
    required this.promoType,
    required this.minQuantity,
    required this.promoValue,
    required this.itemPrice,
  });

  PromoBertingkatDetailEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprpId,
    String? toitmId,
    String? promoType,
    double? minQuantity,
    double? promoValue,
    double? itemPrice,
  }) {
    return PromoBertingkatDetailEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprpId: toprpId ?? this.toprpId,
      toitmId: toitmId ?? this.toitmId,
      promoType: promoType ?? this.promoType,
      minQuantity: minQuantity ?? this.minQuantity,
      promoValue: promoValue ?? this.promoValue,
      itemPrice: itemPrice ?? this.itemPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprpId': toprpId,
      'toitmId': toitmId,
      'promoType': promoType,
      'minQuantity': minQuantity,
      'promoValue': promoValue,
      'itemPrice': itemPrice,
    };
  }

  factory PromoBertingkatDetailEntity.fromMap(Map<String, dynamic> map) {
    return PromoBertingkatDetailEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprpId: map['toprpId'] != null ? map['toprpId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      promoType: map['promoType'] as String,
      minQuantity: map['minQuantity'] as double,
      promoValue: map['promoValue'] as double,
      itemPrice: map['itemPrice'] != null ? map['itemPrice'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBertingkatDetailEntity.fromJson(String source) =>
      PromoBertingkatDetailEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBertingkatDetailEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprpId: $toprpId, toitmId: $toitmId, promoType: $promoType, minQuantity: $minQuantity, promoValue: $promoValue, itemPrice: $itemPrice)';
  }

  @override
  bool operator ==(covariant PromoBertingkatDetailEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprpId == toprpId &&
        other.toitmId == toitmId &&
        other.promoType == promoType &&
        other.minQuantity == minQuantity &&
        other.promoValue == promoValue &&
        other.itemPrice == itemPrice;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprpId.hashCode ^
        toitmId.hashCode ^
        promoType.hashCode ^
        minQuantity.hashCode ^
        promoValue.hashCode ^
        itemPrice.hashCode;
  }
}
