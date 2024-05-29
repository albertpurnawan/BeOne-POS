import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/bill_of_material_line_item.dart';

const String tableBOMLineItem = "titt1";

class BillOfMaterialLineItemFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toittId,
    toitmId,
    quantity,
    tcurrId,
    price,
    form,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toittId = "toittId";
  static const String toitmId = "toitmId";
  static const String quantity = "quantity";
  static const String tcurrId = "tcurrId";
  static const String price = "price";
  static const String form = "form";
}

class BillOfMaterialLineItemModel extends BillOfMaterialLineItemEntity
    implements BaseModel {
  BillOfMaterialLineItemModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toittId,
    required super.toitmId,
    required super.quantity,
    required super.tcurrId,
    required super.price,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toittId': toittId,
      'toitmId': toitmId,
      'quantity': quantity,
      'tcurrId': tcurrId,
      'price': price,
      'form': form,
    };
  }

  factory BillOfMaterialLineItemModel.fromMap(Map<String, dynamic> map) {
    return BillOfMaterialLineItemModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toittId: map['toittId'] != null ? map['toittId'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      price: map['price'] as double,
      form: map['form'] as String,
    );
  }

  factory BillOfMaterialLineItemModel.fromMapRemote(Map<String, dynamic> map) {
    return BillOfMaterialLineItemModel.fromMap({
      ...map,
      "toittId": map['toitt_id']?['docid'] != null
          ? map['toitt_id']['docid'] as String
          : null,
      "toitmId": map['toitm_id']?['docid'] != null
          ? map['toitm_id']['docid'] as String
          : null,
      "quantity": map['quantity'].toDouble() as double,
      "tcurrId": map['tcurr_id']?['docid'] != null
          ? map['tcurr_id']['docid'] as String
          : null,
      "price": map['price'].toDouble() as double,
      "form": map['form'].toDouble() as String,
    });
  }

  factory BillOfMaterialLineItemModel.fromEntity(
      BillOfMaterialLineItemEntity entity) {
    return BillOfMaterialLineItemModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toittId: entity.toittId,
      toitmId: entity.toitmId,
      quantity: entity.quantity,
      tcurrId: entity.tcurrId,
      price: entity.price,
      form: entity.form,
    );
  }
}
