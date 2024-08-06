import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/pay_means.dart';

const String tablePayMeans = "tinv2";

class PayMeansFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toinvId,
    lineNum,
    tpmt3Id,
    amount,
    tpmt2Id,
    cardNo,
    cardHolder,
    sisaVoucher,
    rrn,
    tpmt6Id,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toinvId = "toinvId";
  static const String lineNum = "linenum";
  static const String tpmt3Id = "tpmt3Id";
  static const String amount = "amount";
  static const String tpmt2Id = "tpmt2Id";
  static const String cardNo = "cardno";
  static const String cardHolder = "cardholder";
  static const String sisaVoucher = "sisavoucher";
  static const String rrn = "rrn";
  static const String tpmt6Id = "tpmt6dId";
}

class PayMeansModel extends PayMeantEntity implements BaseModel {
  PayMeansModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toinvId,
    required super.lineNum,
    required super.tpmt3Id,
    required super.amount,
    required super.tpmt2Id,
    required super.cardNo,
    required super.cardHolder,
    required super.sisaVoucher,
    required super.rrn,
    required super.tpmt6Id,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate?.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toinvId': toinvId,
      'linenum': lineNum,
      'tpmt3Id': tpmt3Id,
      'amount': amount,
      'tpmt2Id': tpmt2Id,
      'cardno': cardNo,
      'cardholder': cardHolder,
      'sisavoucher': sisaVoucher,
      'rrn': rrn,
      'tpmt6dId': tpmt6Id,
    };
  }

  factory PayMeansModel.fromMap(Map<String, dynamic> map) {
    return PayMeansModel(
      docId: map['docid'] as String,
      createDate: map['updatedate'] != null ? DateTime.parse(map['createdate'] as String).toLocal() : null,
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String).toLocal() : null,
      toinvId: map['toinvId'] != null ? map['toinvId'] as String : null,
      lineNum: map['linenum'] as int,
      tpmt3Id: map['tpmt3Id'] != null ? map['tpmt3Id'] as String : null,
      amount: map['amount'] as double,
      tpmt2Id: map['tpmt2Id'] != null ? map['tpmt2Id'] as String : null,
      cardNo: map['cardno'] != null ? map['cardno'] as String : null,
      cardHolder: map['cardholder'] != null ? map['cardholder'] as String : null,
      sisaVoucher: map['sisavoucher'] != null ? map['sisavoucher'] as double : null,
      rrn: map['rrn'] != null ? map['rrn'] as String : null,
      tpmt6Id: map['tpmt6dId'] != null ? map['tpmt6dId'] as String : null,
    );
  }

  factory PayMeansModel.fromMapRemote(Map<String, dynamic> map) {
    return PayMeansModel.fromMap({
      ...map,
      "toinvId": map['toinv_id']?['docid'] != null ? map['toinv_id']['docid'] as String : null,
      "tpmt3Id": map['tpmt3_id']?['docid'] != null ? map['tpmt3_id']['docid'] as String : null,
      "tpmt2Id": map['tpmt2_id']?['docid'] != null ? map['tpmt2_id']['docid'] as String : null,
      "amount": map['amount'].toDouble() as double,
      "sisavoucher": map['sisavoucher'] != null ? map['sisavoucher'].toDouble() as double : null,
    });
  }

  factory PayMeansModel.fromEntity(PayMeantEntity entity) {
    return PayMeansModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toinvId: entity.toinvId,
      lineNum: entity.lineNum,
      tpmt3Id: entity.tpmt3Id,
      amount: entity.amount,
      tpmt2Id: entity.tpmt2Id,
      cardNo: entity.cardNo,
      cardHolder: entity.cardHolder,
      sisaVoucher: entity.sisaVoucher,
      rrn: entity.rrn,
      tpmt6Id: entity.tpmt6Id,
    );
  }
}
