// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PriceByItemBarcodeEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? tpln2Id;
  final String? tbitmId;
  final String? tcurrId;
  final int price;

  PriceByItemBarcodeEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.tpln2Id,
    required this.tbitmId,
    required this.tcurrId,
    required this.price,
  });

  PriceByItemBarcodeEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tpln2Id,
    String? tbitmId,
    String? tcurrId,
    int? price,
  }) {
    return PriceByItemBarcodeEntity(
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
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      tpln2Id: map['tpln2Id'] != null ? map['tpln2Id'] as String : null,
      tbitmId: map['tbitmId'] != null ? map['tbitmId'] as String : null,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      price: map['price'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PriceByItemBarcodeEntity.fromJson(String source) =>
      PriceByItemBarcodeEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PriceByItemBarcodeEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tpln2Id: $tpln2Id, tbitmId: $tbitmId, tcurrId: $tcurrId, price: $price)';
  }

  @override
  bool operator ==(covariant PriceByItemBarcodeEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tpln2Id == tpln2Id &&
        other.tbitmId == tbitmId &&
        other.tcurrId == tcurrId &&
        other.price == price;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        tpln2Id.hashCode ^
        tbitmId.hashCode ^
        tcurrId.hashCode ^
        price.hashCode;
  }
}
