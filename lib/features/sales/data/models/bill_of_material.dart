import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/bill_of_material.dart';

const String tableBillOfMaterial = "toitt";

class BillOfMaterialFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toitmId,
    quantity,
    touomId,
    tipe,
    tcurrId,
    price,
    statusActive,
    sync,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toitmId = "toitmId";
  static const String quantity = "quantity";
  static const String touomId = "touomId";
  static const String tipe = "tipe";
  static const String tcurrId = "tcurrId";
  static const String price = "price";
  static const String statusActive = "statusactive";
  static const String sync = "sync";
}

class BillOfMaterialModel extends BillOfMaterialEntity implements BaseModel {
  BillOfMaterialModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toitmId,
    required super.quantity,
    required super.touomId,
    required super.tipe,
    required super.tcurrId,
    required super.price,
    required super.statusActive,
    required super.sync,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toitmId': toitmId,
      'quantity': quantity,
      'touomId': touomId,
      'tipe': tipe,
      'tcurrId': tcurrId,
      'price': price,
      'statusactive': statusActive,
      'sync': sync,
    };
  }

  factory BillOfMaterialModel.fromMap(Map<String, dynamic> map) {
    return BillOfMaterialModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      touomId: map['touomId'] != null ? map['touomId'] as String : null,
      tipe: map['tipe'] as int,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      price: map['price'] as double,
      statusActive: map['statusactive'] as int,
      sync: map['sync'] as int,
    );
  }

  factory BillOfMaterialModel.fromMapRemote(Map<String, dynamic> map) {
    return BillOfMaterialModel.fromMap({
      ...map,
      "toitmId": map['toitm_id']?['docid'] != null
          ? map['toitm_id']['docid'] as String
          : null,
      "touomId": map['touom_id']?['docid'] != null
          ? map['touom_id']['docid'] as String
          : null,
      "tcurrId": map['tcurr_id']?['docid'] != null
          ? map['tcurr_id']['docid'] as String
          : null,
      "quantity": map['quantity'].toDouble() as double,
      "price": map['price'].toDouble() as double,
    });
  }

  factory BillOfMaterialModel.fromEntity(BillOfMaterialEntity entity) {
    return BillOfMaterialModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toitmId: entity.toitmId,
      quantity: entity.quantity,
      touomId: entity.touomId,
      tipe: entity.tipe,
      tcurrId: entity.tcurrId,
      price: entity.price,
      statusActive: entity.statusActive,
      sync: entity.sync,
    );
  }
}
