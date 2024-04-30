// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoBonusMultiItemGetConditionEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? topmiId;
  final String? toitmId;
  final double quantity;
  final double price;
  final double quota;

  PromoBonusMultiItemGetConditionEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.topmiId,
    required this.toitmId,
    required this.quantity,
    required this.price,
    required this.quota,
  });

  PromoBonusMultiItemGetConditionEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? topmiId,
    String? toitmId,
    double? quantity,
    double? price,
    double? quota,
  }) {
    return PromoBonusMultiItemGetConditionEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      topmiId: topmiId ?? this.topmiId,
      toitmId: toitmId ?? this.toitmId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      quota: quota ?? this.quota,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'topmiId': topmiId,
      'toitmId': toitmId,
      'quantity': quantity,
      'price': price,
      'quota': quota,
    };
  }

  factory PromoBonusMultiItemGetConditionEntity.fromMap(
      Map<String, dynamic> map) {
    return PromoBonusMultiItemGetConditionEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      topmiId: map['topmiId'] != null ? map['topmiId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      price: map['price'] as double,
      quota: map['quota'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBonusMultiItemGetConditionEntity.fromJson(String source) =>
      PromoBonusMultiItemGetConditionEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBonusMultiItemGetConditionEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, topmiId: $topmiId, toitmId: $toitmId, quantity: $quantity, price: $price, quota: $quota)';
  }

  @override
  bool operator ==(covariant PromoBonusMultiItemGetConditionEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.topmiId == topmiId &&
        other.toitmId == toitmId &&
        other.quantity == quantity &&
        other.price == price &&
        other.quota == quota;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        topmiId.hashCode ^
        toitmId.hashCode ^
        quantity.hashCode ^
        price.hashCode ^
        quota.hashCode;
  }
}
