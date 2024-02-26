// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PriceByItemBarcodeEntity {
  final int id;
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final int? tpln2Id;
  final int? tbitmId;
  final int? tcurrId;
  final int price;

  PriceByItemBarcodeEntity({
    required this.id,
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tpln2Id,
    required this.tbitmId,
    required this.tcurrId,
    required this.price,
  });

  PriceByItemBarcodeEntity copyWith({
    int? id,
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    int? tpln2Id,
    int? tbitmId,
    int? tcurrId,
    int? price,
  }) {
    return PriceByItemBarcodeEntity(
      id: id ?? this.id,
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tpln2Id: tpln2Id ?? this.tpln2Id,
      tbitmId: tbitmId ?? this.tbitmId,
      tcurrId: tcurrId ?? this.tcurrId,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tpln2Id': tpln2Id,
      'tbitmId': tbitmId,
      'tcurrId': tcurrId,
      'price': price,
    };
  }

  factory PriceByItemBarcodeEntity.fromMap(Map<String, dynamic> map) {
    return PriceByItemBarcodeEntity(
      id: map['id'] as int,
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tpln2Id: map['tpln2Id'] != null ? map['tpln2Id'] as int : null,
      tbitmId: map['tbitmId'] != null ? map['tbitmId'] as int : null,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as int : null,
      price: map['price'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PriceByItemBarcodeEntity.fromJson(String source) =>
      PriceByItemBarcodeEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PriceByItemBarcodeEntity(id: $id, docId: $docId, createDate: $createDate, updateDate: $updateDate, tpln2Id: $tpln2Id, tbitmId: $tbitmId, tcurrId: $tcurrId, price: $price)';
  }

  @override
  bool operator ==(covariant PriceByItemBarcodeEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tpln2Id == tpln2Id &&
        other.tbitmId == tbitmId &&
        other.tcurrId == tcurrId &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tpln2Id.hashCode ^
        tbitmId.hashCode ^
        tcurrId.hashCode ^
        price.hashCode;
  }
}
