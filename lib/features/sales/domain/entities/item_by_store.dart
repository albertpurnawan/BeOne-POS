// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemByStoreEntity {
  final int id;
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final int? toitmId;
  final int? tostrId;
  final int statusActive;
  final int activated;
  final int? tovatId;
  final int? tovatIdPur;
  final double? maxStock;
  final double? minStock;
  final double? marginPercentage;
  final double? marginPrice;
  final int? multiplyOrder;
  final double? price;

  ItemByStoreEntity({
    required this.id,
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toitmId,
    required this.tostrId,
    required this.statusActive,
    required this.activated,
    required this.tovatId,
    required this.tovatIdPur,
    required this.maxStock,
    required this.minStock,
    required this.marginPercentage,
    required this.marginPrice,
    required this.multiplyOrder,
    required this.price,
  });

  ItemByStoreEntity copyWith({
    int? id,
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    int? toitmId,
    int? tostrId,
    int? statusActive,
    int? activated,
    int? tovatId,
    int? tovatIdPur,
    double? maxStock,
    double? minStock,
    double? marginPercentage,
    double? marginPrice,
    int? multiplyOrder,
    double? price,
  }) {
    return ItemByStoreEntity(
      id: id ?? this.id,
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toitmId: toitmId ?? this.toitmId,
      tostrId: tostrId ?? this.tostrId,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
      tovatId: tovatId ?? this.tovatId,
      tovatIdPur: tovatIdPur ?? this.tovatIdPur,
      maxStock: maxStock ?? this.maxStock,
      minStock: minStock ?? this.minStock,
      marginPercentage: marginPercentage ?? this.marginPercentage,
      marginPrice: marginPrice ?? this.marginPrice,
      multiplyOrder: multiplyOrder ?? this.multiplyOrder,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toitmId': toitmId,
      'tostrId': tostrId,
      'statusActive': statusActive,
      'activated': activated,
      'tovatId': tovatId,
      'tovatIdPur': tovatIdPur,
      'maxStock': maxStock,
      'minStock': minStock,
      'marginPercentage': marginPercentage,
      'marginPrice': marginPrice,
      'multiplyOrder': multiplyOrder,
      'price': price,
    };
  }

  factory ItemByStoreEntity.fromMap(Map<String, dynamic> map) {
    return ItemByStoreEntity(
      id: map['id'] as int,
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as int : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as int : null,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      tovatId: map['tovatId'] != null ? map['tovatId'] as int : null,
      tovatIdPur: map['tovatIdPur'] != null ? map['tovatIdPur'] as int : null,
      maxStock: map['maxStock'] != null ? map['maxStock'] as double : null,
      minStock: map['minStock'] != null ? map['minStock'] as double : null,
      marginPercentage: map['marginPercentage'] != null
          ? map['marginPercentage'] as double
          : null,
      marginPrice:
          map['marginPrice'] != null ? map['marginPrice'] as double : null,
      multiplyOrder:
          map['multiplyOrder'] != null ? map['multiplyOrder'] as int : null,
      price: map['price'] != null ? map['price'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemByStoreEntity.fromJson(String source) =>
      ItemByStoreEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemByStoreEntity(id: $id, docId: $docId, createDate: $createDate, updateDate: $updateDate, toitmId: $toitmId, tostrId: $tostrId, statusActive: $statusActive, activated: $activated, tovatId: $tovatId, tovatIdPur: $tovatIdPur, maxStock: $maxStock, minStock: $minStock, marginPercentage: $marginPercentage, marginPrice: $marginPrice, multiplyOrder: $multiplyOrder, price: $price)';
  }

  @override
  bool operator ==(covariant ItemByStoreEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toitmId == toitmId &&
        other.tostrId == tostrId &&
        other.statusActive == statusActive &&
        other.activated == activated &&
        other.tovatId == tovatId &&
        other.tovatIdPur == tovatIdPur &&
        other.maxStock == maxStock &&
        other.minStock == minStock &&
        other.marginPercentage == marginPercentage &&
        other.marginPrice == marginPrice &&
        other.multiplyOrder == multiplyOrder &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toitmId.hashCode ^
        tostrId.hashCode ^
        statusActive.hashCode ^
        activated.hashCode ^
        tovatId.hashCode ^
        tovatIdPur.hashCode ^
        maxStock.hashCode ^
        minStock.hashCode ^
        marginPercentage.hashCode ^
        marginPrice.hashCode ^
        multiplyOrder.hashCode ^
        price.hashCode;
  }
}
