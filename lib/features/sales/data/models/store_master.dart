import 'package:pos_fe/core/resources/base_model.dart';
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
    tozcdId,
    tohemId,
    sqm,
    tcurrId,
    toplnId,
    storePic,
    tovatId,
    storeOpening,
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
    salesViewType,
    otpChannel,
    otpUrl,
    netzmeUrl,
    netzmeClientKey,
    netzmeClientSecret,
    netzmeClientPrivateKey,
    netzmeCustidMerchant,
    netzmeChannelId,
    minDiscount,
    maxDiscount,
    duitkuUrl,
    duitkuApiKey,
    duitkuMerchantCode,
    duitkuExpiryPeriod,
    scaleActive,
    scaleFlag,
    scaleItemCodeLength,
    scaleQuantityLength,
    scaleQtyDivider,
    form,
    // defaultTocusId,
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
  static const String tozcdId = 'tozcdId';
  static const String tohemId = 'tohemId';
  static const String sqm = 'sqm';
  static const String tcurrId = 'tcurrId';
  static const String toplnId = 'toplnId';
  static const String storePic = 'storepic';
  static const String tovatId = 'tovatId';
  static const String storeOpening = 'storeopen';
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
  static const String salesViewType = 'salesviewtype';
  static const String otpChannel = 'otpchannel';
  static const String otpUrl = 'otpurl';
  static const String netzmeUrl = 'netzmeurl';
  static const String netzmeClientKey = 'netzmeclientkey';
  static const String netzmeClientSecret = 'netzmeclientsecret';
  static const String netzmeClientPrivateKey = 'netzmeclientprivatekey';
  static const String netzmeCustidMerchant = 'netzmecustidmerchant';
  static const String netzmeChannelId = 'netzmechannelid';
  static const String minDiscount = 'mindiscount';
  static const String maxDiscount = 'maxdiscount';
  static const String duitkuUrl = 'duitkuurl';
  static const String duitkuApiKey = 'duitkuapikey';
  static const String duitkuMerchantCode = 'duitkumerchantcode';
  static const String duitkuExpiryPeriod = 'duitkuexpiryperiod';
  static const String scaleActive = 'scaleactive';
  static const String scaleFlag = 'scaleflag';
  static const String scaleItemCodeLength = 'scaleitemcodelength';
  static const String scaleQuantityLength = 'scalequantitylength';
  static const String scaleQtyDivider = 'scaleqtydivider';
  static const String form = 'form';
  // static const String defaultTocusId = 'defaulttocusid';
}

