import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/credit_memo_header.dart';

const String tableCreditMemoHeader = "torin";

class CreditMemoHeaderFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tostrId,
    docNum,
    orderNo,
    tocusId,
    tohemId,
    transDate,
    transTime,
    timezone,
    remarks,
    subTotal,
    discPrctg,
    discAmount,
    discountCard,
    coupon,
    discountCoupun,
    taxPrctg,
    taxAmount,
    addCost,
    rounding,
    grandTotal,
    changed,
    totalPayment,
    tocsrId,
    docStatus,
    sync,
    syncCRM,
    torinTohemId,
    refpos1,
    refpos2,
    voidTohemId,
    channel,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tostrId = "tostrId";
  static const String docNum = "docnum";
  static const String orderNo = "orderno";
  static const String tocusId = "tocusId";
  static const String tohemId = "tohemId";
  static const String transDate = "transdate";
  static const String transTime = "transtime";
  static const String timezone = "timezone";
  static const String remarks = "remarks";
  static const String subTotal = "subtotal";
  static const String discPrctg = "discprctg";
  static const String discAmount = "discamount";
  static const String discountCard = "discountcard";
  static const String coupon = "coupon";
  static const String discountCoupun = "discountCoupun";
  static const String taxPrctg = "taxprctg";
  static const String taxAmount = "taxamount";
  static const String addCost = "addcost";
  static const String rounding = "rounding";
  static const String grandTotal = "grandtotal";
  static const String changed = "changed";
  static const String totalPayment = "totalpayment";
  static const String tocsrId = "tocsrId";
  static const String docStatus = "docstatus";
  static const String sync = "sync";
  static const String syncCRM = "synccrm";
  static const String torinTohemId = "torinTohemId";
  static const String refpos1 = "refpos1";
  static const String refpos2 = "refpos2";
  static const String voidTohemId = "voidTohemId";
  static const String channel = "channel";
}

