import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_bertingkat_valid_days.dart';

const String tablePromoBertingkatValidDays = "tprp3";

class PromoBertingkatValidDaysFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tprp2Id,
    day,
    status,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tprp2Id = "tprp2Id";
  static const String day = "day";
  static const String status = "status";
}

class PromoBertingkatValidDaysModel extends PromoBertingkatValidDaysEntity
    implements BaseModel {
  PromoBertingkatValidDaysModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tprp2Id,
    required super.day,
    required super.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tprp2Id': tprp2Id,
      'day': day,
      'status': status,
    };
  }

  factory PromoBertingkatValidDaysModel.fromMap(Map<String, dynamic> map) {
    return PromoBertingkatValidDaysModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tprp2Id: map['tprp2Id'] != null ? map['tprp2Id'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  factory PromoBertingkatValidDaysModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoBertingkatValidDaysModel.fromMap({
      ...map,
      "tprp21Id": map['tprp21_id']?['docid'] != null
          ? map['tprp21_id']['docid'] as String
          : null,
    });
  }

  factory PromoBertingkatValidDaysModel.fromEntity(
      PromoBertingkatValidDaysEntity entity) {
    return PromoBertingkatValidDaysModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tprp2Id: entity.tprp2Id,
      day: entity.day,
      status: entity.status,
    );
  }
}
