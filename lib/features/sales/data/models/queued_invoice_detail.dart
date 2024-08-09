import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/invoice_detail.dart';

const String tableQueuedInvoiceDetail = "queuedInvoiceDetails";

class QueuedInvoiceDetailFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toinvId,
    lineNum,
    docNum,
    idNumber,
    toitmId,
    quantity,
    sellingPrice,
    discPrctg,
    discAmount,
    totalAmount,
    taxPrctg,
    promotionType,
    promotionId,
    remarks,
    editTime,
    cogs,
    tovatId,
    promotionTingkat,
    promoVoucherNo,
    baseDocId,
    baseLineDocId,
    includeTax,
    tovenId,
    tbitmId,
    discHeaderAmount,
    tohemId,
    // subtotalAfterDiscHeader,
    //maybe need more to send to bos
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toinvId = "toinvId";
  static const String lineNum = "linenum";
  static const String docNum = "docnum";
  static const String idNumber = "idnumber";
  static const String toitmId = "toitmId";
  static const String quantity = "quantity";
  static const String sellingPrice = "sellingprice";
  static const String discPrctg = "discprctg";
  static const String discAmount = "discamount";
  static const String totalAmount = "totalamount";
  static const String taxPrctg = "taxprctg";
  static const String promotionType = "promotiontype";
  static const String promotionId = "promotionid";
  static const String remarks = "remarks";
  static const String editTime = "edittime";
  static const String cogs = "cogs";
  static const String tovatId = "tovatId";
  static const String promotionTingkat = "promotiontingkat";
  static const String promoVoucherNo = "promovoucherno";
  static const String baseDocId = "basedocid";
  static const String baseLineDocId = "baselinedocid";
  static const String includeTax = "includetax";
  static const String tovenId = "tovenId";
  static const String tbitmId = "tbitmId";
  static const String discHeaderAmount = "discheaderamount";
  static const String tohemId = "tohemId";
  // static const String subtotalAfterDiscHeader = "subtotalafterdischeader";
}

class QueuedInvoiceDetailModel extends InvoiceDetailEntity implements BaseModel {
  QueuedInvoiceDetailModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toinvId,
    required super.lineNum,
    required super.docNum,
    required super.idNumber,
    required super.toitmId,
    required super.quantity,
    required super.sellingPrice,
    required super.discPrctg,
    required super.discAmount,
    required super.totalAmount,
    required super.taxPrctg,
    required super.promotionType,
    required super.promotionId,
    required super.remarks,
    required super.editTime,
    required super.cogs,
    required super.tovatId,
    required super.promotionTingkat,
    required super.promoVoucherNo,
    required super.baseDocId,
    required super.baseLineDocId,
    required super.includeTax,
    required super.tovenId,
    required super.tbitmId,
    required super.discHeaderAmount,
    required super.tohemId,
    // required super.subtotalAfterDiscHeader,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate?.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toinvId': toinvId,
      'linenum': lineNum,
      'docnum': docNum,
      'idnumber': idNumber,
      'toitmId': toitmId,
      'quantity': quantity,
      'sellingprice': sellingPrice,
      'discprctg': discPrctg,
      'discamount': discAmount,
      'totalamount': totalAmount,
      'taxprctg': taxPrctg,
      'promotiontype': promotionType,
      'promotionid': promotionId,
      'remarks': remarks,
      'edittime': editTime.toUtc().toIso8601String(),
      'cogs': cogs,
      'tovatId': tovatId,
      'promotiontingkat': promotionTingkat,
      'promovoucherno': promoVoucherNo,
      'basedocid': baseDocId,
      'baselinedocid': baseLineDocId,
      'includetax': includeTax,
      'tovenId': tovenId,
      'tbitmId': tbitmId,
      'discheaderamount': discHeaderAmount,
      'tohemId': tohemId,

