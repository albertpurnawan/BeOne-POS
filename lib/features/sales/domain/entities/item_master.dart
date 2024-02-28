// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemMasterEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String itemCode;
  final String itemName;
  final int invItem;
  final int serialNo;
  final String? tocatId;
  final String? touomId;
  final double minStock;
  final double maxStock;
  final int includeTax;
  final String? remarks;
  final int statusActive;
  final int activated;
  final int isBatch;
  final String? internalCode_1;
  final String? internalCode_2;
  final int openPrice;
  final int popItem;
  final String? bpom;
  final String? expDate;
  final double? margin;
  final int? memberDiscount;
  final int? multiplyOrder;
  final int mergeQuantity;

  ItemMasterEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.itemCode,
    required this.itemName,
    required this.invItem,
    required this.serialNo,
    required this.tocatId,
    required this.touomId,
    required this.minStock,
    required this.maxStock,
    required this.includeTax,
    required this.remarks,
    required this.statusActive,
    required this.activated,
    required this.isBatch,
    required this.internalCode_1,
    required this.internalCode_2,
    required this.openPrice,
    required this.popItem,
    required this.bpom,
    required this.expDate,
    required this.margin,
    required this.memberDiscount,
    required this.multiplyOrder,
    required this.mergeQuantity,
  });

  ItemMasterEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? itemCode,
    String? itemName,
    int? invItem,
    int? serialNo,
    String? tocatId,
    String? touomId,
    double? minStock,
    double? maxStock,
    int? includeTax,
    String? remarks,
    int? statusActive,
    int? activated,
    int? isBatch,
    String? internalCode_1,
    String? internalCode_2,
    int? openPrice,
    int? popItem,
    String? bpom,
    String? expDate,
    double? margin,
    int? memberDiscount,
    int? multiplyOrder,
    int? mergeQuantity,
  }) {
    return ItemMasterEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      itemCode: itemCode ?? this.itemCode,
      itemName: itemName ?? this.itemName,
      invItem: invItem ?? this.invItem,
      serialNo: serialNo ?? this.serialNo,
      tocatId: tocatId ?? this.tocatId,
      touomId: touomId ?? this.touomId,
      minStock: minStock ?? this.minStock,
      maxStock: maxStock ?? this.maxStock,
      includeTax: includeTax ?? this.includeTax,
      remarks: remarks ?? this.remarks,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
      isBatch: isBatch ?? this.isBatch,
      internalCode_1: internalCode_1 ?? this.internalCode_1,
      internalCode_2: internalCode_2 ?? this.internalCode_2,
      openPrice: openPrice ?? this.openPrice,
      popItem: popItem ?? this.popItem,
      bpom: bpom ?? this.bpom,
      expDate: expDate ?? this.expDate,
      margin: margin ?? this.margin,
      memberDiscount: memberDiscount ?? this.memberDiscount,
      multiplyOrder: multiplyOrder ?? this.multiplyOrder,
      mergeQuantity: mergeQuantity ?? this.mergeQuantity,
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
      'serialNo': serialNo,
      'tocatId': tocatId,
      'touomId': touomId,
      'minStock': minStock,
      'maxStock': maxStock,
      'includeTax': includeTax,
      'remarks': remarks,
      'statusActive': statusActive,
      'activated': activated,
      'isBatch': isBatch,
      'internalCode_1': internalCode_1,
      'internalCode_2': internalCode_2,
      'openPrice': openPrice,
      'popItem': popItem,
      'bpom': bpom,
      'expDate': expDate,
      'margin': margin,
      'memberDiscount': memberDiscount,
      'multiplyOrder': multiplyOrder,
      'mergeQuantity': mergeQuantity,
    };
  }

  factory ItemMasterEntity.fromMap(Map<String, dynamic> map) {
    return ItemMasterEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      itemCode: map['itemCode'] as String,
      itemName: map['itemName'] as String,
      invItem: map['invItem'] as int,
      serialNo: map['serialNo'] as int,
      tocatId: map['tocatId'] != null ? map['tocatId'] as String : null,
      touomId: map['touomId'] != null ? map['touomId'] as String : null,
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

  String toJson() => json.encode(toMap());

  factory ItemMasterEntity.fromJson(String source) =>
      ItemMasterEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemMasterEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, itemCode: $itemCode, itemName: $itemName, invItem: $invItem, serialNo: $serialNo, tocatId: $tocatId, touomId: $touomId, minStock: $minStock, maxStock: $maxStock, includeTax: $includeTax, remarks: $remarks, statusActive: $statusActive, activated: $activated, isBatch: $isBatch, internalCode_1: $internalCode_1, internalCode_2: $internalCode_2, openPrice: $openPrice, popItem: $popItem, bpom: $bpom, expDate: $expDate, margin: $margin, memberDiscount: $memberDiscount, multiplyOrder: $multiplyOrder, mergeQuantity: $mergeQuantity)';
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
        other.serialNo == serialNo &&
        other.tocatId == tocatId &&
        other.touomId == touomId &&
        other.minStock == minStock &&
        other.maxStock == maxStock &&
        other.includeTax == includeTax &&
        other.remarks == remarks &&
        other.statusActive == statusActive &&
        other.activated == activated &&
        other.isBatch == isBatch &&
        other.internalCode_1 == internalCode_1 &&
        other.internalCode_2 == internalCode_2 &&
        other.openPrice == openPrice &&
        other.popItem == popItem &&
        other.bpom == bpom &&
        other.expDate == expDate &&
        other.margin == margin &&
        other.memberDiscount == memberDiscount &&
        other.multiplyOrder == multiplyOrder &&
        other.mergeQuantity == mergeQuantity;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        itemCode.hashCode ^
        itemName.hashCode ^
        invItem.hashCode ^
        serialNo.hashCode ^
        tocatId.hashCode ^
        touomId.hashCode ^
        minStock.hashCode ^
        maxStock.hashCode ^
        includeTax.hashCode ^
        remarks.hashCode ^
        statusActive.hashCode ^
        activated.hashCode ^
        isBatch.hashCode ^
        internalCode_1.hashCode ^
        internalCode_2.hashCode ^
        openPrice.hashCode ^
        popItem.hashCode ^
        bpom.hashCode ^
        expDate.hashCode ^
        margin.hashCode ^
        memberDiscount.hashCode ^
        multiplyOrder.hashCode ^
        mergeQuantity.hashCode;
  }
}
