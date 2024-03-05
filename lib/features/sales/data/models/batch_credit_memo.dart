import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/batch_credit_memo.dart';

const String tableBatchCreditMemo = "trin3";

class BatchCreditMemoFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    trin1Docid,
    toitmId,
    batchNo,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String trin1Docid = "trin1Docid";
  static const String toitmId = "toitmId";
  static const String batchNo = "batchno";
}

class BatchCreditMemoModel extends BatchCreditMemoEntity implements BaseModel {
  BatchCreditMemoModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.trin1Docid,
    required super.toitmId,
    required super.batchNo,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'trin1Docid': trin1Docid,
      'toitmId': toitmId,
      'batchno': batchNo,
    };
  }

  factory BatchCreditMemoModel.fromMap(Map<String, dynamic> map) {
    return BatchCreditMemoModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      trin1Docid:
          map['trin1Docid'] != null ? map['trin1Docid'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      batchNo: map['batchno'] as String,
    );
  }

  factory BatchCreditMemoModel.fromMapRemote(Map<String, dynamic> map) {
    return BatchCreditMemoModel.fromMap({
      ...map,
      "trin1Docid": map['trin1_id']?['docid'] != null
          ? map['trin1_id']['docid'] as String
          : null,
      "toitmId": map['toitm_id']?['docid'] != null
          ? map['toitm_id']['docid'] as String
          : null,
    });
  }

  factory BatchCreditMemoModel.fromEntity(BatchCreditMemoEntity entity) {
    return BatchCreditMemoModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      trin1Docid: entity.trin1Docid,
      toitmId: entity.toitmId,
      batchNo: entity.batchNo,
    );
  }
}
