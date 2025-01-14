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
    openPrice,
    tovenId,
    includeTax,
    tovatId,
    taxRate,
    dpp,
    tocatId,
    shortName,
    toplnId,
  ];

  static const String id = "_id";
  static const String itemCode = "itemcode";
  static const String itemName = "itemname";
  static const String barcode = "barcode";
  static const String price = "price";
  static const String toitmId = "toitmId";
  static const String tbitmId = "tbitmId";
  static const String tpln2Id = "tpln2Id";
  static const String openPrice = "openprice";
  static const String tovenId = "tovenId";
  static const String includeTax = "includetax";
  static const String tovatId = "tovatId";
  static const String taxRate = "taxrate";
  static const String dpp = "dpp";
  static const String tocatId = "tocatId";
  static const String shortName = "shortname";
  static const String toplnId = "toplnId";
}

class ItemModel extends ItemEntity implements BaseModel {
  ItemModel({
    required super.id,
    required super.itemName,
    required super.itemCode,
    required super.barcode,
    required super.price,
    required super.toitmId,
    required super.tbitmId,
    required super.tpln2Id,
    required super.openPrice,
    required super.tovenId,
    required super.tovatId,
    required super.taxRate,
    required super.dpp,
    required super.includeTax,
    required super.tocatId,
    required super.shortName,
    required super.toplnId,
  });

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
      'openprice': openPrice,
      'tovenId': tovenId,
      'includetax': includeTax,
      'tovatId': tovatId,
      'taxrate': taxRate,
      'dpp': dpp,
      'tocatId': tocatId,
      'shortname': shortName,
      'toplnId': toplnId,
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
      openPrice: map['openprice'] as int,
      tovenId: map['tovenId'] != null ? map['tovenId'] as String : null,
      includeTax: map['includetax'] as int,
      tovatId: map['tovatId'] as String,
      taxRate: map['taxrate'] as double,
      dpp: map['dpp'] as double,
      tocatId: map['tocatId'] != null ? map['tocatId'] as String : null,
      shortName: map['shortname'] != null ? map['shortname'] as String : null,
      toplnId: map['toplnId'],
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
      openPrice: entity.openPrice,
      tovenId: entity.tovenId,
      includeTax: entity.includeTax,
      tovatId: entity.tovatId,
      taxRate: entity.taxRate,
      dpp: entity.dpp,
      tocatId: entity.tocatId,
      shortName: entity.shortName,
      toplnId: entity.toplnId,
    );
  }
}
