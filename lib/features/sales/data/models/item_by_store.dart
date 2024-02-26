import 'package:pos_fe/core/resources/data_sources_enum.dart';
import 'package:pos_fe/features/sales/domain/entities/item_by_store.dart';

const String tableItemsByStore = "tsitm";

class ItemsByStoreFields {
  static const List<String> values = [];

  static const String id = "_id";
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

class ItemByStoreModel extends ItemByStoreEntity {
  ItemByStoreModel(
      {required super.id,
      required super.docId,
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

  Map<String, dynamic> toMapByDataSource(DataSource dataSource) {
    return <String, dynamic>{
      dataSource == DataSource.local ? '_id' : 'id': id,
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

  factory ItemByStoreModel.fromMapByDataSource(
      DataSource dataSource, Map<String, dynamic> map) {
    return ItemByStoreModel(
      id: map[dataSource == DataSource.local ? '_id' : 'id'] as int,
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as int : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as int : null,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      tovatId: map['tovatId'] != null ? map['tovatId'] as int : null,
      tovatIdPur: map['tovatIdPur'] != null ? map['tovatIdPur'] as int : null,
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
      id: entity.id,
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
