import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/invoice_payment_other_voucher.dart';

const String tableIPOV = "tinv4";

class IPOVFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toinvId,
    type,
    serialNo,
    amount,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toinvId = "toinvId";
  static const String type = "type";
  static const String serialNo = "serialno";
  static const String amount = "amount";
}

class IPOVModel extends IPOVEntity implements BaseModel {
  IPOVModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toinvId,
    required super.type,
    required super.serialNo,
    required super.amount,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toinvId': toinvId,
      'type': type,
      'serialno': serialNo,
      'amount': amount,
    };
  }

  factory IPOVModel.fromMap(Map<String, dynamic> map) {
    return IPOVModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toinvId: map['toinvId'] != null ? map['toinvId'] as String : null,
      type: map['type'] as int,
      serialNo: map['serialno'] as String,
      amount: map['amount'] as double,
    );
  }

  factory IPOVModel.fromMapRemote(Map<String, dynamic> map) {
    return IPOVModel.fromMap({
      ...map,
      "toinvId": map['toinv_id']?['docid'] != null
          ? map['toinv_id']['docid'] as String
          : null,
      "amount": map['amount'].toDouble() as double,
    });
  }

  factory IPOVModel.fromEntity(IPOVEntity entity) {
    return IPOVModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toinvId: entity.toinvId,
      type: entity.type,
      serialNo: entity.serialNo,
      amount: entity.amount,
    );
  }
}
