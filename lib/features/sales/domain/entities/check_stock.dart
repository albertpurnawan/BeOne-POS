// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CheckStockEntity {
  final String itemCode;
  final String itemName;
  final String storeCode;
  final String storeName;
  final int qtyOnHand;
  final int ordered;
  final int commited;
  final int available;

  CheckStockEntity({
    required this.itemCode,
    required this.itemName,
    required this.storeCode,
    required this.storeName,
    required this.qtyOnHand,
    required this.ordered,
    required this.commited,
    required this.available,
  });

  CheckStockEntity copyWith({
    String? itemCode,
    String? itemName,
    String? storeCode,
    String? storeName,
    int? qtyOnHand,
    int? ordered,
    int? commited,
    int? available,
  }) {
    return CheckStockEntity(
      itemCode: itemCode ?? this.itemCode,
      itemName: itemName ?? this.itemName,
      storeCode: storeCode ?? this.storeCode,
      storeName: storeName ?? this.storeName,
      qtyOnHand: qtyOnHand ?? this.qtyOnHand,
      ordered: ordered ?? this.ordered,
      commited: commited ?? this.commited,
      available: available ?? this.available,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemCode': itemCode,
      'itemName': itemName,
      'storeCode': storeCode,
      'storeName': storeName,
      'qtyOnHand': qtyOnHand,
      'ordered': ordered,
      'commited': commited,
      'available': available,
    };
  }

  factory CheckStockEntity.fromMap(Map<String, dynamic> map) {
    return CheckStockEntity(
      itemCode: map['itemCode'] as String,
      itemName: map['itemName'] as String,
      storeCode: map['storeCode'] as String,
      storeName: map['storeName'] as String,
      qtyOnHand: map['qtyOnHand'] as int,
      ordered: map['ordered'] as int,
      commited: map['commited'] as int,
      available: map['available'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CheckStockEntity.fromJson(String source) =>
      CheckStockEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CheckStockEntity(itemCode: $itemCode, itemName: $itemName, storeCode: $storeCode, storeName: $storeName, qtyOnHand: $qtyOnHand, ordered: $ordered, commited: $commited, available: $available)';
  }

  @override
  bool operator ==(covariant CheckStockEntity other) {
    if (identical(this, other)) return true;

    return other.itemCode == itemCode &&
        other.itemName == itemName &&
        other.storeCode == storeCode &&
        other.storeName == storeName &&
        other.qtyOnHand == qtyOnHand &&
        other.ordered == ordered &&
        other.commited == commited &&
        other.available == available;
  }

  @override
  int get hashCode {
    return itemCode.hashCode ^
        itemName.hashCode ^
        storeCode.hashCode ^
        storeName.hashCode ^
        qtyOnHand.hashCode ^
        ordered.hashCode ^
        commited.hashCode ^
        available.hashCode;
  }
}
