// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PromoGWPDetailEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toprgId;
  final String? toitmId;
  final double quantity;
  final double sellingPrice;
  final double? itemPrice;

  PromoGWPDetailEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toprgId,
    required this.toitmId,
    required this.quantity,
    required this.sellingPrice,
    required this.itemPrice,
  });

  PromoGWPDetailEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toprgId,
    String? toitmId,
    double? quantity,
    double? sellingPrice,
    double? itemPrice,
  }) {
    return PromoGWPDetailEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toprgId: toprgId ?? this.toprgId,
      toitmId: toitmId ?? this.toitmId,
      quantity: quantity ?? this.quantity,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      itemPrice: itemPrice ?? this.itemPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toprgId': toprgId,
      'toitmId': toitmId,
      'quantity': quantity,
      'sellingPrice': sellingPrice,
      'itemPrice': itemPrice,
    };
  }

  factory PromoGWPDetailEntity.fromMap(Map<String, dynamic> map) {
    return PromoGWPDetailEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toprgId: map['toprgId'] != null ? map['toprgId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      sellingPrice: map['sellingPrice'] as double,
      itemPrice: map['itemPrice'] != null ? map['itemPrice'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PromoGWPDetailEntity.fromJson(String source) =>
      PromoGWPDetailEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PromoGWPDetailEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toprgId: $toprgId, toitmId: $toitmId, quantity: $quantity, sellingPrice: $sellingPrice, itemPrice: $itemPrice)';
  }

  @override
  bool operator ==(covariant PromoGWPDetailEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toprgId == toprgId &&
        other.toitmId == toitmId &&
        other.quantity == quantity &&
        other.sellingPrice == sellingPrice &&
        other.itemPrice == itemPrice;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toprgId.hashCode ^
        toitmId.hashCode ^
        quantity.hashCode ^
        sellingPrice.hashCode ^
        itemPrice.hashCode;
  }
}
