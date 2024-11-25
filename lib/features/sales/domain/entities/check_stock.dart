// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CheckStockEntity {
  final String itemCode;
  final String itemName;
  final String storeCode;
  final String storeName;
  final double qtyOnHand;
  final double ordered;
  final double commited;
  final double available;

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
    double? qtyOnHand,
    double? ordered,
    double? commited,
    double? available,
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
      qtyOnHand: map['qtyOnHand'] as double,
      ordered: map['ordered'] as double,
      commited: map['commited'] as double,
      available: map['available'] as double,
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
