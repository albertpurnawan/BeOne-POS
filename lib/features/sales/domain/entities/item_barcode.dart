// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemBarcodeEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toitmId;
  final String barcode;
  final int statusActive;
  final int activated;
  final double quantity;
  final String? touomId;
  final int? dflt;

  ItemBarcodeEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toitmId,
    required this.barcode,
    required this.statusActive,
    required this.activated,
    required this.quantity,
    required this.touomId,
    required this.dflt,
  });

  ItemBarcodeEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toitmId,
    String? barcode,
    int? statusActive,
    int? activated,
    double? quantity,
    String? touomId,
    int? dflt,
  }) {
    return ItemBarcodeEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toitmId: toitmId ?? this.toitmId,
      barcode: barcode ?? this.barcode,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
      quantity: quantity ?? this.quantity,
      touomId: touomId ?? this.touomId,
      dflt: dflt ?? this.dflt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toitmId': toitmId,
      'barcode': barcode,
      'statusActive': statusActive,
      'activated': activated,
      'quantity': quantity,
      'touomId': touomId,
      'dflt': dflt,
    };
  }

  factory ItemBarcodeEntity.fromMap(Map<String, dynamic> map) {
    return ItemBarcodeEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      barcode: map['barcode'] as String,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      quantity: map['quantity'] as double,
      touomId: map['touomId'] != null ? map['touomId'] as String : null,
      dflt: map['dflt'] != null ? map['dflt'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemBarcodeEntity.fromJson(String source) =>
      ItemBarcodeEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemBarcodeEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toitmId: $toitmId, barcode: $barcode, statusActive: $statusActive, activated: $activated, quantity: $quantity, touomId: $touomId, dflt: $dflt)';
  }

  @override
  bool operator ==(covariant ItemBarcodeEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toitmId == toitmId &&
        other.barcode == barcode &&
        other.statusActive == statusActive &&
        other.activated == activated &&
        other.quantity == quantity &&
        other.touomId == touomId &&
        other.dflt == dflt;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toitmId.hashCode ^
        barcode.hashCode ^
        statusActive.hashCode ^
        activated.hashCode ^
        quantity.hashCode ^
        touomId.hashCode ^
        dflt.hashCode;
  }
}
