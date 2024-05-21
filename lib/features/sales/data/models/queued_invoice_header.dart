import 'package:intl/intl.dart';
import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/invoice_header.dart';

const String tableQueuedInvoiceHeader = "queuedInvoiceHeaders";

class QueuedInvoiceHeaderFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tostrId,
    docnum,
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
    toinvTohemId,
    tcsr1Id,
    tcsr1Id,
    tcsr1Id,
    discHeaderManual,
    discHeaderPromo,
    syncToBos,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tostrId = "tostrId";
  static const String docnum = "docnum";
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
  static const String discountCoupun = "discountcoupun";
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
  static const String toinvTohemId = "toinvTohemId";
  static const String tcsr1Id = "tcsr1Id";
  static const String discHeaderManual = "discheadermanual";
  static const String discHeaderPromo = "discheaderpromo";
  static const String syncToBos = "synctobos";
}

class QueuedInvoiceHeaderModel extends InvoiceHeaderEntity
    implements BaseModel {
  QueuedInvoiceHeaderModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tostrId,
    required super.docnum,
    required super.orderNo,
    required super.tocusId,
    required super.tohemId,
    required super.transDateTime,
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
    required super.toinvTohemId,
    required super.tcsr1Id,
    required super.discHeaderManual,
    required super.discHeaderPromo,
    required super.syncToBos,
  });

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'docid': docId,
      'createdate': createDate?.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tostrId': tostrId,
      'docnum': docnum,
      'orderno': orderNo,
      'tocusId': tocusId,
      'tohemId': tohemId,
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
      'toinvTohemId': toinvTohemId,
      'tcsr1Id': tcsr1Id,
      'discheadermanual': discHeaderManual,
      'discheaderpromo': discHeaderPromo,
      'synctobos': syncToBos,
    };
    if (transDateTime == null) {
      return map;
    } else {
      return {
        ...map,
        'transdate': DateFormat('yyyy-MM-dd').format(transDateTime!.toUtc()),
        'transtime': DateFormat.Hms().format(transDateTime!.toUtc()),
      };
    }
  }

  factory QueuedInvoiceHeaderModel.fromMap(Map<String, dynamic> map) {
    return QueuedInvoiceHeaderModel(
      docId: map['docid'] as String,
      createDate: map['createdate'] != null
          ? DateTime.parse(map['createdate'] as String).toLocal()
          : null,
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      docnum: map['docnum'] as String,
      orderNo: map['orderno'] as int,
      tocusId: map['tocusId'] != null ? map['tocusId'] as String : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      transDateTime: map['transdate'] != null && map['transtime'] != null
          ? DateTime.parse("${map['transdate']} ${map['transtime']}Z").toLocal()
          : null,
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
      toinvTohemId:
          map['toinvTohemId'] != null ? map['toinvTohemId'] as String : null,
      tcsr1Id: map['tcsr1Id'] != null ? map['tcsr1Id'] as String : null,
      discHeaderManual: map['discheadermanual'] != null
          ? map['discheadermanual'] as double
          : null,
      discHeaderPromo: map['discheaderpromo'] != null
          ? map['discheaderpromo'] as double
          : null,
      syncToBos: map['synctobos'] as int,
    );
  }

  factory QueuedInvoiceHeaderModel.fromMapRemote(Map<String, dynamic> map) {
    return QueuedInvoiceHeaderModel.fromMap({
      ...map,
      // "tostrId": map['tostr_id']?['docid'] != null
      //     ? map['tostr_id']['docid'] as String
      //     : null,
      // "tocusId": map['tocus_id']?['docid'] != null
      //     ? map['tocus_id']['docid'] as String
      //     : null,
      // "tohemId": map['tohem_id']?['docid'] != null
      //     ? map['tohem_id']['docid'] as String
      //     : null,
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
      // "tocsrId": map['tocsr_id']?['docid'] != null
      //     ? map['tocsr_id']['docid'] as String
      //     : null,
      // "toinvTohemId": map['tohem_id']?['docid'] != null
      //     ? map['tohem_id']['docid'] as String
      //     : null,
    });
  }

  factory QueuedInvoiceHeaderModel.fromEntity(InvoiceHeaderEntity entity) {
    return QueuedInvoiceHeaderModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tostrId: entity.tostrId,
      docnum: entity.docnum,
      orderNo: entity.orderNo,
      tocusId: entity.tocusId,
      tohemId: entity.tohemId,
      transDateTime: entity.transDateTime,
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
      toinvTohemId: entity.toinvTohemId,
      tcsr1Id: entity.tcsr1Id,
      discHeaderManual: entity.discHeaderManual,
      discHeaderPromo: entity.discHeaderPromo,
      syncToBos: entity.syncToBos,
    );
  }
}
