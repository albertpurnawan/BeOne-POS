import 'package:pos_fe/features/sales/domain/entities/price_by_item_barcode.dart';

const String tablePricesByItemBarcode = "tpln4";

class PriceByItemBarcodeFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tpln2Id,
    tbitmId,
    tcurrId,
    price,
  ];

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
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tpln2Id,
    required super.tbitmId,
    required super.tcurrId,
    required super.price,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tpln2Id': tpln2Id,
      'tbitmId': tbitmId,
      'tcurrId': tcurrId,
      'price': price,
    };
  }

  factory PriceByItemBarcodeModel.fromMapRemote(Map<String, dynamic> map) {
    return PriceByItemBarcodeModel.fromMap({
      ...map,
      "tpln2Id": map['tpln2Id']?['docid'] != null
          ? map['tpln2Id']['docid'] as String
          : null,
      "tbitmId": map['tbitmId']?['docid'] != null
          ? map['tbitmId']['docid'] as String
          : null,
      "tcurrId": map['tcurrId']?['docid'] != null
          ? map['tcurrId']['docid'] as String
          : null,
    });
  }

  factory PriceByItemBarcodeModel.fromMap(Map<String, dynamic> map) {
    return PriceByItemBarcodeModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tpln2Id: map['tpln2Id'] != null ? map['tpln2Id'] as String : null,
      tbitmId: map['tbitmId'] != null ? map['tbitmId'] as String : null,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      price: map['price'] as int,
    );
  }

  factory PriceByItemBarcodeModel.fromEntity(PriceByItemBarcodeEntity entity) {
    return PriceByItemBarcodeModel(
        docId: entity.docId,
        createDate: entity.createDate,
        updateDate: entity.updateDate,
        tpln2Id: entity.tpln2Id,
        tbitmId: entity.tbitmId,
        tcurrId: entity.tcurrId,
        price: entity.price);
  }
}
