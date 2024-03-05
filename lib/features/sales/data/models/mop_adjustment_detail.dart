import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_adjustment_detail.dart';

const String tableMOPAdjustmentDetail = "mpad1";

class MOPAdjustmentDetailFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tmpadId,
    tpmt1Id,
    amount,
    tpmt3Id,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tmpadId = "tmpadId";
  static const String tpmt1Id = "tpmt1Id";
  static const String amount = "amount";
  static const String tpmt3Id = "tpmt3Id";
}

class MOPAdjustmentDetailModel extends MOPAdjustmentDetailEntity
    implements BaseModel {
  MOPAdjustmentDetailModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tmpadId,
    required super.tpmt1Id,
    required super.amount,
    required super.tpmt3Id,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tmpadId': tmpadId,
      'tpmt1Id': tpmt1Id,
      'amount': amount,
      'tpmt3Id': tpmt3Id,
    };
  }

  factory MOPAdjustmentDetailModel.fromMap(Map<String, dynamic> map) {
    return MOPAdjustmentDetailModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tmpadId: map['tmpadId'] != null ? map['tmpadId'] as String : null,
      tpmt1Id: map['tpmt1Id'] != null ? map['tpmt1Id'] as String : null,
      amount: map['amount'] as double,
      tpmt3Id: map['tpmt3Id'] != null ? map['tpmt3Id'] as String : null,
    );
  }

  factory MOPAdjustmentDetailModel.fromMapRemote(Map<String, dynamic> map) {
    return MOPAdjustmentDetailModel.fromMap({
      ...map,
      "tmpadId": map['tmpad_id']?['docid'] != null
          ? map['tmpad_id']['docid'] as String
          : null,
      "tpmt1Id": map['tpmt1_id']?['docid'] != null
          ? map['tpmt1_id']['docid'] as String
          : null,
      "tpmt3Id": map['tpmt3_id']?['docid'] != null
          ? map['tpmt3_id']['docid'] as String
          : null,
    });
  }

  factory MOPAdjustmentDetailModel.fromEntity(
      MOPAdjustmentDetailEntity entity) {
    return MOPAdjustmentDetailModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tmpadId: entity.tmpadId,
      tpmt1Id: entity.tpmt1Id,
      amount: entity.amount,
      tpmt3Id: entity.tpmt3Id,
    );
  }
}
