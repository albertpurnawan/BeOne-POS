import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/payment_type.dart';

const String tablePaymentType = "topmt";

class PaymentTypeFields {
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

class PaymentTypeModel extends PaymentTypeEntity implements BaseModel {
  PaymentTypeModel({
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
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'paytypecode': payTypeCode,
      'description': description,
    };
  }

  factory PaymentTypeModel.fromMap(Map<String, dynamic> map) {
    return PaymentTypeModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      payTypeCode: map['paytypecode'] as String,
      description: map['description'] as String,
    );
  }

  factory PaymentTypeModel.fromEntity(PaymentTypeEntity entity) {
    return PaymentTypeModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      payTypeCode: entity.payTypeCode,
      description: entity.description,
    );
  }
}
