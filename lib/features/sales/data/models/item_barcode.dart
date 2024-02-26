import 'package:pos_fe/core/resources/data_sources_enum.dart';
import 'package:pos_fe/features/sales/domain/entities/item_barcode.dart';

const String tableItemBarcodes = "tbitm";

class ItemBarcodesFields {
  static const List<String> values = [
    id,
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
  ];

  static const String id = 'id';
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
}

class ItemBarcodeModel extends ItemBarcodeEntity {
  ItemBarcodeModel({
    required super.id,
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
  });

  Map<String, dynamic> toMapByDataSource(DataSource dataSource) {
    return <String, dynamic>{
      dataSource == DataSource.local ? '_id' : 'id': id,
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
    };
  }

  factory ItemBarcodeModel.fromMapByDataSource(
      DataSource dataSource, Map<String, dynamic> map) {
    return ItemBarcodeModel(
      id: map[dataSource == DataSource.local ? '_id' : 'id'] as int,
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as int : null,
      barcode: map['barcode'] as String,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      quantity: map['quantity'] as double,
      touomId: map['touomId'] != null ? map['touomId'] as int : null,
      dflt: map['dflt'] != null ? map['dflt'] as int : null,
    );
  }

  factory ItemBarcodeModel.fromEntity(ItemBarcodeEntity entity) {
    return ItemBarcodeModel(
      id: entity.id,
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
    );
  }
}
