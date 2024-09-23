// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemMasterEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String itemCode;
  final String itemName;
  final int invItem;
  // final int serialNo;
  final String? tocatId;
  final String? touomId;
  final double minStock;
  final double maxStock;
  final int includeTax;
  final String? remarks;
  final int statusActive;
  final int activated;
  final int isBatch;
  final int sync;
  final String? internalCode_1;
  final String? internalCode_2;
  final String? property1;
  final String? property2;
  final String? property3;
  final String? property4;
  final String? property5;
  final String? property6;
  final String? property7;
  final String? property8;
  final String? property9;
  final String? property10;
  final int openPrice;
  final int popItem;
  final String? bpom;
  final String? expDate;
  final double? margin;
  final int? memberDiscount;
  final int? multiplyOrder;
  final int syncCRM;
  final int mergeQuantity;
  final String form;
  final String? shortName;

  ItemMasterEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.itemCode,
    required this.itemName,
    required this.invItem,
    this.tocatId,
    this.touomId,
    required this.minStock,
    required this.maxStock,
    required this.includeTax,
    this.remarks,
    required this.statusActive,
    required this.activated,
    required this.isBatch,
    required this.sync,
    this.internalCode_1,
    this.internalCode_2,
    this.property1,
    this.property2,
    this.property3,
    this.property4,
    this.property5,
    this.property6,
    this.property7,
    this.property8,
    this.property9,
    this.property10,
    required this.openPrice,
    required this.popItem,
    this.bpom,
    this.expDate,
    this.margin,
    this.memberDiscount,
    this.multiplyOrder,
    required this.syncCRM,
    required this.mergeQuantity,
    required this.form,
    this.shortName,
  });

  ItemMasterEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? itemCode,
    String? itemName,
    int? invItem,
    String? tocatId,
    String? touomId,
    double? minStock,
    double? maxStock,
    int? includeTax,
    String? remarks,
    int? statusActive,
    int? activated,
    int? isBatch,
    int? sync,
    String? internalCode_1,
    String? internalCode_2,
    String? property1,
    String? property2,
    String? property3,
    String? property4,
    String? property5,
    String? property6,
    String? property7,
    String? property8,
    String? property9,
    String? property10,
    int? openPrice,
    int? popItem,
    String? bpom,
    String? expDate,
    double? margin,
    int? memberDiscount,
    int? multiplyOrder,
    int? syncCRM,
    int? mergeQuantity,
    String? form,
    String? shortName,
  }) {
    return ItemMasterEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      itemCode: itemCode ?? this.itemCode,
      itemName: itemName ?? this.itemName,
      invItem: invItem ?? this.invItem,
      tocatId: tocatId ?? this.tocatId,
      touomId: touomId ?? this.touomId,
      minStock: minStock ?? this.minStock,
      maxStock: maxStock ?? this.maxStock,
      includeTax: includeTax ?? this.includeTax,
      remarks: remarks ?? this.remarks,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
      isBatch: isBatch ?? this.isBatch,
      sync: sync ?? this.sync,
      internalCode_1: internalCode_1 ?? this.internalCode_1,
      internalCode_2: internalCode_2 ?? this.internalCode_2,
      property1: property1 ?? this.property1,
      property2: property2 ?? this.property2,
      property3: property3 ?? this.property3,
      property4: property4 ?? this.property4,
      property5: property5 ?? this.property5,
      property6: property6 ?? this.property6,
      property7: property7 ?? this.property7,
      property8: property8 ?? this.property8,
      property9: property9 ?? this.property9,
      property10: property10 ?? this.property10,
      openPrice: openPrice ?? this.openPrice,
      popItem: popItem ?? this.popItem,
      bpom: bpom ?? this.bpom,
      expDate: expDate ?? this.expDate,
      margin: margin ?? this.margin,
      memberDiscount: memberDiscount ?? this.memberDiscount,
      multiplyOrder: multiplyOrder ?? this.multiplyOrder,
      syncCRM: syncCRM ?? this.syncCRM,
      mergeQuantity: mergeQuantity ?? this.mergeQuantity,
      form: form ?? this.form,
      shortName: shortName ?? this.shortName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'itemCode': itemCode,
      'itemName': itemName,
      'invItem': invItem,
      'tocatId': tocatId,
      'touomId': touomId,
      'minStock': minStock,
      'maxStock': maxStock,
      'includeTax': includeTax,
      'remarks': remarks,
      'statusActive': statusActive,
      'activated': activated,
      'isBatch': isBatch,
      'sync': sync,
      'internalCode_1': internalCode_1,
      'internalCode_2': internalCode_2,
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
      'openPrice': openPrice,
      'popItem': popItem,
      'bpom': bpom,
      'expDate': expDate,
      'margin': margin,
      'memberDiscount': memberDiscount,
      'multiplyOrder': multiplyOrder,
      'syncCRM': syncCRM,
      'mergeQuantity': mergeQuantity,
      'form': form,
      'shortName': shortName,
    };
  }

  factory ItemMasterEntity.fromMap(Map<String, dynamic> map) {
    return ItemMasterEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
      itemCode: map['itemCode'] as String,
      itemName: map['itemName'] as String,
      invItem: map['invItem'] as int,
      tocatId: map['tocatId'] != null ? map['tocatId'] as String : null,
      touomId: map['touomId'] != null ? map['touomId'] as String : null,
      minStock: map['minStock'] as double,
      maxStock: map['maxStock'] as double,
      includeTax: map['includeTax'] as int,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      isBatch: map['isBatch'] as int,
      sync: map['sync'] as int,
      internalCode_1: map['internalCode_1'] != null ? map['internalCode_1'] as String : null,
      internalCode_2: map['internalCode_2'] != null ? map['internalCode_2'] as String : null,
      property1: map['property1'] != null ? map['property1'] as String : null,
      property2: map['property2'] != null ? map['property2'] as String : null,
      property3: map['property3'] != null ? map['property3'] as String : null,
      property4: map['property4'] != null ? map['property4'] as String : null,
      property5: map['property5'] != null ? map['property5'] as String : null,
      property6: map['property6'] != null ? map['property6'] as String : null,
      property7: map['property7'] != null ? map['property7'] as String : null,
      property8: map['property8'] != null ? map['property8'] as String : null,
      property9: map['property9'] != null ? map['property9'] as String : null,
      property10: map['property10'] != null ? map['property10'] as String : null,
      openPrice: map['openPrice'] as int,
      popItem: map['popItem'] as int,
      bpom: map['bpom'] != null ? map['bpom'] as String : null,
      expDate: map['expDate'] != null ? map['expDate'] as String : null,
      margin: map['margin'] != null ? map['margin'] as double : null,
      memberDiscount: map['memberDiscount'] != null ? map['memberDiscount'] as int : null,
      multiplyOrder: map['multiplyOrder'] != null ? map['multiplyOrder'] as int : null,
      syncCRM: map['syncCRM'] as int,
      mergeQuantity: map['mergeQuantity'] as int,
      form: map['form'] as String,
      shortName: map['shortName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemMasterEntity.fromJson(String source) =>
      ItemMasterEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemMasterEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, itemCode: $itemCode, itemName: $itemName, invItem: $invItem, tocatId: $tocatId, touomId: $touomId, minStock: $minStock, maxStock: $maxStock, includeTax: $includeTax, remarks: $remarks, statusActive: $statusActive, activated: $activated, isBatch: $isBatch, sync: $sync, internalCode_1: $internalCode_1, internalCode_2: $internalCode_2, property1: $property1, property2: $property2, property3: $property3, property4: $property4, property5: $property5, property6: $property6, property7: $property7, property8: $property8, property9: $property9, property10: $property10, openPrice: $openPrice, popItem: $popItem, bpom: $bpom, expDate: $expDate, margin: $margin, memberDiscount: $memberDiscount, multiplyOrder: $multiplyOrder, syncCRM: $syncCRM, mergeQuantity: $mergeQuantity, form: $form, shortName: $shortName)';
  }

  @override
  bool operator ==(covariant ItemMasterEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.itemCode == itemCode &&
        other.itemName == itemName &&
        other.invItem == invItem &&
        other.tocatId == tocatId &&
        other.touomId == touomId &&
        other.minStock == minStock &&
        other.maxStock == maxStock &&
        other.includeTax == includeTax &&
        other.remarks == remarks &&
        other.statusActive == statusActive &&
        other.activated == activated &&
        other.isBatch == isBatch &&
        other.sync == sync &&
        other.internalCode_1 == internalCode_1 &&
        other.internalCode_2 == internalCode_2 &&
        other.property1 == property1 &&
        other.property2 == property2 &&
        other.property3 == property3 &&
        other.property4 == property4 &&
        other.property5 == property5 &&
        other.property6 == property6 &&
        other.property7 == property7 &&
        other.property8 == property8 &&
        other.property9 == property9 &&
        other.property10 == property10 &&
        other.openPrice == openPrice &&
        other.popItem == popItem &&
        other.bpom == bpom &&
        other.expDate == expDate &&
        other.margin == margin &&
        other.memberDiscount == memberDiscount &&
        other.multiplyOrder == multiplyOrder &&
        other.syncCRM == syncCRM &&
        other.mergeQuantity == mergeQuantity &&
        other.form == form &&
        other.shortName == shortName;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        itemCode.hashCode ^
        itemName.hashCode ^
        invItem.hashCode ^
        tocatId.hashCode ^
        touomId.hashCode ^
        minStock.hashCode ^
        maxStock.hashCode ^
        includeTax.hashCode ^
        remarks.hashCode ^
        statusActive.hashCode ^
        activated.hashCode ^
        isBatch.hashCode ^
        sync.hashCode ^
        internalCode_1.hashCode ^
        internalCode_2.hashCode ^
        property1.hashCode ^
        property2.hashCode ^
        property3.hashCode ^
        property4.hashCode ^
        property5.hashCode ^
        property6.hashCode ^
        property7.hashCode ^
        property8.hashCode ^
        property9.hashCode ^
        property10.hashCode ^
        openPrice.hashCode ^
        popItem.hashCode ^
        bpom.hashCode ^
        expDate.hashCode ^
        margin.hashCode ^
        memberDiscount.hashCode ^
        multiplyOrder.hashCode ^
        syncCRM.hashCode ^
        mergeQuantity.hashCode ^
        form.hashCode ^
        shortName.hashCode;
  }
}
