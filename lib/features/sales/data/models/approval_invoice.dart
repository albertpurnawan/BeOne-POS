import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/approval_invoice.dart';

const String tableApprovalInvoice = "tinv6";

class ApprovalInvoiceFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toinvId,
    tousrId,
    remarks,
    category,
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String toinvId = 'toinvId';
  static const String tousrId = 'tousrId';
  static const String remarks = 'remarks';
  static const String category = 'category';
}

class ApprovalInvoiceModel extends ApprovalInvoiceEntity implements BaseModel {
  ApprovalInvoiceModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toinvId,
    required super.tousrId,
    required super.remarks,
    required super.category,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toinvId': toinvId,
      'tousrId': tousrId,
      'remarks': remarks,
      'category': category,
    };
  }

  factory ApprovalInvoiceModel.fromMap(Map<String, dynamic> map) {
    return ApprovalInvoiceModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String).toLocal() : null,
      toinvId: map['toinvId'] != null ? map['toinvId'] as String : null,
      tousrId: map['tousrId'] as String,
      remarks: map['remarks'] as String,
      category: map['category'] as String,
    );
  }

  factory ApprovalInvoiceModel.fromEntity(ApprovalInvoiceEntity entity) {
    return ApprovalInvoiceModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toinvId: entity.toinvId,
      tousrId: entity.tousrId,
      remarks: entity.remarks,
      category: entity.category,
    );
  }
}
