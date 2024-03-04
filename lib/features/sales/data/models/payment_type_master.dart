import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/payment_type_master.dart';

const String tablePaymentTypeMaster = "gopmt";

class PaymentTypeMasterFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    payTypeCode,
    description,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String payTypeCode = "paytypecode";
  static const String description = "description";
}

class PaymentTypeMasterModel extends PaymentTypeMasterEntity
    implements BaseModel {
  PaymentTypeMasterModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.payTypeCode,
    required super.description,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'paytypecode': payTypeCode,
      'description': description,
    };
  }

  factory PaymentTypeMasterModel.fromMap(Map<String, dynamic> map) {
    return PaymentTypeMasterModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      payTypeCode: map['paytypecode'] as String,
      description: map['description'] as String,
    );
  }

  factory PaymentTypeMasterModel.fromEntity(PaymentTypeMasterEntity entity) {
    return PaymentTypeMasterModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      payTypeCode: entity.payTypeCode,
      description: entity.description,
    );
  }
}
