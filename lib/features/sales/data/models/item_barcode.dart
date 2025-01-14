import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/item_barcode.dart';

const String tableItemBarcodes = "tbitm";

class ItemBarcodesFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toitmId,
    barcode,
    statusActive,
    activated,
    quantity,
    touomId,
    dflt,
    form,
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String toitmId = 'toitmId';
  static const String barcode = 'barcode';
  static const String statusActive = 'statusactive';
  static const String activated = 'activated';
  static const String quantity = 'quantity';
  static const String touomId = 'touomId';
  static const String dflt = 'dflt';
  static const String form = 'form';
}

class ItemBarcodeModel extends ItemBarcodeEntity implements BaseModel {
  ItemBarcodeModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toitmId,
    required super.barcode,
    required super.statusActive,
    required super.activated,
    required super.quantity,
    required super.touomId,
    required super.dflt,
    required super.form,
  });

  factory ItemBarcodeModel.fromMapRemote(Map<String, dynamic> map) {
    return ItemBarcodeModel.fromMap({
      ...map,
      "toitmId": map['toitmdocid'] != null ? map['toitmdocid'] as String : null,
      "touomId": map['touomdocid'] != null ? map['touomdocid'] as String : null,
      "quantity": map['quantity'].toDouble() as double,
    });
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toitmId': toitmId,
      'barcode': barcode,
      'statusactive': statusActive,
      'activated': activated,
      'quantity': quantity,
      'touomId': touomId,
      'dflt': dflt,
      'form': form,
    };
  }

  factory ItemBarcodeModel.fromMap(Map<String, dynamic> map) {
    return ItemBarcodeModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      barcode: map['barcode'] as String,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      quantity: map['quantity'] as double,
      touomId: map['touomId'] != null ? map['touomId'] as String : null,
      dflt: map['dflt'] != null ? map['dflt'] as int : null,
      form: map['form'] as String,
    );
  }

  factory ItemBarcodeModel.fromEntity(ItemBarcodeEntity entity) {
    return ItemBarcodeModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toitmId: entity.toitmId,
      barcode: entity.barcode,
      statusActive: entity.statusActive,
      activated: entity.activated,
      quantity: entity.quantity,
      touomId: entity.touomId,
      dflt: entity.dflt,
      form: entity.form,
    );
  }
}
