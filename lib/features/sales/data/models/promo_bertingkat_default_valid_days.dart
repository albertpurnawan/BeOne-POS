import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/promo_bertingkat_default_valid_days.dart';

const String tablePromoBertingkatDefaulValidDays = "tprp9";

class PromoBertingkatDefaultValidDaysFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    toprpId,
    day,
    status,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String toprpId = "toprpId";
  static const String day = "day";
  static const String status = "status";
}

class PromoBertingkatDefaultValidDaysModel
    extends PromoBertingkatDefaultValidDaysEntity implements BaseModel {
  PromoBertingkatDefaultValidDaysModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.toprpId,
    required super.day,
    required super.status,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'toprpId': toprpId,
      'day': day,
      'status': status,
    };
  }

  factory PromoBertingkatDefaultValidDaysModel.fromMap(
      Map<String, dynamic> map) {
    return PromoBertingkatDefaultValidDaysModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      toprpId: map['toprpId'] != null ? map['toprpId'] as String : null,
      day: map['day'] as int,
      status: map['status'] as int,
    );
  }

  factory PromoBertingkatDefaultValidDaysModel.fromMapRemote(
      Map<String, dynamic> map) {
    return PromoBertingkatDefaultValidDaysModel.fromMap({
      ...map,
      "toprpId": map['toprp_id']?['docid'] != null
          ? map['toprp_id']['docid'] as String
          : null,
    });
  }

  factory PromoBertingkatDefaultValidDaysModel.fromEntity(
      PromoBertingkatDefaultValidDaysEntity entity) {
    return PromoBertingkatDefaultValidDaysModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      toprpId: entity.toprpId,
      day: entity.day,
      status: entity.status,
    );
  }
}
