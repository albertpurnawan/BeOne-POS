import 'package:pos_fe/core/resources/data_sources_enum.dart';
import 'package:pos_fe/features/sales/domain/entities/price_by_item_barcode.dart';

const String tablePricesByItemBarcode = "tpln4";

class PriceByItemBarcodeFields {
  static const List<String> values = [
    id,
    docId,
    createDate,
    updateDate,
    tpln2Id,
    tbitmId,
    tcurrId,
    price,
  ];

  static const String id = '_id';
  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String tpln2Id = 'tpln2Id';
  static const String tbitmId = 'tbitmId';
  static const String tcurrId = 'tcurrId';
  static const String price = 'price';
}

class PriceByItemBarcodeModel extends PriceByItemBarcodeEntity {
  PriceByItemBarcodeModel({
    required super.id,
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tpln2Id,
    required super.tbitmId,
    required super.tcurrId,
    required super.price,
  });

  Map<String, dynamic> toMapByDataSource(DataSource dataSource) {
    return <String, dynamic>{
      dataSource == DataSource.local ? '_id' : 'id': id,
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tpln2Id': tpln2Id,
      'tbitmId': tbitmId,
      'tcurrId': tcurrId,
      'price': price,
    };
  }

  factory PriceByItemBarcodeModel.fromMapByDataSource(
      DataSource dataSource, Map<String, dynamic> map) {
    return PriceByItemBarcodeModel(
      id: map[dataSource == DataSource.local ? '_id' : 'id'] as int,
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tpln2Id: map['tpln2Id'] != null ? map['tpln2Id'] as int : null,
      tbitmId: map['tbitmId'] != null ? map['tbitmId'] as int : null,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as int : null,
      price: map['price'] as int,
    );
  }

  factory PriceByItemBarcodeModel.fromEntity(PriceByItemBarcodeEntity entity) {
    return PriceByItemBarcodeModel(
        id: entity.id,
        docId: entity.docId,
        createDate: entity.createDate,
        updateDate: entity.updateDate,
        tpln2Id: entity.tpln2Id,
        tbitmId: entity.tbitmId,
        tcurrId: entity.tcurrId,
        price: entity.price);
  }
}
