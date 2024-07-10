// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemEntity {
  final int? id;
  final String itemName;
  final String itemCode;
  final String barcode;
  final double price;
  final String toitmId;
  final String tbitmId;
  final String tpln2Id;
  final int openPrice;
  final String? tovenId;
  final int includeTax;
  final String tovatId;
  final double taxRate;
  final double dpp;
  final String? tocatId;

  ItemEntity({
    required this.id,
    required this.itemName,
    required this.itemCode,
    required this.barcode,
    required this.price,
    required this.toitmId,
    required this.tbitmId,
    required this.tpln2Id,
    required this.openPrice,
    required this.tovenId,
    required this.includeTax,
    required this.tovatId,
    required this.taxRate,
    required this.dpp,
    required this.tocatId,
  });

  ItemEntity copyWith({
    int? id,
    String? itemName,
    String? itemCode,
    String? barcode,
    double? price,
    String? toitmId,
    String? tbitmId,
    String? tpln2Id,
    int? openPrice,
    String? tovenId,
    int? includeTax,
    String? tovatId,
    double? taxRate,
    double? dpp,
    String? tocatId,
  }) {
    return ItemEntity(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      itemCode: itemCode ?? this.itemCode,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      toitmId: toitmId ?? this.toitmId,
      tbitmId: tbitmId ?? this.tbitmId,
      tpln2Id: tpln2Id ?? this.tpln2Id,
      openPrice: openPrice ?? this.openPrice,
      tovenId: tovenId ?? this.tovenId,
      includeTax: includeTax ?? this.includeTax,
      tovatId: tovatId ?? this.tovatId,
      taxRate: taxRate ?? this.taxRate,
      dpp: dpp ?? this.dpp,
      tocatId: tocatId ?? this.tocatId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'itemName': itemName,
      'itemCode': itemCode,
      'barcode': barcode,
      'price': price,
      'toitmId': toitmId,
      'tbitmId': tbitmId,
      'tpln2Id': tpln2Id,
      'openPrice': openPrice,
      'tovenId': tovenId,
      'includeTax': includeTax,
      'tovatId': tovatId,
      'taxRate': taxRate,
      'dpp': dpp,
      'tocatId': tocatId,
    };
  }

  factory ItemEntity.fromMap(Map<String, dynamic> map) {
    return ItemEntity(
      id: map['id'] != null ? map['id'] as int : null,
      itemName: map['itemName'] as String,
      itemCode: map['itemCode'] as String,
      barcode: map['barcode'] as String,
      price: map['price'] as double,
      toitmId: map['toitmId'] as String,
      tbitmId: map['tbitmId'] as String,
      tpln2Id: map['tpln2Id'] as String,
      openPrice: map['openPrice'] as int,
      tovenId: map['tovenId'] != null ? map['tovenId'] as String : null,
      includeTax: map['includeTax'] as int,
      tovatId: map['tovatId'] as String,
      taxRate: map['taxRate'] as double,
      dpp: map['dpp'] as double,
      tocatId: map['tocatId'] != null ? map['tocatId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemEntity.fromJson(String source) => ItemEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemEntity(id: $id, itemName: $itemName, itemCode: $itemCode, barcode: $barcode, price: $price, toitmId: $toitmId, tbitmId: $tbitmId, tpln2Id: $tpln2Id, openPrice: $openPrice, tovenId: $tovenId, includeTax: $includeTax, tovatId: $tovatId, taxRate: $taxRate, dpp: $dpp, tocatId: $tocatId)';
  }

  @override
  bool operator ==(covariant ItemEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.itemName == itemName &&
        other.itemCode == itemCode &&
        other.barcode == barcode &&
        other.price == price &&
        other.toitmId == toitmId &&
        other.tbitmId == tbitmId &&
        other.tpln2Id == tpln2Id &&
        other.openPrice == openPrice &&
        other.tovenId == tovenId &&
        other.includeTax == includeTax &&
        other.tovatId == tovatId &&
        other.taxRate == taxRate &&
        other.dpp == dpp &&
        other.tocatId == tocatId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        itemName.hashCode ^
        itemCode.hashCode ^
        barcode.hashCode ^
        price.hashCode ^
        toitmId.hashCode ^
        tbitmId.hashCode ^
        tpln2Id.hashCode ^
        openPrice.hashCode ^
        tovenId.hashCode ^
        includeTax.hashCode ^
        tovatId.hashCode ^
        taxRate.hashCode ^
        dpp.hashCode ^
        tocatId.hashCode;
  }
}
