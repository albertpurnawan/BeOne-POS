import 'package:pos_fe/features/sales/domain/entities/store_master.dart';

const String tableStoreMasters = "tostr";

class StoreMasterFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    storeCode,
    storeName,
    email,
    phone,
    addr1,
    addr2,
    addr3,
    city,
    remarks,
    toprvId,
    tocryId,
    tozcdlId,
    tohemId,
    sqm,
    tcurrId,
    toplnId,
    storePic,
    tovatId,
    storeOpen,
    statusActive,
    activated,
    prefixDoc,
    header01,
    header02,
    header03,
    header04,
    header05,
    footer01,
    footer02,
    footer03,
    footer04,
    footer05,
    sellingTax,
    openingBalance,
    autoRounding,
    roundingValue,
    totalMinus,
    totalZero,
    holdStruck,
    holdClose,
    autoPrintStruk,
    barcode1,
    barcode2,
    barcode3,
    barcode4,
    connectBack,
    maxUserKassa,
    stockLevel,
    minConst,
    maxConst,
    orderCycle,
    taxBy,
    tpmt1Id,
    mtxline01,
    mtxline02,
    mtxline03,
    mtxline04,
    storeEpicPath,
    attendaceFp,
    autoDownload,
    autoDownload1,
    autoDownload2,
    autoDownload3,
    autoSync,
    autoUpload,
    checkSellingPrice,
    checkStockMinus,
    creditTaxCodeId,
    maxVoidDays,
    qtyMinusValidation,
    roundingRemarks,
    searchItem,
    vdfLine1,
    vdfLine1Off,
    vdfLine2,
    vdfLine2Off,
    isStore,
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String storeCode = 'storecode';
  static const String storeName = 'storename';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String addr1 = 'addr1';
  static const String addr2 = 'addr2';
  static const String addr3 = 'addr3';
  static const String city = 'city';
  static const String remarks = 'remarks';
  static const String toprvId = 'toprvId';
  static const String tocryId = 'tocryId';
  static const String tozcdlId = 'tozcdlId';
  static const String tohemId = 'tohemId';
  static const String sqm = 'sqm';
  static const String tcurrId = 'tcurrId';
  static const String toplnId = 'toplnId';
  static const String storePic = 'storepic';
  static const String tovatId = 'tovatId';
  static const String storeOpen = 'storeopen';
  static const String statusActive = 'statusactive';
  static const String activated = 'activated';
  static const String prefixDoc = 'prefixdoc';
  static const String header01 = 'header01';
  static const String header02 = 'header02';
  static const String header03 = 'header03';
  static const String header04 = 'header04';
  static const String header05 = 'header05';
  static const String footer01 = 'footer01';
  static const String footer02 = 'footer02';
  static const String footer03 = 'footer03';
  static const String footer04 = 'footer04';
  static const String footer05 = 'footer05';
  static const String sellingTax = 'sellingtax';
  static const String openingBalance = 'openingbalance';
  static const String autoRounding = 'autorounding';
  static const String roundingValue = 'roundingvalue';
  static const String totalMinus = 'totalminus';
  static const String totalZero = 'totalzero';
  static const String holdStruck = 'holdstruck';
  static const String holdClose = 'holdclose';
  static const String autoPrintStruk = 'autoprintstruk';
  static const String barcode1 = 'barcode1';
  static const String barcode2 = 'barcode2';
  static const String barcode3 = 'barcode3';
  static const String barcode4 = 'barcode4';
  static const String connectBack = 'connectback';
  static const String maxUserKassa = 'maxuserkassa';
  static const String stockLevel = 'stocklevel';
  static const String minConst = 'minconst';
  static const String maxConst = 'maxconst';
  static const String orderCycle = 'ordercycle';
  static const String taxBy = 'taxby';
  static const String tpmt1Id = 'tpmt1Id';
  static const String mtxline01 = 'mtxline01';
  static const String mtxline02 = 'mtxline02';
  static const String mtxline03 = 'mtxline03';
  static const String mtxline04 = 'mtxline04';
  static const String storeEpicPath = 'storeepicpath';
  static const String attendaceFp = 'attendacefp';
  static const String autoDownload = 'autodownload';
  static const String autoDownload1 = 'autodownload1';
  static const String autoDownload2 = 'autodownload2';
  static const String autoDownload3 = 'autodownload3';
  static const String autoSync = 'autosync';
  static const String autoUpload = 'autoupload';
  static const String checkSellingPrice = 'checksellingprice';
  static const String checkStockMinus = 'checkstockminus';
  static const String creditTaxCodeId = 'creditTaxCodeId';
  static const String maxVoidDays = 'maxvoiddays';
  static const String qtyMinusValidation = 'qtyminusvalidation';
  static const String roundingRemarks = 'roundingremarks';
  static const String searchItem = 'searchitem';
  static const String vdfLine1 = 'vdfline1';
  static const String vdfLine1Off = 'vdfline1off';
  static const String vdfLine2 = 'vdfline2';
  static const String vdfLine2Off = 'vdfline2off';
  static const String isStore = 'isstore';
}

