// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BillOfMaterialLineItemEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toittId;
  final String? toitmId;
  final double quantity;
  final String? touomId;
  final String? tcurrId;
  final double price;

  BillOfMaterialLineItemEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toittId,
    required this.toitmId,
    required this.quantity,
    required this.touomId,
    required this.tcurrId,
    required this.price,
  });

  BillOfMaterialLineItemEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toittId,
    String? toitmId,
    double? quantity,
    String? touomId,
    String? tcurrId,
    double? price,
  }) {
    return BillOfMaterialLineItemEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toittId: toittId ?? this.toittId,
      toitmId: toitmId ?? this.toitmId,
      quantity: quantity ?? this.quantity,
      touomId: touomId ?? this.touomId,
      tcurrId: tcurrId ?? this.tcurrId,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toittId': toittId,
      'toitmId': toitmId,
      'quantity': quantity,
      'touomId': touomId,
      'tcurrId': tcurrId,
      'price': price,
    };
  }

  factory BillOfMaterialLineItemEntity.fromMap(Map<String, dynamic> map) {
    return BillOfMaterialLineItemEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toittId: map['toittId'] != null ? map['toittId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      touomId: map['touomId'] != null ? map['touomId'] as String : null,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      price: map['price'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory BillOfMaterialLineItemEntity.fromJson(String source) =>
      BillOfMaterialLineItemEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BillOfMaterialLineItemEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toittId: $toittId, toitmId: $toitmId, quantity: $quantity, touomId: $touomId, tcurrId: $tcurrId, price: $price)';
  }

  @override
  bool operator ==(covariant BillOfMaterialLineItemEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toittId == toittId &&
        other.toitmId == toitmId &&
        other.quantity == quantity &&
        other.touomId == touomId &&
        other.tcurrId == tcurrId &&
        other.price == price;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toittId.hashCode ^
        toitmId.hashCode ^
        quantity.hashCode ^
        touomId.hashCode ^
        tcurrId.hashCode ^
        price.hashCode;
  }
}
