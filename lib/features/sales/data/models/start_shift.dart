import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/start_shift.dart';

const String tableStartShift = "startShift";

class StartShiftFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tocsrId,
    tohemId,
    startDate,
    startTime,
    timezone,
    startingCash,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tocsrId = "tocsrId";
  static const String tohemId = "tohemId";
  static const String startDate = "startdate";
  static const String startTime = "starttime";
  static const String timezone = "timezone";
  static const String startingCash = "startingcash";
}

class StartShiftModel extends StartShiftEntity implements BaseModel {
  StartShiftModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tocsrId,
    required super.tohemId,
    required super.startDate,
    required super.startTime,
    required super.timezone,
    required super.startingCash,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.toUtc().toIso8601String(),
      'updateDate': updateDate?.toUtc().toIso8601String(),
      'tocsrId': tocsrId,
      'tohemId': tohemId,
      'startDate': startDate.toUtc().toIso8601String(),
      'startTime': startTime.toUtc().toIso8601String(),
      'timezone': timezone,
      'startingCash': startingCash,
    };
  }

  factory StartShiftModel.fromMap(Map<String, dynamic> map) {
    return StartShiftModel(
      docId: map['docId'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updateDate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tocsrId: map['tocsrId'] != null ? map['tocsrId'] as String : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      startDate: DateTime.parse(map['startdate'] as String).toLocal(),
      startTime: DateTime.parse(map['starttime'] as String).toLocal(),
      timezone: map['timezone'] as String,
      startingCash: map['startingCash'].toDouble() as double,
    );
  }

  factory StartShiftModel.fromEntity(StartShiftEntity entity) {
    return StartShiftModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tocsrId: entity.tocsrId,
      tohemId: entity.tohemId,
      startDate: entity.startDate,
      startTime: entity.startTime,
      timezone: entity.timezone,
      startingCash: entity.startingCash,
    );
  }
}
