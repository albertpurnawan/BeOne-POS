import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/holiday.dart';

const String tableHoliday = "tohld";

class HolidayFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    calendarCode,
    description,
    descriptionFrgn,
    fiscalYear,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String calendarCode = "calendarcode";
  static const String description = "description";
  static const String descriptionFrgn = "descriptionfrgn";
  static const String fiscalYear = "fiscalyear";
}

class HolidayModel extends HolidayEntity implements BaseModel {
  HolidayModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.calendarCode,
    required super.description,
    required super.descriptionFrgn,
    required super.fiscalYear,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'calendarcode': calendarCode,
      'description': description,
      'descriptionfrgn': descriptionFrgn,
      'fiscalyear': fiscalYear,
    };
  }

  factory HolidayModel.fromMap(Map<String, dynamic> map) {
    return HolidayModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      calendarCode: map['calendarcode'] as String,
      description: map['description'] as String,
      descriptionFrgn: map['descriptionfrgn'] as String,
      fiscalYear: map['fiscalyear'] as int,
    );
  }

  factory HolidayModel.fromEntity(HolidayEntity entity) {
    return HolidayModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      calendarCode: entity.calendarCode,
      description: entity.description,
      descriptionFrgn: entity.descriptionFrgn,
      fiscalYear: entity.fiscalYear,
    );
  }
}