      // 'subtotalafterdischeader': subtotalAfterDiscHeader,
    };
  }

  factory QueuedInvoiceDetailModel.fromMap(Map<String, dynamic> map) {
    return QueuedInvoiceDetailModel(
      docId: map['docid'] as String,
      createDate: map['createdate'] != null ? DateTime.parse(map['createdate'] as String).toLocal() : null,
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String).toLocal() : null,
      toinvId: map['toinvId'] != null ? map['toinvId'] as String : null,
      lineNum: map['linenum'] as int,
      docNum: map['docnum'] as String,
      idNumber: map['idnumber'] as int,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      sellingPrice: map['sellingprice'] as double,
      discPrctg: map['discprctg'] as double,
      discAmount: map['discamount'] as double,
      totalAmount: map['totalamount'] as double,
      taxPrctg: map['taxprctg'] as double,
      promotionType: map['promotiontype'] as String,
      promotionId: map['promotionid'] as String,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      editTime: DateTime.parse(map['edittime'] as String).toLocal(),
      cogs: map['cogs'] as double,
      tovatId: map['tovatId'] != null ? map['tovatId'] as String : null,
      promotionTingkat: map['promotiontingkat'] != null ? map['promotiontingkat'] as String : null,
      promoVoucherNo: map['promovoucherno'] != null ? map['promovoucherno'] as String : null,
      baseDocId: map['basedocid'] != null ? map['basedocid'] as String : null,
      baseLineDocId: map['baselinedocid'] != null ? map['baselinedocid'] as String : null,
      includeTax: map['includetax'] as int,
      tovenId: map['tovenId'] != null ? map['tovenId'] as String : null,
      tbitmId: map['tbitmId'] != null ? map['tbitmId'] as String : null,
      discHeaderAmount: map['discheaderamount'] != null ? map['discheaderamount'] as double : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      // subtotalAfterDiscHeader: map['subtotalafterdischeader'] != null
      //     ? map['subtotalafterdischeader'] as double
      //     : null,
    );
  }

  factory QueuedInvoiceDetailModel.fromMapRemote(Map<String, dynamic> map) {
    return QueuedInvoiceDetailModel.fromMap({
      ...map,
      "toinvId": map['toinv_id']?['docid'] != null ? map['toinv_id']['docid'] as String : null,
      "toitmId": map['toitm_id']?['docid'] != null ? map['toitm_id']['docid'] as String : null,
      "tovatId": map['tovat_id']?['docid'] != null ? map['tovat_id']['docid'] as String : null,
      "tovenId": map['toven_id']?['docid'] != null ? map['toven_id']['docid'] as String : null,
      "tbitmId": map['tbitm_id']?['docid'] != null ? map['tbitm_id']['docid'] as String : null,
      "quantity": map['quantity'].toDouble() as double,
      "sellingprice": map['sellingprice'].toDouble() as double,
      "discprctg": map['discprctg'].toDouble() as double,
      "discamount": map['discamount'].toDouble() as double,
      "totalamount": map['totalamount'].toDouble() as double,
      "taxprctg": map['taxprctg'].toDouble() as double,
      "cogs": map['cogs'].toDouble() as double,
    });
  }

  factory QueuedInvoiceDetailModel.fromEntity(InvoiceDetailEntity entity) {
    return QueuedInvoiceDetailModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toinvId: entity.toinvId,
      lineNum: entity.lineNum,
      docNum: entity.docNum,
      idNumber: entity.idNumber,
      toitmId: entity.toitmId,
      quantity: entity.quantity,
      sellingPrice: entity.sellingPrice,
      discPrctg: entity.discPrctg,
      discAmount: entity.discAmount,
      totalAmount: entity.totalAmount,
      taxPrctg: entity.taxPrctg,
      promotionType: entity.promotionType,
      promotionId: entity.promotionId,
      remarks: entity.remarks,
      editTime: entity.editTime,
      cogs: entity.cogs,
      tovatId: entity.tovatId,
      promotionTingkat: entity.promotionTingkat,
      promoVoucherNo: entity.promoVoucherNo,
      baseDocId: entity.baseDocId,
      baseLineDocId: entity.baseLineDocId,
      includeTax: entity.includeTax,
      tovenId: entity.tovenId,
      tbitmId: entity.baseDocId,
      discHeaderAmount: entity.discHeaderAmount,
      tohemId: entity.tohemId,
      // subtotalAfterDiscHeader: entity.subtotalAfterDiscHeader,
    );
  }
}
