import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/item_master.dart';

const String tableItemMasters = 'toitm';

class ItemMasterFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    itemCode,
    itemName,
    invItem,
    // serialNo,
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
    property1,
    property2,
    property3,
    property4,
    property5,
    property6,
    property7,
    property8,
    property9,
    property10,
    openPrice,
    popItem,
    bpom,
    expDate,
    margin,
    memberDiscount,
    multiplyOrder,
    syncCRM,
    mergeQuantity,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String itemCode = "itemcode";
  static const String itemName = "itemname";
  static const String invItem = "invitem";
  // static const String serialNo = "serialno";
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
  static const String property1 = "property1";
  static const String property2 = "property2";
  static const String property3 = "property3";
  static const String property4 = "property4";
  static const String property5 = "property5";
  static const String property6 = "property6";
  static const String property7 = "property7";
  static const String property8 = "property8";
  static const String property9 = "property9";
  static const String property10 = "property10";
  static const String openPrice = "openprice";
  static const String popItem = "popitem";
  static const String bpom = "bpom";
  static const String expDate = "expdate";
  static const String margin = "margin";
  static const String memberDiscount = "memberdiscount";
  static const String multiplyOrder = "multiplyorder";
  static const String syncCRM = "synccrm";
  static const String mergeQuantity = "mergequantity";
}

class ItemMasterModel extends ItemMasterEntity implements BaseModel {
  ItemMasterModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.itemCode,
    required super.itemName,
    required super.invItem,
    // required super.serialNo,
    required super.tocatId,
    required super.touomId,
    required super.minStock,
    required super.maxStock,
    required super.includeTax,
    required super.remarks,
    required super.statusActive,
    required super.activated,
    required super.isBatch,
    required super.sync,
    required super.internalCode_1,
    required super.internalCode_2,
    required super.property1,
    required super.property2,
    required super.property3,
    required super.property4,
    required super.property5,
    required super.property6,
    required super.property7,
    required super.property8,
    required super.property9,
    required super.property10,
    required super.openPrice,
    required super.popItem,
    required super.bpom,
    required super.expDate,
    required super.margin,
    required super.memberDiscount,
    required super.multiplyOrder,
    required super.syncCRM,
    required super.mergeQuantity,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'itemcode': itemCode,
      'itemname': itemName,
      'invitem': invItem,
      // 'serialno': serialNo,
      'tocatId': tocatId,
      'touomId': touomId,
      'minstock': minStock,
      'maxstock': maxStock,
      'includetax': includeTax,
      'remarks': remarks,
      'statusactive': statusActive,
      'activated': activated,
      'isbatch': isBatch,
      'sync': sync,
      'internalcode_1': internalCode_1,
      'internalcode_2': internalCode_2,
      'property1': property1,
      'property2': property2,
      'property3': property3,
      'property4': property4,
      'property5': property5,
      'property6': property6,
      'property7': property7,
      'property8': property8,
      'property9': property9,
      'property10': property10,
      'openprice': openPrice,
      'popitem': popItem,
      'bpom': bpom,
      'expdate': expDate,
      'margin': margin,
      'memberdiscount': memberDiscount,
      'multiplyorder': multiplyOrder,
      'synccrm': syncCRM,
      'mergequantity': mergeQuantity,
    };
  }

  factory ItemMasterModel.fromMap(Map<String, dynamic> map) {
    return ItemMasterModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      itemCode: map['itemcode'] as String,
      itemName: map['itemname'] as String,
      invItem: map['invitem'] as int,
      // serialNo: map['serialno'] as int,
      tocatId: map['tocatId'] != null ? map['tocatId'] as String : null,
      touomId: map['touomId'] != null ? map['touomId'] as String : null,
      minStock: map['minstock'] as double,
      maxStock: map['maxstock'] as double,
      includeTax: map['includetax'] as int,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      isBatch: map['isbatch'] as int,
      sync: map['sync'] as int,
      internalCode_1: map['internalcode_1'] != null
          ? map['internalcode_1'] as String
          : null,
      internalCode_2: map['internalcode_2'] != null
          ? map['internalcode_2'] as String
          : null,
      property1: null,
      property2: null,
      property3: null,
      property4: null,
      property5: null,
      property6: null,
      property7: null,
      property8: null,
      property9: null,
      property10: null,

      // property1: map['property1'] != null ? map['property1'] as String : null,
      // property2: map['property2'] != null ? map['property2'] as String : null,
      // property3: map['property3'] != null ? map['property3'] as String : null,
      // property4: map['property4'] != null ? map['property4'] as String : null,
      // property5: map['property5'] != null ? map['property5'] as String : null,
      // property6: map['property6'] != null ? map['property6'] as String : null,
      // property7: map['property7'] != null ? map['property7'] as String : null,
      // property8: map['property8'] != null ? map['property8'] as String : null,
      // property9: map['property9'] != null ? map['property9'] as String : null,
      // property10:
      //     map['property10'] != null ? map['property10'] as String : null,
      openPrice: map['openprice'] as int,
      popItem: map['popitem'] as int,
      bpom: map['bpom'] != null ? map['bpom'] as String : null,
      expDate: map['expdate'] != null ? map['expdate'] as String : null,
      margin: map['margin'] != null ? map['margin'] as double : null,
      memberDiscount:
          map['memberdiscount'] != null ? map['memberdiscount'] as int : null,
      multiplyOrder:
          map['multiplyorder'] != null ? map['multiplyorder'] as int : null,
      syncCRM: map['synccrm'] as int,
      mergeQuantity: map['mergequantity'] as int,
    );
  }

  factory ItemMasterModel.fromMapRemote(Map<String, dynamic> map) {
    return ItemMasterModel.fromMap({
      ...map,
      "minstock": map['minstock'].toDouble() as double,
      "maxstock": map['maxstock'].toDouble() as double,
      "margin": map['margin']?.toDouble() as double,
      "tocatId": map['tocatdocid'] != null ? map['tocatdocid'] as String : null,
      "touomId": map['touomdocid'] != null ? map['touomdocid'] as String : null,
    });
  }

  factory ItemMasterModel.fromEntity(ItemMasterEntity entity) {
    return ItemMasterModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      itemCode: entity.itemCode,
      itemName: entity.itemName,
      invItem: entity.invItem,
      // serialNo: entity.serialNo,
      tocatId: entity.tocatId,
      touomId: entity.touomId,
      minStock: entity.minStock,
      maxStock: entity.maxStock,
      includeTax: entity.includeTax,
      remarks: entity.remarks,
      statusActive: entity.statusActive,
      activated: entity.activated,
      isBatch: entity.isBatch,
      sync: entity.sync,
      internalCode_1: entity.internalCode_1,
      internalCode_2: entity.internalCode_2,
      property1: entity.property1,
      property2: entity.property2,
      property3: entity.property3,
      property4: entity.property4,
      property5: entity.property5,
      property6: entity.property6,
      property7: entity.property7,
      property8: entity.property8,
      property9: entity.property9,
      property10: entity.property10,
      openPrice: entity.openPrice,
      popItem: entity.popItem,
      bpom: entity.bpom,
      expDate: entity.expDate,
      margin: entity.margin,
      memberDiscount: entity.memberDiscount,
      multiplyOrder: entity.multiplyOrder,
      syncCRM: entity.syncCRM,
      mergeQuantity: entity.mergeQuantity,
    );
  }
}
