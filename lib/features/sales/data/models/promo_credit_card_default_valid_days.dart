import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_credit_card_default_valid_days.dart';

const String tablePromoCreditCardDefaultValidDays = "tprc9";

class PromoCreditCardDefaultValidDaysFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprcId,
    day,
    status,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprcId = "toprcId";
  static const String day = "day";
  static const String status = "status";
}

class PromoCreditCardDefaultValidDaysModel
    extends PromoCreditCardDefaultValidDaysEntity implements BaseModel {
  PromoCreditCardDefaultValidDaysModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprcId,
    required super.day,
    required super.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprcId': toprcId,
      'day': day,
      'status': status,
    };
  }

  factory PromoCreditCardDefaultValidDaysModel.fromMap(
      Map<String, dynamic> map) {
    return PromoCreditCardDefaultValidDaysModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprcId: map['toprcId'] != null ? map['toprcId'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  factory PromoCreditCardDefaultValidDaysModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoCreditCardDefaultValidDaysModel.fromMap({
      ...map,
      "toprcId": map['toprc_id']?['docid'] != null
          ? map['toprc_id']['docid'] as String
          : null,
    });
  }

  factory PromoCreditCardDefaultValidDaysModel.fromEntity(
      PromoCreditCardDefaultValidDaysEntity entity) {
    return PromoCreditCardDefaultValidDaysModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprcId: entity.toprcId,
      day: entity.day,
      status: entity.status,
    );
  }
}
