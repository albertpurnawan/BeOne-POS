import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/batch_invoice.dart';

const String tableBatchInvoice = "tinv3";

class BatchInvoiceFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tinv1Docid,
    toitmId,
    batchNo,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tinv1Docid = "tinv1Docid";
  static const String toitmId = "toitmId";
  static const String batchNo = "batchno";
}

class BatchInvoiceModel extends BatchInvoiceEntity implements BaseModel {
  BatchInvoiceModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tinv1Docid,
    required super.toitmId,
    required super.batchNo,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tinv1Docid': tinv1Docid,
      'toitmId': toitmId,
      'batchno': batchNo,
    };
  }

  factory BatchInvoiceModel.fromMap(Map<String, dynamic> map) {
    return BatchInvoiceModel(
      docId: map['docId'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tinv1Docid:
          map['tinv1Docid'] != null ? map['tinv1Docid'] as String : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      batchNo: map['batchno'] as String,
    );
  }

  factory BatchInvoiceModel.fromMapRemote(Map<String, dynamic> map) {
    return BatchInvoiceModel.fromMap({
      ...map,
      "tinv1Docid": map['tinv1_id']?['docid'] != null
          ? map['tinv1_id']['docid'] as String
          : null,
      "toitmId": map['toitm_id']?['docid'] != null
          ? map['toitm_id']['docid'] as String
          : null,
    });
  }

  factory BatchInvoiceModel.fromEntity(BatchInvoiceEntity entity) {
    return BatchInvoiceModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tinv1Docid: entity.tinv1Docid,
      toitmId: entity.toitmId,
      batchNo: entity.batchNo,
    );
  }
}
