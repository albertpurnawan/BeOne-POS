import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/item_by_store.dart';

const String tableItemsByStore = "tsitm";

class ItemsByStoreFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toitmId,
    tostrId,
    statusActive,
    activated,
    tovatId,
    tovatIdPur,
    maxStock,
    minStock,
    marginPercentage,
    marginPrice,
    multiplyOrder,
    price,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toitmId = "toitmId";
  static const String tostrId = "tostrId";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
  static const String tovatId = "tovatId";
  static const String tovatIdPur = "tovatIdPur";
  static const String maxStock = "maxstock";
  static const String minStock = "minstock";
  static const String marginPercentage = "marginpercentage";
  static const String marginPrice = "marginprice";
  static const String multiplyOrder = "multiplyorder";
  static const String price = "price";
}

class ItemByStoreModel extends ItemByStoreEntity implements BaseModel {
  ItemByStoreModel(
      {required super.docId,
      required super.createDate,
      required super.updateDate,
      required super.toitmId,
      required super.tostrId,
      required super.statusActive,
      required super.activated,
      required super.tovatId,
      required super.tovatIdPur,
      required super.maxStock,
      required super.minStock,
      required super.marginPercentage,
      required super.marginPrice,
      required super.multiplyOrder,
      required super.price});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toitmId': toitmId,
      'tostrId': tostrId,
      'statusactive': statusActive,
      'activated': activated,
      'tovatId': tovatId,
      'tovatIdPur': tovatIdPur,
      'maxstock': maxStock,
      'minstock': minStock,
      'marginpercentage': marginPercentage,
      'marginprice': marginPrice,
      'multiplyorder': multiplyOrder,
      'price': price,
    };
  }

  factory ItemByStoreModel.fromMapRemote(Map<String, dynamic> map) {
    return ItemByStoreModel.fromMap({
      ...map,
      "toitmId": map['toitmdocid'] != null ? map['toitmdocid'] as String : null,
      "tostrId": map['tostrdocid'] != null ? map['tostrdocid'] as String : null,
      "tovatId": map['tovatdocid'] != null ? map['tovatdocid'] as String : null,
      "tovatIdPur":
          map['tovatdocidPur'] != null ? map['tovatdocidPur'] as String : null,
      "maxstock":
          map['maxstock'] != null ? map['maxstock'].toDouble() as double : null,
      "minstock":
          map['minstock'] != null ? map['minstock'].toDouble() as double : null,
      "price": map['price'] != null ? map['price'].toDouble() as double : null,
      "marginpercentage": map['marginpercentage'] != null
          ? map['marginpercentage'].toDouble() as double
          : null,
      "marginprice": map['marginprice'] != null
          ? map['marginprice'].toDouble() as double
          : null,
    });
  }

  factory ItemByStoreModel.fromMap(Map<String, dynamic> map) {
    return ItemByStoreModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      tovatId: map['tovatId'] != null ? map['tovatId'] as String : null,
      tovatIdPur:
          map['tovatIdPur'] != null ? map['tovatIdPur'] as String : null,
      maxStock: map['maxstock'] != null ? map['maxstock'] as double : null,
      minStock: map['minstock'] != null ? map['minstock'] as double : null,
      marginPercentage: map['marginpercentage'] != null
          ? map['marginpercentage'] as double
          : null,
      marginPrice:
          map['marginprice'] != null ? map['marginprice'] as double : null,
      multiplyOrder:
          map['multiplyorder'] != null ? map['multiplyorder'] as int : null,
      price: map['price'] != null ? map['price'] as double : null,
    );
  }

  factory ItemByStoreModel.fromEntity(ItemByStoreEntity entity) {
    return ItemByStoreModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toitmId: entity.toitmId,
      tostrId: entity.tostrId,
      statusActive: entity.statusActive,
      activated: entity.activated,
      tovatId: entity.tovatId,
      tovatIdPur: entity.tovatIdPur,
      maxStock: entity.maxStock,
      minStock: entity.minStock,
      marginPercentage: entity.marginPercentage,
      marginPrice: entity.marginPrice,
      multiplyOrder: entity.multiplyOrder,
      price: entity.price,
    );
  }
}
