import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_buy_x_get_y_valid_days.dart';

const String tablePromoBuyXGetYValidDays = "tprb3";

class PromoBuyXGetYValidDaysFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tprb2Id,
    day,
    status,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tprb2Id = "tprb2Id";
  static const String day = "day";
  static const String status = "status";
}

class PromoBuyXGetYValidDaysModel extends PromoBuyXGetYValidDaysEntity
    implements BaseModel {
  PromoBuyXGetYValidDaysModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tprb2Id,
    required super.day,
    required super.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tprb2Id': tprb2Id,
      'day': day,
      'status': status,
    };
  }

  factory PromoBuyXGetYValidDaysModel.fromMap(Map<String, dynamic> map) {
    return PromoBuyXGetYValidDaysModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tprb2Id: map['tprb2Id'] != null ? map['tprb2Id'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  factory PromoBuyXGetYValidDaysModel.fromMapRemote(Map<String, dynamic> map) {
    return PromoBuyXGetYValidDaysModel.fromMap({
      ...map,
      "tprb2Id": map['tprb2docid'] != null ? map['tprb2docid'] as String : null,
    });
  }

  factory PromoBuyXGetYValidDaysModel.fromEntity(
      PromoBuyXGetYValidDaysEntity entity) {
    return PromoBuyXGetYValidDaysModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tprb2Id: entity.tprb2Id,
      day: entity.day,
      status: entity.status,
    );
  }
}
