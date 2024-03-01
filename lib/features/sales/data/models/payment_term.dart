import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/payment_term.dart';

const String tablePaymentTerm = "toptr";

class PaymentTermFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    paymentCode,
    description,
    base,
    dueon,
    statusActive,
    activated,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String paymentCode = "paymentcode";
  static const String description = "description";
  static const String base = "base";
  static const String dueon = "dueon";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
}

class PaymentTermModel extends PaymentTermEntity implements BaseModel {
  PaymentTermModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.paymentCode,
    required super.description,
    required super.base,
    required super.dueon,
    required super.statusActive,
    required super.activated,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.toLocal().toIso8601String(),
      'updateDate': updateDate?.toLocal().toIso8601String(),
      'paymentCode': paymentCode,
      'description': description,
      'base': base,
      'dueon': dueon,
      'statusActive': statusActive,
      'activated': activated,
    };
  }

  factory PaymentTermModel.fromMap(Map<String, dynamic> map) {
    return PaymentTermModel(
      docId: map['docId'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updateDate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      paymentCode: map['paymentCode'] as String,
      description: map['description'] as String,
      base: map['base'] as String,
      dueon: map['dueon'] as int,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
    );
  }

  factory PaymentTermModel.fromEntity(PaymentTermEntity entity) {
    return PaymentTermModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      paymentCode: entity.paymentCode,
      description: entity.description,
      base: entity.base,
      dueon: entity.dueon,
      statusActive: entity.statusActive,
      activated: entity.activated,
    );
  }
}