class StoreMasterModel extends StoreMasterEntity implements BaseModel {
  StoreMasterModel({
    required super.docId,
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
    required super.tozcdId,
    required super.tohemId,
    required super.sqm,
    required super.tcurrId,
    required super.toplnId,
    required super.storePic,
    required super.tovatId,
    required super.storeOpening,
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
    required super.salesViewType,
    required super.otpChannel,
    required super.otpUrl,
    required super.netzmeUrl,
    required super.netzmeClientKey,
    required super.netzmeClientSecret,
    required super.netzmeClientPrivateKey,
    required super.netzmeCustidMerchant,
    required super.netzmeChannelId,
    required super.minDiscount,
    required super.maxDiscount,
    required super.duitkuUrl,
    required super.duitkuApiKey,
    required super.duitkuMerchantCode,
    required super.duitkuExpiryPeriod,
    required super.scaleActive,
    required super.scaleFlag,
    required super.scaleItemCodeLength,
    required super.scaleQuantityLength,
    required super.scaleQtyDivider,
    required super.form,

    // required super.defaultTocusId,
  });

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
      'tozcdId': tozcdId,
      'tohemId': tohemId,
      'sqm': sqm,
      'tcurrId': tcurrId,
      'toplnId': toplnId,
      'storepic': storePic.toString(),
      'tovatId': tovatId,
      'storeopen': storeOpening.toUtc().toIso8601String(),
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
      'salesviewtype': salesViewType,
      'otpchannel': otpChannel,
      'otpurl': otpUrl,
      'netzmeurl': netzmeUrl,
      'netzmeclientkey': netzmeClientKey,
      'netzmeclientsecret': netzmeClientSecret,
      'netzmeclientprivatekey': netzmeClientPrivateKey,
      'netzmecustidmerchant': netzmeCustidMerchant,
      'netzmechannelid': netzmeChannelId,
      'mindiscount': minDiscount,
      'maxdiscount': maxDiscount,
      'duitkuurl': duitkuUrl,
      'duitkuapikey': duitkuApiKey,
      'duitkumerchantcode': duitkuMerchantCode,
      'duitkuexpiryperiod': duitkuExpiryPeriod,
      'scaleactive': scaleActive,
      'scaleflag': scaleFlag,
      'scaleitemcodelength': scaleItemCodeLength,
      'scalequantitylength': scaleQuantityLength,
      'scaleqtydivider': scaleQtyDivider,
      'form': form,
      // 'defaulttocusid': defaultTocusId,
    };
  }

  factory StoreMasterModel.fromMap(Map<String, dynamic> map) {
    return StoreMasterModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String).toLocal() : null,
      storeCode: map['storecode'] as String,
      storeName: map['storename'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      addr1: map['addr1'] != null ? map['addr1'] as String : null,
      addr2: map['addr2'] != null ? map['addr2'] as String : null,
      addr3: map['addr3'] != null ? map['addr3'] as String : null,
      city: map['city'] as String,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      toprvId: map['toprvId'] != null ? map['toprvId'] as String : null,
      tocryId: map['tocryId'] != null ? map['tocryId'] as String : null,
      tozcdId: map['tozcdId'] != null ? map['tozcdId'] as String : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      sqm: map['sqm'] as double,
      tcurrId: map['tcurrId'] != null ? map['tcurrId'] as String : null,
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
      storePic: map['storepic'] != null ? map['storepic'] as dynamic : null,
      tovatId: map['tovatId'] != null ? map['tovatId'] as String : null,
      storeOpening: DateTime.parse(map['storeopen'] as String).toLocal(),
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
      sellingTax: map['sellingtax'] != null ? map['sellingtax'] as double : null,
      openingBalance: map['openingbalance'] != null ? map['openingbalance'] as double : null,
      autoRounding: map['autorounding'] != null ? map['autorounding'] as int : null,
      roundingValue: map['roundingvalue'] != null ? map['roundingvalue'] as double : null,
      totalMinus: map['totalminus'] != null ? map['totalminus'] as int : null,
      totalZero: map['totalzero'] != null ? map['totalzero'] as int : null,
      holdStruck: map['holdstruck'] != null ? map['holdstruck'] as int : null,
      holdClose: map['holdclose'] != null ? map['holdclose'] as int : null,
      autoPrintStruk: map['autoprintstruk'] != null ? map['autoprintstruk'] as int : null,
      barcode1: map['barcode1'] != null ? map['barcode1'] as String : null,
      barcode2: map['barcode2'] != null ? map['barcode2'] as int : null,
      barcode3: map['barcode3'] != null ? map['barcode3'] as int : null,
      barcode4: map['barcode4'] != null ? map['barcode4'] as int : null,
      connectBack: map['connectback'] != null ? map['connectback'] as int : null,
      maxUserKassa: map['maxuserkassa'] != null ? map['maxuserkassa'] as int : null,
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
      salesViewType: map['salesviewtype'] != null ? map['salesviewtype'] as int : null,
      otpChannel: map['otpchannel'] != null ? map['otpchannel'] as String : null,
      otpUrl: map['otpurl'] != null ? map['otpurl'] as String : null,
      netzmeUrl: map['netzmeurl'] != null ? map['netzmeurl'] as String : null,
      netzmeClientKey: map['netzmeclientkey'] != null ? map['netzmeclientkey'] as String : null,
      netzmeClientSecret: map['netzmeclientsecret'] != null ? map['netzmeclientsecret'] as String : null,
      netzmeClientPrivateKey: map['netzmeclientprivatekey'] != null ? map['netzmeclientprivatekey'] as String : null,
      netzmeCustidMerchant: map['netzmecustidmerchant'] != null ? map['netzmecustidmerchant'] as String : null,
      netzmeChannelId: map['netzmechannelid'] != null ? map['netzmechannelid'] as String : null,
      minDiscount: map['mindiscount'] != null ? map['mindiscount'] as int : null,
      maxDiscount: map['maxdiscount'] != null ? map['maxdiscount'] as int : null,
      duitkuUrl: map['duitkuurl'] != null ? map['duitkuurl'] as String : null,
      duitkuApiKey: map['duitkuapikey'] != null ? map['duitkuapikey'] as String : null,
      duitkuMerchantCode: (map['duitkumerchantcode'] != null || map['duitkumerchantcode'] == "")
          ? map['duitkumerchantcode'] as String
          : null,
      duitkuExpiryPeriod: map['duitkuexpiryperiod'] != null ? map['duitkuexpiryperiod'] as int : null,
      scaleActive: map['scaleactive'] as int,
      scaleFlag: map['scaleflag'] != null ? map['scaleflag'] as String : null,
      scaleItemCodeLength: map['scaleitemcodelength'] != null ? map['scaleitemcodelength'] as int : null,
      scaleQuantityLength: map['scalequantitylength'] != null ? map['scalequantitylength'] as int : null,
      scaleQtyDivider: map['scaleqtydivider'] != null ? map['scaleqtydivider'] as double : null,
      form: map['form'] as String,
      // defaultTocusId: map['defaulttocusId'] as String,
    );
  }

  factory StoreMasterModel.fromMapRemote(Map<String, dynamic> map) {
    return StoreMasterModel.fromMap({
      ...map,
      "toprvId": map['toprvdocid'] != null ? map['toprvdocid'] as String : null,
      "tocryId": map['tocrydocid'] != null ? map['tocrydocid'] as String : null,
      "tozcdId": map['tozcddocid'] != null ? map['tozcddocid'] as String : null,
      "tohemId": map['tohemdocid'] != null ? map['tohemdocid'] as String : null,
      "sqm": map['sqm'].toDouble() as double,
      "tcurrId": map['tcurrdocid'] != null ? map['tcurrdocid'] as String : null,
      "toplnId": map['toplndocid'] != null ? map['toplndocid'] as String : null,
      "tovatId": map['tovatdocid'] != null ? map['tovatdocid'] as String : null,
      "sellingtax": map['sellingtax'] != null ? map['sellingtax'].toDouble() as double : null,
      "openingbalance": map['openingbalance'] != null ? map['openingbalance'].toDouble() as double : null,
      "roundingvalue": map['roundingvalue'] != null ? map['roundingvalue'].toDouble() as double : null,
      "stocklevel": map['stocklevel'].toDouble() as double,
      "minconst": map['minconst'].toDouble() as double,
      "maxconst": map['maxconst'].toDouble() as double,
      "tpmt1Id": map['tpmt1docid'] != null ? map['tpmt1docid'] as String : null,
      "duitkuexpiryperiod": (map['duitkuexpiryperiod'] != null && map['duitkuexpiryperiod'] != "")
          ? int.parse(map['duitkuexpiryperiod'])
          : null,
      "scaleactive": map['scaleactive'] != null ? map['scaleactive'] as int : 0,
      "scaleqtydivider": map['scalequantitydivider'] != null ? map['scalequantitydivider'].toDouble() as double : null,
    });
  }

  factory StoreMasterModel.fromEntity(StoreMasterEntity entity) {
    return StoreMasterModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      storeCode: entity.storeCode,
      storeName: entity.storeName,
      email: entity.email,
      phone: entity.phone,
      addr1: entity.addr1,
      addr2: entity.addr2,
      addr3: entity.addr3,
      city: entity.city,
      remarks: entity.remarks,
      toprvId: entity.toprvId,
      tocryId: entity.tocryId,
      tozcdId: entity.tozcdId,
      tohemId: entity.tohemId,
      sqm: entity.sqm,
      tcurrId: entity.tcurrId,
      toplnId: entity.toplnId,
      storePic: entity.storePic,
      tovatId: entity.tovatId,
      storeOpening: entity.storeOpening,
      statusActive: entity.statusActive,
      activated: entity.activated,
      prefixDoc: entity.prefixDoc,
      header01: entity.header01,
      header02: entity.header02,
      header03: entity.header03,
      header04: entity.header04,
      header05: entity.header05,
      footer01: entity.footer01,
      footer02: entity.footer02,
      footer03: entity.footer03,
      footer04: entity.footer04,
      footer05: entity.footer05,
      sellingTax: entity.sellingTax,
      openingBalance: entity.openingBalance,
      autoRounding: entity.autoRounding,
      roundingValue: entity.roundingValue,
      totalMinus: entity.totalMinus,
      totalZero: entity.totalZero,
      holdStruck: entity.holdStruck,
      holdClose: entity.holdClose,
      autoPrintStruk: entity.autoPrintStruk,
      barcode1: entity.barcode1,
      barcode2: entity.barcode2,
      barcode3: entity.barcode3,
      barcode4: entity.barcode4,
      connectBack: entity.connectBack,
      maxUserKassa: entity.maxUserKassa,
      stockLevel: entity.stockLevel,
      minConst: entity.minConst,
      maxConst: entity.maxConst,
      orderCycle: entity.orderCycle,
      taxBy: entity.taxBy,
      tpmt1Id: entity.tpmt1Id,
      mtxline01: entity.mtxline01,
      mtxline02: entity.mtxline02,
      mtxline03: entity.mtxline03,
      mtxline04: entity.mtxline04,
      salesViewType: entity.salesViewType,
      otpChannel: entity.otpChannel,
      otpUrl: entity.otpUrl,
      netzmeUrl: entity.netzmeUrl,
      netzmeClientKey: entity.netzmeClientKey,
      netzmeClientSecret: entity.netzmeClientSecret,
      netzmeClientPrivateKey: entity.netzmeClientPrivateKey,
      netzmeCustidMerchant: entity.netzmeCustidMerchant,
      netzmeChannelId: entity.netzmeChannelId,
      minDiscount: entity.minDiscount,
      maxDiscount: entity.maxDiscount,
      duitkuUrl: entity.duitkuUrl,
      duitkuApiKey: entity.duitkuApiKey,
      duitkuMerchantCode: entity.duitkuMerchantCode,
      duitkuExpiryPeriod: entity.duitkuExpiryPeriod,
      scaleActive: entity.scaleActive,
      scaleFlag: entity.scaleFlag,
      scaleItemCodeLength: entity.scaleItemCodeLength,
      scaleQuantityLength: entity.scaleQuantityLength,
      scaleQtyDivider: entity.scaleQtyDivider,
      form: entity.form,
      // defaultTocusId: entity.defaultTocusId,
    );
  }
}
