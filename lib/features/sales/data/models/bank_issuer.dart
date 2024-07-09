import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/bank_issuer.dart';

const String tableBankIssuer = "tpmt5";

class BankIssuerFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    bankCode,
    description,
    form,
  ];

  static const String docId = 'docid';
  static const String createDate = 'createdate';
  static const String updateDate = 'updatedate';
  static const String bankCode = 'bankcode';
  static const String description = 'description';
  static const String form = 'form';
}

class BankIssuerModel extends BankIssuerEntity implements BaseModel {
  BankIssuerModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.bankCode,
    required super.description,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'bankcode': bankCode,
      'description': description,
      'form': form,
    };
  }

  factory BankIssuerModel.fromMap(Map<String, dynamic> map) {
    return BankIssuerModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      bankCode: map['bankcode'] as String,
      description: map['description'] as String,
      form: map['form'] as String,
    );
  }

  factory BankIssuerModel.fromMapRemote(Map<String, dynamic> map) {
    return BankIssuerModel.fromMap({
      ...map,
      "description": map['descriptionn'] as String,
    });
  }

  factory BankIssuerModel.fromEntity(BankIssuerEntity entity) {
    return BankIssuerModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      bankCode: entity.bankCode,
      description: entity.description,
      form: entity.form,
    );
  }
}
