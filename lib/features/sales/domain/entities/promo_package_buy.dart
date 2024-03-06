// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoPackageBuyEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprkId;
  final String? toitmId;
  final double minQuantity;
  final double? itemPrice;

  PromoPackageBuyEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprkId,
    required this.toitmId,
    required this.minQuantity,
    required this.itemPrice,
  });

  PromoPackageBuyEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprkId,
    String? toitmId,
    double? minQuantity,
    double? itemPrice,
  }) {
    return PromoPackageBuyEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprkId: toprkId ?? this.toprkId,
      toitmId: toitmId ?? this.toitmId,
      minQuantity: minQuantity ?? this.minQuantity,
      itemPrice: itemPrice ?? this.itemPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprkId': toprkId,
      'toitmId': toitmId,
      'minQuantity': minQuantity,
      'itemPrice': itemPrice,
    };
  }

  factory PromoPackageBuyEntity.fromMap(Map<String, dynamic> map) {
    return PromoPackageBuyEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprkId: map['toprkId'] != null ? map['toprkId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      minQuantity: map['minQuantity'] as double,
      itemPrice: map['itemPrice'] != null ? map['itemPrice'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoPackageBuyEntity.fromJson(String source) =>
      PromoPackageBuyEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoPackageBuyEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprkId: $toprkId, toitmId: $toitmId, minQuantity: $minQuantity, itemPrice: $itemPrice)';
  }

  @override
  bool operator ==(covariant PromoPackageBuyEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprkId == toprkId &&
        other.toitmId == toitmId &&
        other.minQuantity == minQuantity &&
        other.itemPrice == itemPrice;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprkId.hashCode ^
        toitmId.hashCode ^
        minQuantity.hashCode ^
        itemPrice.hashCode;
  }
}
