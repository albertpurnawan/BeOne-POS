import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/down_payment_items_entity.dart';

const String tableDownPaymentItem = "tinv7";

class DownPaymentItemsFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toinvId,
    docNum,
    idNumber,
    toitmId,
    quantity,
    sellingPrice,
    totalAmount,
    taxPrctg,
    remarks,
    tovatId,
    includeTax,
    tovenId,
    tbitmId,
    tohemId,
    refpos2,
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String toinvId = 'toinvId';
  static const String docNum = 'docnum';
  static const String idNumber = 'idnumber';
  static const String toitmId = 'toitmId';
  static const String quantity = 'quantity';
  static const String sellingPrice = 'sellingprice';
  static const String totalAmount = 'totalamount';
  static const String taxPrctg = 'taxprctg';
  static const String remarks = 'remarks';
  static const String tovatId = 'tovatId';
  static const String includeTax = 'includetax';
  static const String tovenId = 'tovenId';
  static const String tbitmId = 'tbitmId';
  static const String tohemId = 'tohemId';
  static const String refpos2 = 'refpos2';
}

class DownPaymentItemsModel extends DownPaymentItemsEntity implements BaseModel {
  DownPaymentItemsModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toinvId,
    required super.docNum,
    required super.idNumber,
    required super.toitmId,
    required super.quantity,
    required super.sellingPrice,
    required super.totalAmount,
    required super.taxPrctg,
    required super.remarks,
    required super.tovatId,
    required super.includeTax,
    required super.tovenId,
    required super.tbitmId,
    required super.tohemId,
    required super.refpos2,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate?.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toinvId': toinvId,
      'docnum': docNum,
      'idnumber': idNumber,
      'toitmId': toitmId,
      'quantity': quantity,
      'sellingprice': sellingPrice,
      'totalamount': totalAmount,
      'taxprctg': taxPrctg,
      'remarks': remarks,
      'tovatId': tovatId,
      'includetax': includeTax,
      'tovenId': tovenId,
      'tbitmId': tbitmId,
      'tohemId': tohemId,
      'refpos2': refpos2,
    };
  }

  factory DownPaymentItemsModel.fromMap(Map<String, dynamic> map) {
    return DownPaymentItemsModel(
      docId: map['docid'] as String,
      createDate: map['createdate'] != null ? DateTime.parse(map['createdate'] as String).toLocal() : null,
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String).toLocal() : null,
      toinvId: map['toinvId'] != null ? map['toinvId'] as String : null,
      docNum: map['docnum'] as String,
      idNumber: map['idnumber'] as int,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      quantity: map['quantity'] as double,
      sellingPrice: map['sellingprice'] as double,
      totalAmount: map['totalamount'] as double,
      taxPrctg: map['taxprctg'] as double,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      tovatId: map['tovatId'] != null ? map['tovatId'] as String : null,
      includeTax: map['includetax'] as int,
      tovenId: map['tovenId'] != null ? map['tovenId'] as String : null,
      tbitmId: map['tbitmId'] != null ? map['tbitmId'] as String : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      refpos2: map['refpos2'] != null ? map['refpos2'] as String : null,
    );
  }

  factory DownPaymentItemsModel.fromMapRemote(Map<String, dynamic> map) {
    return DownPaymentItemsModel.fromMap({
      ...map,
      "quantity": map['quantity'].toDouble() as double,
      "sellingprice": map['sellingprice'].toDouble() as double,
      "discprctg": map['discprctg'].toDouble() as double,
      "discamount": map['discamount'].toDouble() as double,
      "totalamount": map['totalamount'].toDouble() as double,
      "taxprctg": map['taxprctg'].toDouble() as double,
    });
  }

  factory DownPaymentItemsModel.fromEntity(DownPaymentItemsEntity entity) {
    return DownPaymentItemsModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toinvId: entity.toinvId,
      docNum: entity.docNum,
      idNumber: entity.idNumber,
      toitmId: entity.toitmId,
      quantity: entity.quantity,
      sellingPrice: entity.sellingPrice,
      totalAmount: entity.totalAmount,
      taxPrctg: entity.taxPrctg,
      remarks: entity.remarks,
      tovatId: entity.tovatId,
      includeTax: entity.includeTax,
      tovenId: entity.tovenId,
      tbitmId: entity.tbitmId,
      tohemId: entity.tohemId,
      refpos2: entity.refpos2,
    );
  }
}
