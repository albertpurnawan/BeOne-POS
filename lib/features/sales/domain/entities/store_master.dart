// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StoreMasterEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String storeCode;
  final String storeName;
  final String email;
  final String phone;
  final String addr1;
  final String? addr2;
  final String? addr3;
  final String city;
  final String? remarks;
  final String? toprvId;
  final String? tocryId;
  final String? tozcdlId;
  final String? tohemId;
  final double sqm;
  final String? tcurrId;
  final String? toplnId;
  final dynamic storePic;
  final String? tovatId;
  final DateTime storeOpen;
  final int statusActive;
  final int activated;
  final String? prefixDoc;
  final String? header01;
  final String? header02;
  final String? header03;
  final String? header04;
  final String? header05;
  final String? footer01;
  final String? footer02;
  final String? footer03;
  final String? footer04;
  final String? footer05;
  final double? sellingTax;
  final double? openingBalance;
  final int? autoRounding;
  final double? roundingValue;
  final int? totalMinus;
  final int? totalZero;
  final int? holdStruck;
  final int? holdClose;
  final int? autoPrintStruk;
  final String? barcode1;
  final int? barcode2;
  final int? barcode3;
  final int? barcode4;
  final int? connectBack;
  final int? maxUserKassa;
  final double stockLevel;
  final double minConst;
  final double maxConst;
  final int orderCycle;
  final int taxBy;
  final String? tpmt1Id;
  final String? mtxline01;
  final String? mtxline02;
  final String? mtxline03;
  final String? mtxline04;
  final String? storeEpicPath;
  final int attendaceFp;
  final int autoDownload;
  final DateTime? autoDownload1;
  final DateTime? autoDownload2;
  final DateTime? autoDownload3;
  final int autoSync;
  final int autoUpload;
  final int checkSellingPrice;
  final int checkStockMinus;
  final String? creditTaxCodeId;
  final int maxVoidDays;
  final int qtyMinusValidation;
  final String? roundingRemarks;
  final int searchItem;
  final String? vdfLine1;
  final String? vdfLine1Off;
  final String? vdfLine2;
  final String? vdfLine2Off;
  final int isStore;

  StoreMasterEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.storeCode,
    required this.storeName,
    required this.email,
    required this.phone,
    required this.addr1,
    required this.addr2,
    required this.addr3,
    required this.city,
    required this.remarks,
    required this.toprvId,
    required this.tocryId,
    required this.tozcdlId,
    required this.tohemId,
    required this.sqm,
    required this.tcurrId,
    required this.toplnId,
    required this.storePic,
    required this.tovatId,
    required this.storeOpen,
    required this.statusActive,
    required this.activated,
    required this.prefixDoc,
    required this.header01,
    required this.header02,
    required this.header03,
    required this.header04,
    required this.header05,
    required this.footer01,
    required this.footer02,
    required this.footer03,
    required this.footer04,
    required this.footer05,
    required this.sellingTax,
    required this.openingBalance,
    required this.autoRounding,
    required this.roundingValue,
    required this.totalMinus,
    required this.totalZero,
    required this.holdStruck,
    required this.holdClose,
    required this.autoPrintStruk,
    required this.barcode1,
    required this.barcode2,
    required this.barcode3,
    required this.barcode4,
    required this.connectBack,
    required this.maxUserKassa,
    required this.stockLevel,
    required this.minConst,
    required this.maxConst,
    required this.orderCycle,
    required this.taxBy,
    required this.tpmt1Id,
    required this.mtxline01,
    required this.mtxline02,
    required this.mtxline03,
    required this.mtxline04,
    required this.storeEpicPath,
    required this.attendaceFp,
    required this.autoDownload,
    required this.autoDownload1,
    required this.autoDownload2,
    required this.autoDownload3,
    required this.autoSync,
    required this.autoUpload,
    required this.checkSellingPrice,
    required this.checkStockMinus,
    required this.creditTaxCodeId,
    required this.maxVoidDays,
    required this.qtyMinusValidation,
    required this.roundingRemarks,
    required this.searchItem,
    required this.vdfLine1,
    required this.vdfLine1Off,
    required this.vdfLine2,
    required this.vdfLine2Off,
    required this.isStore,
  });

  StoreMasterEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? storeCode,
    String? storeName,
    String? email,
    String? phone,
    String? addr1,
    String? addr2,
    String? addr3,
    String? city,
    String? remarks,
    String? toprvId,
    String? tocryId,
    String? tozcdlId,
    String? tohemId,
    double? sqm,
    String? tcurrId,
    String? toplnId,
    dynamic? storePic,
    String? tovatId,
    DateTime? storeOpen,
    int? statusActive,
    int? activated,
    String? prefixDoc,
    String? header01,
    String? header02,
    String? header03,
    String? header04,
    String? header05,
    String? footer01,
    String? footer02,
    String? footer03,
    String? footer04,
    String? footer05,
    double? sellingTax,
    double? openingBalance,
    int? autoRounding,
    double? roundingValue,
    int? totalMinus,
    int? totalZero,
    int? holdStruck,
    int? holdClose,
    int? autoPrintStruk,
    String? barcode1,
    int? barcode2,
    int? barcode3,
    int? barcode4,
    int? connectBack,
    int? maxUserKassa,
    double? stockLevel,
    double? minConst,
    double? maxConst,
    int? orderCycle,
    int? taxBy,
    String? tpmt1Id,
    String? mtxline01,
    String? mtxline02,
    String? mtxline03,
    String? mtxline04,
    String? storeEpicPath,
    int? attendaceFp,
    int? autoDownload,
    DateTime? autoDownload1,
    DateTime? autoDownload2,
    DateTime? autoDownload3,
    int? autoSync,
    int? autoUpload,
    int? checkSellingPrice,
    int? checkStockMinus,
    String? creditTaxCodeId,
    int? maxVoidDays,
    int? qtyMinusValidation,
    String? roundingRemarks,
    int? searchItem,
    String? vdfLine1,
    String? vdfLine1Off,
    String? vdfLine2,
    String? vdfLine2Off,
    int? isStore,
  }) {
    return StoreMasterEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      storeCode: storeCode ?? this.storeCode,
      storeName: storeName ?? this.storeName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      addr1: addr1 ?? this.addr1,
      addr2: addr2 ?? this.addr2,
      addr3: addr3 ?? this.addr3,
      city: city ?? this.city,
      remarks: remarks ?? this.remarks,
      toprvId: toprvId ?? this.toprvId,
      tocryId: tocryId ?? this.tocryId,
      tozcdlId: tozcdlId ?? this.tozcdlId,
      tohemId: tohemId ?? this.tohemId,
      sqm: sqm ?? this.sqm,
      tcurrId: tcurrId ?? this.tcurrId,
      toplnId: toplnId ?? this.toplnId,
      storePic: storePic ?? this.storePic,
      tovatId: tovatId ?? this.tovatId,
      storeOpen: storeOpen ?? this.storeOpen,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
      prefixDoc: prefixDoc ?? this.prefixDoc,
      header01: header01 ?? this.header01,
      header02: header02 ?? this.header02,
      header03: header03 ?? this.header03,
      header04: header04 ?? this.header04,
      header05: header05 ?? this.header05,
      footer01: footer01 ?? this.footer01,
      footer02: footer02 ?? this.footer02,
      footer03: footer03 ?? this.footer03,
      footer04: footer04 ?? this.footer04,
      footer05: footer05 ?? this.footer05,
      sellingTax: sellingTax ?? this.sellingTax,
      openingBalance: openingBalance ?? this.openingBalance,
      autoRounding: autoRounding ?? this.autoRounding,
      roundingValue: roundingValue ?? this.roundingValue,
      totalMinus: totalMinus ?? this.totalMinus,
      totalZero: totalZero ?? this.totalZero,
      holdStruck: holdStruck ?? this.holdStruck,
      holdClose: holdClose ?? this.holdClose,
      autoPrintStruk: autoPrintStruk ?? this.autoPrintStruk,
      barcode1: barcode1 ?? this.barcode1,
      barcode2: barcode2 ?? this.barcode2,
      barcode3: barcode3 ?? this.barcode3,
      barcode4: barcode4 ?? this.barcode4,
      connectBack: connectBack ?? this.connectBack,
      maxUserKassa: maxUserKassa ?? this.maxUserKassa,
      stockLevel: stockLevel ?? this.stockLevel,
      minConst: minConst ?? this.minConst,
      maxConst: maxConst ?? this.maxConst,
      orderCycle: orderCycle ?? this.orderCycle,
      taxBy: taxBy ?? this.taxBy,
      tpmt1Id: tpmt1Id ?? this.tpmt1Id,
      mtxline01: mtxline01 ?? this.mtxline01,
      mtxline02: mtxline02 ?? this.mtxline02,
      mtxline03: mtxline03 ?? this.mtxline03,
      mtxline04: mtxline04 ?? this.mtxline04,
      storeEpicPath: storeEpicPath ?? this.storeEpicPath,
      attendaceFp: attendaceFp ?? this.attendaceFp,
      autoDownload: autoDownload ?? this.autoDownload,
      autoDownload1: autoDownload1 ?? this.autoDownload1,
      autoDownload2: autoDownload2 ?? this.autoDownload2,
      autoDownload3: autoDownload3 ?? this.autoDownload3,
      autoSync: autoSync ?? this.autoSync,
      autoUpload: autoUpload ?? this.autoUpload,
      checkSellingPrice: checkSellingPrice ?? this.checkSellingPrice,
      checkStockMinus: checkStockMinus ?? this.checkStockMinus,
      creditTaxCodeId: creditTaxCodeId ?? this.creditTaxCodeId,
      maxVoidDays: maxVoidDays ?? this.maxVoidDays,
      qtyMinusValidation: qtyMinusValidation ?? this.qtyMinusValidation,
      roundingRemarks: roundingRemarks ?? this.roundingRemarks,
      searchItem: searchItem ?? this.searchItem,
      vdfLine1: vdfLine1 ?? this.vdfLine1,
      vdfLine1Off: vdfLine1Off ?? this.vdfLine1Off,
      vdfLine2: vdfLine2 ?? this.vdfLine2,
      vdfLine2Off: vdfLine2Off ?? this.vdfLine2Off,
      isStore: isStore ?? this.isStore,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'storeCode': storeCode,
      'storeName': storeName,
      'email': email,
      'phone': phone,
      'addr1': addr1,
      'addr2': addr2,
      'addr3': addr3,
      'city': city,
      'remarks': remarks,
      'toprvId': toprvId,
      'tocryId': tocryId,
      'tozcdlId': tozcdlId,
      'tohemId': tohemId,
      'sqm': sqm,
      'tcurrId': tcurrId,
      'toplnId': toplnId,
      'storePic': storePic,
      'tovatId': tovatId,
      'storeOpen': storeOpen.millisecondsSinceEpoch,
      'statusActive': statusActive,
      'activated': activated,
      'prefixDoc': prefixDoc,
      'header01': header01,
      'header02': header02,
      'header03': header03,
      'header04': header04,
      'header05': header05,
      'footer01': footer01,
      'footer02': footer02,
      'footer03': footer03,
      'footer04': footer04,
      'footer05': footer05,
      'sellingTax': sellingTax,
      'openingBalance': openingBalance,
      'autoRounding': autoRounding,
      'roundingValue': roundingValue,
      'totalMinus': totalMinus,
      'totalZero': totalZero,
      'holdStruck': holdStruck,
      'holdClose': holdClose,
      'autoPrintStruk': autoPrintStruk,
      'barcode1': barcode1,
      'barcode2': barcode2,
      'barcode3': barcode3,
      'barcode4': barcode4,
      'connectBack': connectBack,
      'maxUserKassa': maxUserKassa,
      'stockLevel': stockLevel,
      'minConst': minConst,
      'maxConst': maxConst,
      'orderCycle': orderCycle,
      'taxBy': taxBy,
      'tpmt1Id': tpmt1Id,
      'mtxline01': mtxline01,
      'mtxline02': mtxline02,
      'mtxline03': mtxline03,
      'mtxline04': mtxline04,
      'storeEpicPath': storeEpicPath,
      'attendaceFp': attendaceFp,
      'autoDownload': autoDownload,
      'autoDownload1': autoDownload1?.millisecondsSinceEpoch,
      'autoDownload2': autoDownload2?.millisecondsSinceEpoch,
      'autoDownload3': autoDownload3?.millisecondsSinceEpoch,
      'autoSync': autoSync,
      'autoUpload': autoUpload,
      'checkSellingPrice': checkSellingPrice,
      'checkStockMinus': checkStockMinus,
      'creditTaxCodeId': creditTaxCodeId,
      'maxVoidDays': maxVoidDays,
      'qtyMinusValidation': qtyMinusValidation,
      'roundingRemarks': roundingRemarks,
      'searchItem': searchItem,
      'vdfLine1': vdfLine1,
      'vdfLine1Off': vdfLine1Off,
      'vdfLine2': vdfLine2,
      'vdfLine2Off': vdfLine2Off,
      'isStore': isStore,
    };
  }

  factory StoreMasterEntity.fromMap(Map<String, dynamic> map) {
    return StoreMasterEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      storeCode: map['storeCode'] as String,
      storeName: map['storeName'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      addr1: map['addr1'] as String,
      addr2: map['addr2'] != null ? map['addr2'] as String : null,
      addr3: map['addr3'] != null ? map['addr3'] as String : null,
      city: map['city'] as String,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      toprvId: map['toprvId'] != null ? map['toprvId'] as String : null,
      tocryId: map['tocryId'] != null ? map['tocryId'] as String : null,
      tozcdlId: map['tozcdlId'] != null ? map['tozcdlId'] as String : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      sqm: map['sqm'] as double,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
      storePic: map['storePic'] as dynamic,
      tovatId: map['tovatId'] != null ? map['tovatId'] as String : null,
      storeOpen: DateTime.fromMillisecondsSinceEpoch(map['storeOpen'] as int),
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
      prefixDoc: map['prefixDoc'] != null ? map['prefixDoc'] as String : null,
      header01: map['header01'] != null ? map['header01'] as String : null,
      header02: map['header02'] != null ? map['header02'] as String : null,
      header03: map['header03'] != null ? map['header03'] as String : null,
      header04: map['header04'] != null ? map['header04'] as String : null,
      header05: map['header05'] != null ? map['header05'] as String : null,
      footer01: map['footer01'] != null ? map['footer01'] as String : null,
      footer02: map['footer02'] != null ? map['footer02'] as String : null,
      footer03: map['footer03'] != null ? map['footer03'] as String : null,
      footer04: map['footer04'] != null ? map['footer04'] as String : null,
      footer05: map['footer05'] != null ? map['footer05'] as String : null,
      sellingTax:
          map['sellingTax'] != null ? map['sellingTax'] as double : null,
      openingBalance: map['openingBalance'] != null
          ? map['openingBalance'] as double
          : null,
      autoRounding:
          map['autoRounding'] != null ? map['autoRounding'] as int : null,
      roundingValue:
          map['roundingValue'] != null ? map['roundingValue'] as double : null,
      totalMinus: map['totalMinus'] != null ? map['totalMinus'] as int : null,
      totalZero: map['totalZero'] != null ? map['totalZero'] as int : null,
      holdStruck: map['holdStruck'] != null ? map['holdStruck'] as int : null,
      holdClose: map['holdClose'] != null ? map['holdClose'] as int : null,
      autoPrintStruk:
          map['autoPrintStruk'] != null ? map['autoPrintStruk'] as int : null,
      barcode1: map['barcode1'] != null ? map['barcode1'] as String : null,
      barcode2: map['barcode2'] != null ? map['barcode2'] as int : null,
      barcode3: map['barcode3'] != null ? map['barcode3'] as int : null,
      barcode4: map['barcode4'] != null ? map['barcode4'] as int : null,
      connectBack:
          map['connectBack'] != null ? map['connectBack'] as int : null,
      maxUserKassa:
          map['maxUserKassa'] != null ? map['maxUserKassa'] as int : null,
      stockLevel: map['stockLevel'] as double,
      minConst: map['minConst'] as double,
      maxConst: map['maxConst'] as double,
      orderCycle: map['orderCycle'] as int,
      taxBy: map['taxBy'] as int,
      tpmt1Id: map['tpmt1Id'] != null ? map['tpmt1Id'] as String : null,
      mtxline01: map['mtxline01'] != null ? map['mtxline01'] as String : null,
      mtxline02: map['mtxline02'] != null ? map['mtxline02'] as String : null,
      mtxline03: map['mtxline03'] != null ? map['mtxline03'] as String : null,
      mtxline04: map['mtxline04'] != null ? map['mtxline04'] as String : null,
      storeEpicPath:
          map['storeEpicPath'] != null ? map['storeEpicPath'] as String : null,
      attendaceFp: map['attendaceFp'] as int,
      autoDownload: map['autoDownload'] as int,
      autoDownload1: map['autoDownload1'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['autoDownload1'] as int)
          : null,
      autoDownload2: map['autoDownload2'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['autoDownload2'] as int)
          : null,
      autoDownload3: map['autoDownload3'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['autoDownload3'] as int)
          : null,
      autoSync: map['autoSync'] as int,
      autoUpload: map['autoUpload'] as int,
      checkSellingPrice: map['checkSellingPrice'] as int,
      checkStockMinus: map['checkStockMinus'] as int,
      creditTaxCodeId: map['creditTaxCodeId'] != null
          ? map['creditTaxCodeId'] as String
          : null,
      maxVoidDays: map['maxVoidDays'] as int,
      qtyMinusValidation: map['qtyMinusValidation'] as int,
      roundingRemarks: map['roundingRemarks'] != null
          ? map['roundingRemarks'] as String
          : null,
      searchItem: map['searchItem'] as int,
      vdfLine1: map['vdfLine1'] != null ? map['vdfLine1'] as String : null,
      vdfLine1Off:
          map['vdfLine1Off'] != null ? map['vdfLine1Off'] as String : null,
      vdfLine2: map['vdfLine2'] != null ? map['vdfLine2'] as String : null,
      vdfLine2Off:
          map['vdfLine2Off'] != null ? map['vdfLine2Off'] as String : null,
      isStore: map['isStore'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreMasterEntity.fromJson(String source) =>
      StoreMasterEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreMasterEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, storeCode: $storeCode, storeName: $storeName, email: $email, phone: $phone, addr1: $addr1, addr2: $addr2, addr3: $addr3, city: $city, remarks: $remarks, toprvId: $toprvId, tocryId: $tocryId, tozcdlId: $tozcdlId, tohemId: $tohemId, sqm: $sqm, tcurrId: $tcurrId, toplnId: $toplnId, storePic: $storePic, tovatId: $tovatId, storeOpen: $storeOpen, statusActive: $statusActive, activated: $activated, prefixDoc: $prefixDoc, header01: $header01, header02: $header02, header03: $header03, header04: $header04, header05: $header05, footer01: $footer01, footer02: $footer02, footer03: $footer03, footer04: $footer04, footer05: $footer05, sellingTax: $sellingTax, openingBalance: $openingBalance, autoRounding: $autoRounding, roundingValue: $roundingValue, totalMinus: $totalMinus, totalZero: $totalZero, holdStruck: $holdStruck, holdClose: $holdClose, autoPrintStruk: $autoPrintStruk, barcode1: $barcode1, barcode2: $barcode2, barcode3: $barcode3, barcode4: $barcode4, connectBack: $connectBack, maxUserKassa: $maxUserKassa, stockLevel: $stockLevel, minConst: $minConst, maxConst: $maxConst, orderCycle: $orderCycle, taxBy: $taxBy, tpmt1Id: $tpmt1Id, mtxline01: $mtxline01, mtxline02: $mtxline02, mtxline03: $mtxline03, mtxline04: $mtxline04, storeEpicPath: $storeEpicPath, attendaceFp: $attendaceFp, autoDownload: $autoDownload, autoDownload1: $autoDownload1, autoDownload2: $autoDownload2, autoDownload3: $autoDownload3, autoSync: $autoSync, autoUpload: $autoUpload, checkSellingPrice: $checkSellingPrice, checkStockMinus: $checkStockMinus, creditTaxCodeId: $creditTaxCodeId, maxVoidDays: $maxVoidDays, qtyMinusValidation: $qtyMinusValidation, roundingRemarks: $roundingRemarks, searchItem: $searchItem, vdfLine1: $vdfLine1, vdfLine1Off: $vdfLine1Off, vdfLine2: $vdfLine2, vdfLine2Off: $vdfLine2Off, isStore: $isStore)';
  }

  @override
  bool operator ==(covariant StoreMasterEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.storeCode == storeCode &&
        other.storeName == storeName &&
        other.email == email &&
        other.phone == phone &&
        other.addr1 == addr1 &&
        other.addr2 == addr2 &&
        other.addr3 == addr3 &&
        other.city == city &&
        other.remarks == remarks &&
        other.toprvId == toprvId &&
        other.tocryId == tocryId &&
        other.tozcdlId == tozcdlId &&
        other.tohemId == tohemId &&
        other.sqm == sqm &&
        other.tcurrId == tcurrId &&
        other.toplnId == toplnId &&
        other.storePic == storePic &&
        other.tovatId == tovatId &&
        other.storeOpen == storeOpen &&
        other.statusActive == statusActive &&
        other.activated == activated &&
        other.prefixDoc == prefixDoc &&
        other.header01 == header01 &&
        other.header02 == header02 &&
        other.header03 == header03 &&
        other.header04 == header04 &&
        other.header05 == header05 &&
        other.footer01 == footer01 &&
        other.footer02 == footer02 &&
        other.footer03 == footer03 &&
        other.footer04 == footer04 &&
        other.footer05 == footer05 &&
        other.sellingTax == sellingTax &&
        other.openingBalance == openingBalance &&
        other.autoRounding == autoRounding &&
        other.roundingValue == roundingValue &&
        other.totalMinus == totalMinus &&
        other.totalZero == totalZero &&
        other.holdStruck == holdStruck &&
        other.holdClose == holdClose &&
        other.autoPrintStruk == autoPrintStruk &&
        other.barcode1 == barcode1 &&
        other.barcode2 == barcode2 &&
        other.barcode3 == barcode3 &&
        other.barcode4 == barcode4 &&
        other.connectBack == connectBack &&
        other.maxUserKassa == maxUserKassa &&
        other.stockLevel == stockLevel &&
        other.minConst == minConst &&
        other.maxConst == maxConst &&
        other.orderCycle == orderCycle &&
        other.taxBy == taxBy &&
        other.tpmt1Id == tpmt1Id &&
        other.mtxline01 == mtxline01 &&
        other.mtxline02 == mtxline02 &&
        other.mtxline03 == mtxline03 &&
        other.mtxline04 == mtxline04 &&
        other.storeEpicPath == storeEpicPath &&
        other.attendaceFp == attendaceFp &&
        other.autoDownload == autoDownload &&
        other.autoDownload1 == autoDownload1 &&
        other.autoDownload2 == autoDownload2 &&
        other.autoDownload3 == autoDownload3 &&
        other.autoSync == autoSync &&
        other.autoUpload == autoUpload &&
        other.checkSellingPrice == checkSellingPrice &&
        other.checkStockMinus == checkStockMinus &&
        other.creditTaxCodeId == creditTaxCodeId &&
        other.maxVoidDays == maxVoidDays &&
        other.qtyMinusValidation == qtyMinusValidation &&
        other.roundingRemarks == roundingRemarks &&
        other.searchItem == searchItem &&
        other.vdfLine1 == vdfLine1 &&
        other.vdfLine1Off == vdfLine1Off &&
        other.vdfLine2 == vdfLine2 &&
        other.vdfLine2Off == vdfLine2Off &&
        other.isStore == isStore;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        storeCode.hashCode ^
        storeName.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        addr1.hashCode ^
        addr2.hashCode ^
        addr3.hashCode ^
        city.hashCode ^
        remarks.hashCode ^
        toprvId.hashCode ^
        tocryId.hashCode ^
        tozcdlId.hashCode ^
        tohemId.hashCode ^
        sqm.hashCode ^
        tcurrId.hashCode ^
        toplnId.hashCode ^
        storePic.hashCode ^
        tovatId.hashCode ^
        storeOpen.hashCode ^
        statusActive.hashCode ^
        activated.hashCode ^
        prefixDoc.hashCode ^
        header01.hashCode ^
        header02.hashCode ^
        header03.hashCode ^
        header04.hashCode ^
        header05.hashCode ^
        footer01.hashCode ^
        footer02.hashCode ^
        footer03.hashCode ^
        footer04.hashCode ^
        footer05.hashCode ^
        sellingTax.hashCode ^
        openingBalance.hashCode ^
        autoRounding.hashCode ^
        roundingValue.hashCode ^
        totalMinus.hashCode ^
        totalZero.hashCode ^
        holdStruck.hashCode ^
        holdClose.hashCode ^
        autoPrintStruk.hashCode ^
        barcode1.hashCode ^
        barcode2.hashCode ^
        barcode3.hashCode ^
        barcode4.hashCode ^
        connectBack.hashCode ^
        maxUserKassa.hashCode ^
        stockLevel.hashCode ^
        minConst.hashCode ^
        maxConst.hashCode ^
        orderCycle.hashCode ^
        taxBy.hashCode ^
        tpmt1Id.hashCode ^
        mtxline01.hashCode ^
        mtxline02.hashCode ^
        mtxline03.hashCode ^
        mtxline04.hashCode ^
        storeEpicPath.hashCode ^
        attendaceFp.hashCode ^
        autoDownload.hashCode ^
        autoDownload1.hashCode ^
        autoDownload2.hashCode ^
        autoDownload3.hashCode ^
        autoSync.hashCode ^
        autoUpload.hashCode ^
        checkSellingPrice.hashCode ^
        checkStockMinus.hashCode ^
        creditTaxCodeId.hashCode ^
        maxVoidDays.hashCode ^
        qtyMinusValidation.hashCode ^
        roundingRemarks.hashCode ^
        searchItem.hashCode ^
        vdfLine1.hashCode ^
        vdfLine1Off.hashCode ^
        vdfLine2.hashCode ^
        vdfLine2Off.hashCode ^
        isStore.hashCode;
  }
}