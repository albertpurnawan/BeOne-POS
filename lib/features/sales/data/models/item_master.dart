import 'package:pos_fe/features/sales/domain/entities/item_master.dart';

const String tableItemMasters = 'toitm';

class ItemMasterFields {
  static const List<String> values = [
    id,
    docId,
    createDate,
    updateDate,
    itemCode,
    itemName,
    invItem,
    serialNo,
    tocatId,
    touomId,
    minStock,
    maxStock,
    includeTax,
    remarks,
    statusActive,
    activated,
    isBatch,
    sync,
    internalCode_1,
    internalCode_2,
    openPrice,
    popItem,
    bpom,
    expDate,
    margin,
    memberDiscount,
    multiplyOrder,
    mergeQuantity,
  ];

  static const String id = "id";
  static const String docId = "docId";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String itemCode = "itemcode";
  static const String itemName = "itemname";
  static const String invItem = "invitem";
  static const String serialNo = "serialno";
  static const String tocatId = "tocatId";
  static const String touomId = "touomId";
  static const String minStock = "minstock";
  static const String maxStock = "maxstock";
  static const String includeTax = "includetax";
  static const String remarks = "remarks";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
  static const String isBatch = "isbatch";
  static const String sync = "sync";
  static const String internalCode_1 = "internalcode_1";
  static const String internalCode_2 = "internalcode_2";
  static const String openPrice = "openprice";
  static const String popItem = "popitem";
  static const String bpom = "bpom";
  static const String expDate = "expdate";
  static const String margin = "margin";
  static const String memberDiscount = "memberdiscount";
  static const String multiplyOrder = "multiplyorder";
  static const String mergeQuantity = "mergequantity";
}

class ItemMasterModel extends ItemMasterEntity {
  ItemMasterModel({
    required super.id,
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.itemCode,
    required super.itemName,
    required super.invItem,
    required super.serialNo,
    required super.tocatId,
    required super.touomId,
    required super.minStock,
    required super.maxStock,
    required super.includeTax,
    required super.remarks,
    required super.statusActive,
    required super.activated,
    required super.isBatch,
    required super.internalCode_1,
    required super.internalCode_2,
    required super.openPrice,
    required super.popItem,
    required super.bpom,
    required super.expDate,
    required super.margin,
    required super.memberDiscount,
    required super.multiplyOrder,
    required super.mergeQuantity,
  });

  factory ItemMasterModel.fromMap(Map<String, dynamic> map) {
    return ItemMasterModel(
      id: map['_id'] as int,
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int)
          .toLocal(),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
              .toLocal()
          : null,
      itemCode: map['itemCode'] as String,
      itemName: map['itemName'] as String,
      invItem: map['invItem'] as int,
      serialNo: map['serialNo'] as int,
      tocatId: map['tocatId'] != null ? map['tocatId'] as int : null,
      touomId: map['touomId'] != null ? map['touomId'] as int : null,
      minStock: map['minStock'] as double,
      maxStock: map['maxStock'] as double,
      includeTax: map['includeTax'] as int,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      isBatch: map['isBatch'] as int,
      internalCode_1: map['internalCode_1'] != null
          ? map['internalCode_1'] as String
          : null,
      internalCode_2: map['internalCode_2'] != null
          ? map['internalCode_2'] as String
          : null,
      openPrice: map['openPrice'] as int,
      popItem: map['popItem'] as int,
      bpom: map['bpom'] != null ? map['bpom'] as String : null,
      expDate: map['expDate'] != null ? map['expDate'] as String : null,
      margin: map['margin'] != null ? map['margin'] as double : null,
      memberDiscount:
          map['memberDiscount'] != null ? map['memberDiscount'] as int : null,
      multiplyOrder:
          map['multiplyOrder'] != null ? map['multiplyOrder'] as int : null,
      mergeQuantity: map['mergeQuantity'] as int,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'docid': docId,
      'createdate': createDate.toUtc().millisecondsSinceEpoch,
      'updatedate': updateDate?.toUtc().millisecondsSinceEpoch,
      'itemcode': itemCode,
      'itemname': itemName,
      'invitem': invItem,
      'serialno': serialNo,
      'tocatId': tocatId,
      'touomId': touomId,
      'minstock': minStock,
      'maxstock': maxStock,
      'includetax': includeTax,
      'remarks': remarks,
      'statusactive': statusActive,
      'activated': activated,
      'isbatch': isBatch,
      'internalcode_1': internalCode_1,
      'internalcode_2': internalCode_2,
      'openprice': openPrice,
      'popitem': popItem,
      'bpom': bpom,
      'expdate': expDate,
      'margin': margin,
      'memberdiscount': memberDiscount,
      'multiplyorder': multiplyOrder,
      'mergequantity': mergeQuantity,
    };
  }

  factory ItemMasterModel.fromEntity(ItemMasterEntity entity) {
    return ItemMasterModel(
      id: entity.id,
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      itemCode: entity.itemCode,
      itemName: entity.itemName,
      invItem: entity.invItem,
      serialNo: entity.serialNo,
      tocatId: entity.tocatId,
      touomId: entity.touomId,
      minStock: entity.minStock,
      maxStock: entity.maxStock,
      includeTax: entity.includeTax,
      remarks: entity.remarks,
      statusActive: entity.statusActive,
      activated: entity.activated,
      isBatch: entity.isBatch,
      internalCode_1: entity.internalCode_1,
      internalCode_2: entity.internalCode_2,
      openPrice: entity.openPrice,
      popItem: entity.popItem,
      bpom: entity.bpom,
      expDate: entity.expDate,
      margin: entity.margin,
      memberDiscount: entity.memberDiscount,
      multiplyOrder: entity.multiplyOrder,
      mergeQuantity: entity.mergeQuantity,
    );
  }
}
