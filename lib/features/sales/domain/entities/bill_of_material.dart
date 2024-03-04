// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BillOfMaterialEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toitmId;
  final double quantity;
  final String? touomId;
  final int tipe;
  final String? tcurrId;
  final double price;
  final int statusActive;
  final int sync;

  BillOfMaterialEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toitmId,
    required this.quantity,
    required this.touomId,
    required this.tipe,
    required this.tcurrId,
    required this.price,
    required this.statusActive,
    required this.sync,
  });

  BillOfMaterialEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toitmId,
    double? quantity,
    String? touomId,
    int? tipe,
    String? tcurrId,
    double? price,
    int? statusActive,
    int? sync,
  }) {
    return BillOfMaterialEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toitmId: toitmId ?? this.toitmId,
      quantity: quantity ?? this.quantity,
      touomId: touomId ?? this.touomId,
      tipe: tipe ?? this.tipe,
      tcurrId: tcurrId ?? this.tcurrId,
      price: price ?? this.price,
      statusActive: statusActive ?? this.statusActive,
      sync: sync ?? this.sync,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toitmId': toitmId,
      'quantity': quantity,
      'touomId': touomId,
      'tipe': tipe,
      'tcurrId': tcurrId,
      'price': price,
      'statusActive': statusActive,
      'sync': sync,
    };
  }

  factory BillOfMaterialEntity.fromMap(Map<String, dynamic> map) {
    return BillOfMaterialEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      touomId: map['touomId'] != null ? map['touomId'] as String : null,
      tipe: map['tipe'] as int,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      price: map['price'] as double,
      statusActive: map['statusActive'] as int,
      sync: map['sync'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory BillOfMaterialEntity.fromJson(String source) =>
      BillOfMaterialEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BillOfMaterialEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toitmId: $toitmId, quantity: $quantity, touomId: $touomId, tipe: $tipe, tcurrId: $tcurrId, price: $price, statusActive: $statusActive, sync: $sync)';
  }

  @override
  bool operator ==(covariant BillOfMaterialEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toitmId == toitmId &&
        other.quantity == quantity &&
        other.touomId == touomId &&
        other.tipe == tipe &&
        other.tcurrId == tcurrId &&
        other.price == price &&
        other.statusActive == statusActive &&
        other.sync == sync;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toitmId.hashCode ^
        quantity.hashCode ^
        touomId.hashCode ^
        tipe.hashCode ^
        tcurrId.hashCode ^
        price.hashCode ^
        statusActive.hashCode ^
        sync.hashCode;
  }
}
