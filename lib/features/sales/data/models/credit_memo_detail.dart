import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/credit_memo_detail.dart';

const String tableCreditMemoDetail = "trin1";

class CreditMemoDetailFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    torinId,
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
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String torinId = "torinId";
  static const String lineNum = "linenum";
  static const String docNum = "docnum";
  static const String idNumber = "idnumber";
  static const String toitmId = "toitmid";
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
}

class CreditMemoDetailModel extends CreditMemoDetailEntity
    implements BaseModel {
  CreditMemoDetailModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.torinId,
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
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'torinId': torinId,
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
      'promoVoucherno': promoVoucherNo,
      'basedocid': baseDocId,
      'baselinedocid': baseLineDocId,
      'includetax': includeTax,
      'tovenId': tovenId,
      'tbitmId': tbitmId,
    };
  }

  factory CreditMemoDetailModel.fromMap(Map<String, dynamic> map) {
    return CreditMemoDetailModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      torinId: map['torinId'] != null ? map['torinId'] as String : null,
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
      promotionTingkat: map['promotiontingkat'] != null
          ? map['promotiontingkat'] as String
          : null,
      promoVoucherNo: map['promoVoucherno'] != null
          ? map['promoVoucherno'] as String
          : null,
      baseDocId: map['basedocid'] != null ? map['basedocid'] as String : null,
      baseLineDocId:
          map['baselinedocid'] != null ? map['baselinedocid'] as String : null,
      includeTax: map['includetax'] as int,
      tovenId: map['tovenId'] != null ? map['tovenId'] as String : null,
      tbitmId: map['tbitmId'] != null ? map['tbitmId'] as String : null,
    );
  }

  factory CreditMemoDetailModel.fromMapRemote(Map<String, dynamic> map) {
    return CreditMemoDetailModel.fromMap({
      ...map,
      "torinId": map['torin_id']?['docid'] != null
          ? map['torin_id']['docid'] as String
          : null,
      "toitmId": map['toitm_id']?['docid'] != null
          ? map['toitm_id']['docid'] as String
          : null,
      "tovatId": map['tovat_id']?['docid'] != null
          ? map['tovat_id']['docid'] as String
          : null,
      "tovenId": map['toven_id']?['docid'] != null
          ? map['toven_id']['docid'] as String
          : null,
      "tbitmId": map['tbitm_id']?['docid'] != null
          ? map['tbitm_id']['docid'] as String
          : null,
      "quantity": map['quantity'].toDouble() as double,
      "sellingPrice": map['sellingprice'].toDouble() as double,
      "discPrctg": map['discprctg'].toDouble() as double,
      "discAmount": map['discamount'].toDouble() as double,
      "totalAmount": map['totalamount'].toDouble() as double,
      "taxPrctg": map['taxprctg'].toDouble() as double,
      "cogs": map['cogs'].toDouble() as double,
    });
  }

  factory CreditMemoDetailModel.fromEntity(CreditMemoDetailEntity entity) {
    return CreditMemoDetailModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      torinId: entity.torinId,
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
      baseLineDocId: entity.promotionType,
      includeTax: entity.includeTax,
      tovenId: entity.tovenId,
      tbitmId: entity.tbitmId,
    );
  }
}