class StoreMasterModel extends StoreMasterEntity {
  StoreMasterModel(
      {required super.docId,
      required super.createDate,
      required super.updateDate,
      required super.storeCode,
      required super.storeName,
      required super.email,
      required super.phone,
      required super.addr1,
      required super.addr2,
      required super.addr3,
      required super.city,
      required super.remarks,
      required super.toprvId,
      required super.tocryId,
      required super.tozcdlId,
      required super.tohemId,
      required super.sqm,
      required super.tcurrId,
      required super.toplnId,
      required super.storePic,
      required super.tovatId,
      required super.storeOpen,
      required super.statusActive,
      required super.activated,
      required super.prefixDoc,
      required super.header01,
      required super.header02,
      required super.header03,
      required super.header04,
      required super.header05,
      required super.footer01,
      required super.footer02,
      required super.footer03,
      required super.footer04,
      required super.footer05,
      required super.sellingTax,
      required super.openingBalance,
      required super.autoRounding,
      required super.roundingValue,
      required super.totalMinus,
      required super.totalZero,
      required super.holdStruck,
      required super.holdClose,
      required super.autoPrintStruk,
      required super.barcode1,
      required super.barcode2,
      required super.barcode3,
      required super.barcode4,
      required super.connectBack,
      required super.maxUserKassa,
      required super.stockLevel,
      required super.minConst,
      required super.maxConst,
      required super.orderCycle,
      required super.taxBy,
      required super.tpmt1Id,
      required super.mtxline01,
      required super.mtxline02,
      required super.mtxline03,
      required super.mtxline04,
      required super.storeEpicPath,
      required super.attendaceFp,
      required super.autoDownload,
      required super.autoDownload1,
      required super.autoDownload2,
      required super.autoDownload3,
      required super.autoSync,
      required super.autoUpload,
      required super.checkSellingPrice,
      required super.checkStockMinus,
      required super.creditTaxCodeId,
      required super.maxVoidDays,
      required super.qtyMinusValidation,
      required super.roundingRemarks,
      required super.searchItem,
      required super.vdfLine1,
      required super.vdfLine1Off,
      required super.vdfLine2,
      required super.vdfLine2Off,
      required super.isStore});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'storecode': storeCode,
      'storename': storeName,
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
      'storepic': storePic,
      'tovatId': tovatId,
      'storeopen': storeOpen.toUtc().toIso8601String(),
      'statusactive': statusActive,
      'activated': activated,
      'prefixdoc': prefixDoc,
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
      'sellingtax': sellingTax,
      'openingbalance': openingBalance,
      'autorounding': autoRounding,
      'roundingvalue': roundingValue,
      'totalminus': totalMinus,
      'totalzero': totalZero,
      'holdstruck': holdStruck,
      'holdclose': holdClose,
      'autoprintstruk': autoPrintStruk,
      'barcode1': barcode1,
      'barcode2': barcode2,
      'barcode3': barcode3,
      'barcode4': barcode4,
      'connectback': connectBack,
      'maxuserkassa': maxUserKassa,
      'stocklevel': stockLevel,
      'minconst': minConst,
      'maxconst': maxConst,
      'ordercycle': orderCycle,
      'taxby': taxBy,
      'tpmt1Id': tpmt1Id,
      'mtxline01': mtxline01,
      'mtxline02': mtxline02,
      'mtxline03': mtxline03,
      'mtxline04': mtxline04,
      'storeepicpath': storeEpicPath,
      'attendacefp': attendaceFp,
      'autodownload': autoDownload,
      'autodownload1': autoDownload1?.toUtc().toIso8601String(),
      'autodownload2': autoDownload2?.toUtc().toIso8601String(),
      'autodownload3': autoDownload3?.toUtc().toIso8601String(),
      'autosync': autoSync,
      'autoupload': autoUpload,
      'checksellingprice': checkSellingPrice,
      'checkstockminus': checkStockMinus,
      'creditTaxCodeId': creditTaxCodeId,
      'maxvoiddays': maxVoidDays,
      'qtyminusvalidation': qtyMinusValidation,
      'roundingremarks': roundingRemarks,
      'searchitem': searchItem,
      'vdfline1': vdfLine1,
      'vdfline1off': vdfLine1Off,
      'vdfline2': vdfLine2,
      'vdfline2off': vdfLine2Off,
      'isstore': isStore,
    };
  }

  factory StoreMasterModel.fromMap(Map<String, dynamic> map) {
    return StoreMasterModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String)
          : null,
      storeCode: map['storecode'] as String,
      storeName: map['storename'] as String,
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
      storePic: map['storepic'] as dynamic,
      tovatId: map['tovatId'] != null ? map['tovatId'] as String : null,
      storeOpen: DateTime.parse(map['storeopen'] as String),
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      prefixDoc: map['prefixdoc'] != null ? map['prefixdoc'] as String : null,
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
          map['sellingtax'] != null ? map['sellingtax'] as double : null,
      openingBalance: map['openingbalance'] != null
          ? map['openingbalance'] as double
          : null,
      autoRounding:
          map['autorounding'] != null ? map['autorounding'] as int : null,
      roundingValue:
          map['roundingvalue'] != null ? map['roundingvalue'] as double : null,
      totalMinus: map['totalminus'] != null ? map['totalminus'] as int : null,
      totalZero: map['totalzero'] != null ? map['totalzero'] as int : null,
      holdStruck: map['holdstruck'] != null ? map['holdstruck'] as int : null,
      holdClose: map['holdclose'] != null ? map['holdclose'] as int : null,
      autoPrintStruk:
          map['autoprintstruk'] != null ? map['autoprintstruk'] as int : null,
      barcode1: map['barcode1'] != null ? map['barcode1'] as String : null,
      barcode2: map['barcode2'] != null ? map['barcode2'] as String : null,
      barcode3: map['barcode3'] != null ? map['barcode3'] as String : null,
      barcode4: map['barcode4'] != null ? map['barcode4'] as String : null,
      connectBack:
          map['connectback'] != null ? map['connectback'] as int : null,
      maxUserKassa:
          map['maxuserkassa'] != null ? map['maxuserkassa'] as int : null,
      stockLevel: map['stocklevel'] as double,
      minConst: map['minconst'] as double,
      maxConst: map['maxconst'] as double,
      orderCycle: map['ordercycle'] as int,
      taxBy: map['taxby'] as int,
      tpmt1Id: map['tpmt1Id'] != null ? map['tpmt1Id'] as String : null,
      mtxline01: map['mtxline01'] != null ? map['mtxline01'] as String : null,
      mtxline02: map['mtxline02'] != null ? map['mtxline02'] as String : null,
      mtxline03: map['mtxline03'] != null ? map['mtxline03'] as String : null,
      mtxline04: map['mtxline04'] != null ? map['mtxline04'] as String : null,
      storeEpicPath:
          map['storeepicpath'] != null ? map['storeepicpath'] as String : null,
      attendaceFp: map['attendacefp'] as int,
      autoDownload: map['autodownload'] as int,
      autoDownload1: map['autodownload1'] != null
          ? DateTime.parse(map['autodownload1'] as String)
          : null,
      autoDownload2: map['autodownload2'] != null
          ? DateTime.parse(map['autodownload2'] as String)
          : null,
      autoDownload3: map['autodownload3'] != null
          ? DateTime.parse(map['autodownload3'] as String)
          : null,
      autoSync: map['autosync'] as int,
      autoUpload: map['autoupload'] as int,
      checkSellingPrice: map['checkSellingPrice'] as int,
      checkStockMinus: map['checkstockminus'] as int,
      creditTaxCodeId: map['creditTaxCodeId'] != null
          ? map['creditTaxCodeId'] as String
          : null,
      maxVoidDays: map['maxvoiddays'] as int,
      qtyMinusValidation: map['qtyminusvalidation'] as int,
      roundingRemarks: map['roundingremarks'] != null
          ? map['roundingremarks'] as String
          : null,
      searchItem: map['searchitem'] as int,
      vdfLine1: map['vdfline1'] != null ? map['vdfline1'] as String : null,
      vdfLine1Off:
          map['vdfline1off'] != null ? map['vdfline1off'] as String : null,
      vdfLine2: map['vdfline2'] != null ? map['vdfline2'] as String : null,
      vdfLine2Off:
          map['vdfline2off'] != null ? map['vdfline2off'] as String : null,
      isStore: map['isstore'] as int,
    );
  }

  factory StoreMasterModel.fromMapRemote(Map<String, dynamic> map) {
    return StoreMasterModel.fromMap({
      ...map,
      "toprvId": map['toprv_id']?['docid'] != null
          ? map['toprv_id']['docid'] as String
          : null,
      "tocryId": map['tocry_id']?['docid'] != null
          ? map['tocry_id']['docid'] as String
          : null,
      "tozcdlId": map['tozcdl_id']?['docid'] != null
          ? map['tozcdl_id']['docid'] as String
          : null,
      "tohemId": map['tohem_id']?['docid'] != null
          ? map['tohem_id']['docid'] as String
          : null,
      "tcurrId": map['tcurr_id']?['docid'] != null
          ? map['tcurr_id']['docid'] as String
          : null,
      "toplnId": map['topln_id']?['docid'] != null
          ? map['topln_id']['docid'] as String
          : null,
      "tovatId": map['tovat_id']?['docid'] != null
          ? map['tovat_id']['docid'] as String
          : null,
      "tpmt1Id": map['tpmt1_id']?['docid'] != null
          ? map['tpmt1_id']['docid'] as String
          : null,
      "creditTaxCodeId": map['credittaxcode_id']?['docid'] != null
          ? map['credittaxcode_id']['docid'] as String
          : null,
      "sellingtax": map['sellingtax'] != null
          ? map['sellingtax'].toDouble() as double
          : null,
      "openingbalance": map['openingbalance'] != null
          ? map['openingbalance'].toDouble() as double
          : null,
      "roundingvalue": map['roundingvalue'] != null
          ? map['roundingvalue'].toDouble() as double
          : null,
      "stocklevel": map['stocklevel'].toDouble() as double,
      "minconst": map['minconst'].toDouble() as double,
      "maxconst": map['maxconst'].toDouble() as double,
    });
  }
}
