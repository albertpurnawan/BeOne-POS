import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/credit_memo_pay_means.dart';

const String tableCreditMemoPayMeans = "trin2";

class CreditMemoPayMeansFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    torinId,
    lineNum,
    tpmt3Id,
    amount,
    tpmt2Id,
    cardNo,
    cardHolder,
    sisaVoucher,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String torinId = "torinId";
  static const String lineNum = "linenum";
  static const String tpmt3Id = "tpmt3Id";
  static const String amount = "amount";
  static const String tpmt2Id = "tpmt2Id";
  static const String cardNo = "cardno";
  static const String cardHolder = "cardholder";
  static const String sisaVoucher = "sisavoucher";
}

class CreditMemoPayMeansModel extends CreditMemoPayMeansEntity
    implements BaseModel {
  CreditMemoPayMeansModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.torinId,
    required super.lineNum,
    required super.tpmt3Id,
    required super.amount,
    required super.tpmt2Id,
    required super.cardNo,
    required super.cardHolder,
    required super.sisaVoucher,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.millisecondsSinceEpoch,
      'updatedate': updateDate?.millisecondsSinceEpoch,
      'torinId': torinId,
      'linenum': lineNum,
      'tpmt3Id': tpmt3Id,
      'amount': amount,
      'tpmt2Id': tpmt2Id,
      'cardno': cardNo,
      'cardholder': cardHolder,
      'sisavoucher': sisaVoucher,
    };
  }

  factory CreditMemoPayMeansModel.fromMap(Map<String, dynamic> map) {
    return CreditMemoPayMeansModel(
      docId: map['docid'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createdate'] as int),
      updateDate: map['updatedate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedate'] as int)
          : null,
      torinId: map['torinId'] != null ? map['torinId'] as String : null,
      lineNum: map['linenum'] as int,
      tpmt3Id: map['tpmt3Id'] != null ? map['tpmt3Id'] as String : null,
      amount: map['amount'] as int,
      tpmt2Id: map['tpmt2Id'] != null ? map['tpmt2Id'] as String : null,
      cardNo: map['cardno'] != null ? map['cardno'] as String : null,
      cardHolder:
          map['cardholder'] != null ? map['cardholder'] as String : null,
      sisaVoucher:
          map['sisavoucher'] != null ? map['sisavoucher'] as double : null,
    );
  }

  factory CreditMemoPayMeansModel.fromMapRemote(Map<String, dynamic> map) {
    return CreditMemoPayMeansModel.fromMap({
      ...map,
      "torinId": map['torin_id']?['docid'] != null
          ? map['torin_id']['docid'] as String
          : null,
      "tpmt3Id": map['tpmt3_id']?['docid'] != null
          ? map['tpmt3_id']['docid'] as String
          : null,
      "tpmt2Id": map['tpmt2_id']?['docid'] != null
          ? map['tpmt2_id']['docid'] as String
          : null,
      "sisavoucher": map['sisavoucher'] != null
          ? map['sisavoucher'].toDouble() as double
          : null,
    });
  }

  factory CreditMemoPayMeansModel.fromEntity(CreditMemoPayMeansEntity entity) {
    return CreditMemoPayMeansModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      torinId: entity.torinId,
      lineNum: entity.lineNum,
      tpmt3Id: entity.tpmt3Id,
      amount: entity.amount,
      tpmt2Id: entity.tpmt2Id,
      cardNo: entity.cardNo,
      cardHolder: entity.cardHolder,
      sisaVoucher: entity.sisaVoucher,
    );
  }
}
