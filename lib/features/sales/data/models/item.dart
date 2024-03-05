import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/item.dart';

const String tableItems = 'items';

class ItemFields {
  static const List<String> values = [
    id,
    itemName,
    itemCode,
    barcode,
    price,
    toitmId,
    tbitmId,
    tpln2Id,
  ];

  static const String id = "_id";
  static const String itemCode = "itemcode";
  static const String itemName = "itemname";
  static const String barcode = "barcode";
  static const String price = "price";
  static const String toitmId = "toitmId";
  static const String tbitmId = "tbitmId";
  static const String tpln2Id = "tpln2Id";
}

class ItemModel extends ItemEntity implements BaseModel {
  ItemModel(
      {required super.id,
      required super.itemName,
      required super.itemCode,
      required super.barcode,
      required super.price,
      required super.toitmId,
      required super.tbitmId,
      required super.tpln2Id});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'itemname': itemName,
      'itemcode': itemCode,
      'barcode': barcode,
      'price': price,
      'toitmId': toitmId,
      'tbitmId': tbitmId,
      'tpln2Id': tpln2Id,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] != null ? map['id'] as int : null,
      itemName: map['itemname'] as String,
      itemCode: map['itemcode'] as String,
      barcode: map['barcode'] as String,
      price: map['price'] as double,
      toitmId: map['toitmId'] as String,
      tbitmId: map['tbitmId'] as String,
      tpln2Id: map['tpln2Id'] as String,
    );
  }

  factory ItemModel.fromEntity(ItemEntity entity) {
    return ItemModel(
      id: entity.id,
      itemName: entity.itemName,
      itemCode: entity.itemCode,
      barcode: entity.barcode,
      price: entity.price,
      toitmId: entity.toitmId,
      tbitmId: entity.tbitmId,
      tpln2Id: entity.tpln2Id,
    );
  }
}