class CreditMemoHeaderModel extends CreditMemoHeaderEntity implements BaseModel {
  CreditMemoHeaderModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tostrId,
    required super.docNum,
    required super.orderNo,
    required super.tocusId,
    required super.tohemId,
    required super.transDate,
    required super.transTime,
    required super.timezone,
    required super.remarks,
    required super.subTotal,
    required super.discPrctg,
    required super.discAmount,
    required super.discountCard,
    required super.coupon,
    required super.discountCoupun,
    required super.taxPrctg,
    required super.taxAmount,
    required super.addCost,
    required super.rounding,
    required super.grandTotal,
    required super.changed,
    required super.totalPayment,
    required super.tocsrId,
    required super.docStatus,
    required super.sync,
    required super.syncCRM,
    required super.torinTohemId,
    required super.refpos1,
    required super.refpos2,
    required super.voidTohemId,
    required super.channel,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tostrId': tostrId,
      'docnum': docNum,
      'orderno': orderNo,
      'tocusId': tocusId,
      'tohemId': tohemId,
      'transdate': transDate.toUtc().toIso8601String(),
      'transtime': transTime.toUtc().toIso8601String(),
      'timezone': timezone,
      'remarks': remarks,
      'subtotal': subTotal,
      'discprctg': discPrctg,
      'discamount': discAmount,
      'discountcard': discountCard,
      'coupon': coupon,
      'discountcoupun': discountCoupun,
      'taxprctg': taxPrctg,
      'taxamount': taxAmount,
      'addcost': addCost,
      'rounding': rounding,
      'grandtotal': grandTotal,
      'changed': changed,
      'totalpayment': totalPayment,
      'tocsrId': tocsrId,
      'docstatus': docStatus,
      'sync': sync,
      'synccrm': syncCRM,
      'torinTohemId': torinTohemId,
      'refpos1': refpos1,
      'refpos2': refpos2,
      'voidTohemId': voidTohemId,
      'channel': channel,
    };
  }

  factory CreditMemoHeaderModel.fromMap(Map<String, dynamic> map) {
    return CreditMemoHeaderModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String).toLocal() : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      docNum: map['docnum'] as String,
      orderNo: map['orderno'] as int,
      tocusId: map['tocusId'] != null ? map['tocusId'] as String : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      transDate: DateTime.parse(map['transdate'] as String).toLocal(),
      transTime: DateTime.parse(map['transtime'] as String).toLocal(),
      timezone: map['timezone'] as String,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      subTotal: map['subtotal'] as double,
      discPrctg: map['discprctg'] as double,
      discAmount: map['discamount'] as double,
      discountCard: map['discountcard'] as double,
      coupon: map['coupon'] as String,
      discountCoupun: map['discountcoupun'] as double,
      taxPrctg: map['taxprctg'] as double,
      taxAmount: map['taxamount'] as double,
      addCost: map['addcost'] as double,
      rounding: map['rounding'] as double,
      grandTotal: map['grandtotal'] as double,
      changed: map['changed'] as double,
      totalPayment: map['totalpayment'] as double,
      tocsrId: map['tocsrId'] != null ? map['tocsrId'] as String : null,
      docStatus: map['docstatus'] as int,
      sync: map['sync'] as int,
      syncCRM: map['synccrm'] as int,
      torinTohemId: map['torinTohemId'] != null ? map['torinTohemId'] as String : null,
      refpos1: map['refpos1'] != null ? map['refpos1'] as String : null,
      refpos2: map['refpos2'] != null ? map['refpos2'] as String : null,
      voidTohemId: map['voidTohemId'] != null ? map['voidTohemId'] as String : null,
      channel: map['channel'] != null ? map['channel'] as String : null,
    );
  }

  factory CreditMemoHeaderModel.fromMapRemote(Map<String, dynamic> map) {
    return CreditMemoHeaderModel.fromMap({
      ...map,
      "tocusId": map['tocus_id']?['docid'] != null ? map['tocus_id']['docid'] as String : null,
      "tohemId": map['tohem_id']?['docid'] != null ? map['tohem_id']['docid'] as String : null,
      "tocsrId": map['tocsr_id']?['docid'] != null ? map['tocsr_id']['docid'] as String : null,
      "torinTohemId": map['tohem_id']?['docid'] != null ? map['tohem_id']['docid'] as String : null,
      "subtotal": map['subtotal'].toDouble() as double,
      "discprctg": map['discprctg'].toDouble() as double,
      "discamount": map['discamount'].toDouble() as double,
      "discountcard": map['discountcard'].toDouble() as double,
      "discountcoupun": map['discountcoupun'].toDouble() as double,
      "taxprctg": map['taxprctg'].toDouble() as double,
      "taxamount": map['taxamount'].toDouble() as double,
      "addcost": map['addcost'].toDouble() as double,
      "rounding": map['rounding'].toDouble() as double,
      "grandtotal": map['grandtotal'].toDouble() as double,
      "changed": map['changed'].toDouble() as double,
      "totalpayment": map['totalpayment'].toDouble() as double,
    });
  }

  factory CreditMemoHeaderModel.fromEntity(CreditMemoHeaderEntity entity) {
    return CreditMemoHeaderModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tostrId: entity.tostrId,
      docNum: entity.docNum,
      orderNo: entity.orderNo,
      tocusId: entity.tocusId,
      tohemId: entity.tohemId,
      transDate: entity.transDate,
      transTime: entity.transTime,
      timezone: entity.timezone,
      remarks: entity.remarks,
      subTotal: entity.subTotal,
      discPrctg: entity.discPrctg,
      discAmount: entity.discAmount,
      discountCard: entity.discountCard,
      coupon: entity.coupon,
      discountCoupun: entity.discountCoupun,
      taxPrctg: entity.taxPrctg,
      taxAmount: entity.taxAmount,
      addCost: entity.addCost,
      rounding: entity.rounding,
      grandTotal: entity.grandTotal,
      changed: entity.changed,
      totalPayment: entity.totalPayment,
      tocsrId: entity.tocsrId,
      docStatus: entity.docStatus,
      sync: entity.sync,
      syncCRM: entity.syncCRM,
      torinTohemId: entity.torinTohemId,
      refpos1: entity.refpos1,
      refpos2: entity.refpos2,
      voidTohemId: entity.voidTohemId,
      channel: entity.channel,
    );
  }
}
