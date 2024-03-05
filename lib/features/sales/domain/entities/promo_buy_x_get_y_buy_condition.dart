// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoBuyXGetYBuyConditionEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprbId;
  final String? toitmId;
  final double quantity;
  final double? itemPrice;

  PromoBuyXGetYBuyConditionEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprbId,
    required this.toitmId,
    required this.quantity,
    required this.itemPrice,
  });

  PromoBuyXGetYBuyConditionEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprbId,
    String? toitmId,
    double? quantity,
    double? itemPrice,
  }) {
    return PromoBuyXGetYBuyConditionEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprbId: toprbId ?? this.toprbId,
      toitmId: toitmId ?? this.toitmId,
      quantity: quantity ?? this.quantity,
      itemPrice: itemPrice ?? this.itemPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprbId': toprbId,
      'toitmId': toitmId,
      'quantity': quantity,
      'itemPrice': itemPrice,
    };
  }

  factory PromoBuyXGetYBuyConditionEntity.fromMap(Map<String, dynamic> map) {
    return PromoBuyXGetYBuyConditionEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprbId: map['toprbId'] != null ? map['toprbId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      itemPrice: map['itemPrice'] != null ? map['itemPrice'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoBuyXGetYBuyConditionEntity.fromJson(String source) =>
      PromoBuyXGetYBuyConditionEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoBuyXGetYBuyConditionEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprbId: $toprbId, toitmId: $toitmId, quantity: $quantity, itemPrice: $itemPrice)';
  }

  @override
  bool operator ==(covariant PromoBuyXGetYBuyConditionEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprbId == toprbId &&
        other.toitmId == toitmId &&
        other.quantity == quantity &&
        other.itemPrice == itemPrice;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprbId.hashCode ^
        toitmId.hashCode ^
        quantity.hashCode ^
        itemPrice.hashCode;
  }
}
