import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/holiday_detail.dart';

const String tableHolidayDetail = "thld1";

class HolidayDetailFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tohldId,
    holidayDate,
    description,
    descriptionFrgn,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tohldId = "tohldId";
  static const String holidayDate = "holidaydate";
  static const String description = "description";
  static const String descriptionFrgn = "descriptionfrgn";
}

class HolidayDetailModel extends HolidayDetailEntity implements BaseModel {
  HolidayDetailModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tohldId,
    required super.holidayDate,
    required super.description,
    required super.descriptionFrgn,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tohldId': tohldId,
      'holidaydate': holidayDate.millisecondsSinceEpoch,
      'description': description,
      'descriptionfrgn': descriptionFrgn,
    };
  }

  factory HolidayDetailModel.fromMap(Map<String, dynamic> map) {
    return HolidayDetailModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tohldId: map['tohldId'] != null ? map['tohldId'] as String : null,
      holidayDate: DateTime.parse(map['holidaydate'] as String).toLocal(),
      description: map['description'] as String,
      descriptionFrgn: map['descriptionfrgn'] as String,
    );
  }

  factory HolidayDetailModel.fromMapRemote(Map<String, dynamic> map) {
    return HolidayDetailModel.fromMap({
      ...map,
      "tohldId": map['tohld_id']?['docid'] != null
          ? map['tohld_id']['docid'] as String
          : null,
    });
  }

  factory HolidayDetailModel.fromEntity(HolidayDetailEntity entity) {
    return HolidayDetailModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tohldId: entity.tohldId,
      holidayDate: entity.holidayDate,
      description: entity.description,
      descriptionFrgn: entity.descriptionFrgn,
    );
  }
}
