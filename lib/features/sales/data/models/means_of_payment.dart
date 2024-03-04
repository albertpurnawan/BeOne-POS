import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/means_of_payment.dart';

const String tableMOP = "tpmt1";

class MeansOfPaymentFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    topmtId,
    mopCode,
    description,
    mopAlias,
    bankCharge,
    consolidation,
    credit,
    subType,
    validForEmp,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String topmtId = "topmtId";
  static const String mopCode = "mopcode";
  static const String description = "description";
  static const String mopAlias = "mopalias";
  static const String bankCharge = "bankcharge";
  static const String consolidation = "consolidation";
  static const String credit = "credit";
  static const String subType = "subtype";
  static const String validForEmp = "validforemp";
}

class MeansOfPaymentModel extends MeansOfPaymentEntity implements BaseModel {
  MeansOfPaymentModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.topmtId,
    required super.mopCode,
    required super.description,
    required super.mopAlias,
    required super.bankCharge,
    required super.consolidation,
    required super.credit,
    required super.subType,
    required super.validForEmp,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'topmtId': topmtId,
      'mopcode': mopCode,
      'description': description,
      'mopalias': mopAlias,
      'bankcharge': bankCharge,
      'consolidation': consolidation,
      'credit': credit,
      'subtype': subType,
      'validforemp': validForEmp,
    };
  }

  factory MeansOfPaymentModel.fromMap(Map<String, dynamic> map) {
    return MeansOfPaymentModel(
      docId: map['docid'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createdate'] as int),
      updateDate: map['updatedate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedate'] as int)
          : null,
      topmtId: map['topmtId'] != null ? map['topmtId'] as String : null,
      mopCode: map['mopcode'] as String,
      description: map['description'] as String,
      mopAlias: map['mopalias'] as String,
      bankCharge: map['bankcharge'] as double,
      consolidation: map['consolidation'] as int,
      credit: map['credit'] as int,
      subType: map['subtype'] as int,
      validForEmp: map['validforemp'] as int,
    );
  }

  factory MeansOfPaymentModel.fromMapRemote(Map<String, dynamic> map) {
    return MeansOfPaymentModel.fromMap({
      ...map,
      "topmtId": map['topmt_id']['docid'] != null
          ? map['topmt_id']['docid'] as String
          : null,
      "bankcharge": map['bankcharge'].toDouble() as double,
    });
  }

  factory MeansOfPaymentModel.fromEntity(MeansOfPaymentEntity entity) {
    return MeansOfPaymentModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      topmtId: entity.topmtId,
      mopCode: entity.mopCode,
      description: entity.description,
      mopAlias: entity.mopAlias,
      bankCharge: entity.bankCharge,
      consolidation: entity.consolidation,
      credit: entity.credit,
      subType: entity.subType,
      validForEmp: entity.validForEmp,
    );
  }
}