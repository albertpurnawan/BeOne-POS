import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/check_stock.dart';

class CheckStockModel extends CheckStockEntity implements BaseModel {
  CheckStockModel({
    required super.itemCode,
    required super.itemName,
    required super.storeCode,
    required super.storeName,
    required super.qtyOnHand,
    required super.ordered,
    required super.commited,
    required super.available,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'itemcode': itemCode,
      'itemname': itemName,
      'storecode': storeCode,
      'storenname': storeName,
      'qtyonhand': qtyOnHand,
      'ordered': ordered,
      'commited': commited,
      'available': available,
    };
  }

  factory CheckStockModel.fromMap(Map<String, dynamic> map) {
    return CheckStockModel(
      itemCode: map['itemcode'] as String,
      itemName: map['itemname'] as String,
      storeCode: map['storecode'] as String,
      storeName: map['storename'] as String,
      qtyOnHand: map['qtyonhand'] as double,
      ordered: map['ordered'] as int,
      commited: map['commited'] as int,
      available: map['available'] as double,
    );
  }

  factory CheckStockModel.fromMapRemote(Map<String, dynamic> map) {
    return CheckStockModel.fromMap({
      ...map,
      "qtyonhand": map['QtyOnHand'] != null ? map['QtyOnHand'] as double : null,
    });
  }

  factory CheckStockModel.fromEntity(CheckStockEntity entity) {
    return CheckStockModel(
      itemCode: entity.itemCode,
      itemName: entity.itemName,
      storeCode: entity.storeCode,
      storeName: entity.storeName,
      qtyOnHand: entity.qtyOnHand,
      ordered: entity.ordered,
      commited: entity.commited,
      available: entity.available,
    );
  }
}
