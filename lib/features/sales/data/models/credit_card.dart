import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/credit_card.dart';

const String tableCC = "tpmt2";

class CreditCardFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    ccCode,
    description,
    cardType,
    statusActive,
    activated,
    tpmt5Id,
    form,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String ccCode = "cccode";
  static const String description = "description";
  static const String cardType = "cardtype";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
  static const String tpmt5Id = "tpmt5Id";
  static const String form = "form";
}

class CreditCardModel extends CreditCardEntity implements BaseModel {
  CreditCardModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.ccCode,
    required super.description,
    required super.cardType,
    required super.statusActive,
    required super.activated,
    required super.tpmt5Id,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'cccode': ccCode,
      'description': description,
      'cardtype': cardType,
      'statusactive': statusActive,
      'activated': activated,
      'tpmt5Id': tpmt5Id,
      'form': form,
    };
  }

  factory CreditCardModel.fromMap(Map<String, dynamic> map) {
    return CreditCardModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      ccCode: map['cccode'] as String,
      description: map['description'] as String,
      cardType: map['cardtype'] as int,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      tpmt5Id: map['tpmt5Id'] != null ? map['tpmt5Id'] as String : null,
      form: map['form'] as String,
    );
  }

  factory CreditCardModel.fromMapRemote(Map<String, dynamic> map) {
    return CreditCardModel.fromMap({
      ...map,
      "tpmt5Id": map['bankissuedocid'] != null
          ? map['bankissuedocid'] as String
          : null,
    });
  }

  factory CreditCardModel.fromEntity(CreditCardEntity entity) {
    return CreditCardModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      ccCode: entity.ccCode,
      description: entity.description,
      cardType: entity.cardType,
      statusActive: entity.statusActive,
      activated: entity.activated,
      tpmt5Id: entity.tpmt5Id,
      form: entity.form,
    );
  }
}
