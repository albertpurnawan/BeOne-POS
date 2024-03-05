import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_credit_card_valid_days.dart';

const String tablePromoCreditCardValidDays = "tprc3";

class PromoCreditCardValidDaysFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tprc2Id,
    day,
    status,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tprc2Id = "tprc2Id";
  static const String day = "day";
  static const String status = "status";
}

class PromoCreditCardValidDaysModel extends PromoCreditCardValidDaysEntity
    implements BaseModel {
  PromoCreditCardValidDaysModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tprc2Id,
    required super.day,
    required super.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tprc2Id': tprc2Id,
      'day': day,
      'status': status,
    };
  }

  factory PromoCreditCardValidDaysModel.fromMap(Map<String, dynamic> map) {
    return PromoCreditCardValidDaysModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tprc2Id: map['tprc2Id'] != null ? map['tprc2Id'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  factory PromoCreditCardValidDaysModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoCreditCardValidDaysModel.fromMap({
      ...map,
      "tprc2Id": map['tprc2_id']?['docid'] != null
          ? map['tprc2_id']['docid'] as String
          : null,
    });
  }

  factory PromoCreditCardValidDaysModel.fromEntity(
      PromoCreditCardValidDaysEntity entity) {
    return PromoCreditCardValidDaysModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tprc2Id: entity.tprc2Id,
      day: entity.day,
      status: entity.status,
    );
  }
}
