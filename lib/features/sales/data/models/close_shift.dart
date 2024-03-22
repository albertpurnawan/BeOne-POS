import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/close_shift.dart';

const String tableCloseShift = "closeShift";

class CloseShiftFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tocsrId,
    tohemId,
    closeDate,
    closeTime,
    timezone,
    expectedCash,
    actualCash,
    approvalStatus,
    approvedBy,
  ];
  static const String docId = "docid ";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tocsrId = "tocsrId";
  static const String tohemId = "tohemId";
  static const String closeDate = "closedate";
  static const String closeTime = "closetime";
  static const String timezone = "timezone";
  static const String expectedCash = "expectedcash";
  static const String actualCash = "actualcash";
  static const String approvalStatus = "approvalstatus";
  static const String approvedBy = "approvedby";
}

class CloseShiftModel extends CloseShiftEntity implements BaseModel {
  CloseShiftModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tocsrId,
    required super.tohemId,
    required super.closeDate,
    required super.closeTime,
    required super.timezone,
    required super.expectedCash,
    required super.actualCash,
    required super.approvalStatus,
    required super.approvedBy,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.toUtc().toIso8601String(),
      'updateDate': updateDate?.toUtc().toIso8601String(),
      'tocsrId': tocsrId,
      'tohemId': tohemId,
      'closeDate': closeDate.toUtc().toIso8601String(),
      'closeTime': closeTime.toUtc().toIso8601String(),
      'timezone': timezone,
      'expectedCash': expectedCash,
      'actualCash': actualCash,
      'approvalStatus': approvalStatus,
      'approvedBy': approvedBy,
    };
  }

  factory CloseShiftModel.fromMap(Map<String, dynamic> map) {
    return CloseShiftModel(
      docId: map['docId'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updateDate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      tocsrId: map['tocsrId'] != null ? map['tocsrId'] as String : null,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      closeDate: DateTime.parse(map['closedate'] as String).toLocal(),
      closeTime: DateTime.parse(map['closetime'] as String).toLocal(),
      timezone: map['timezone'] as String,
      expectedCash: map['expectedCash'].toDouble() as double,
      actualCash: map['actualCash'].toDouble() as double,
      approvalStatus: map['approvalStatus'] as int,
      approvedBy:
          map['approvedBy'] != null ? map['approvedBy'] as String : null,
    );
  }

  factory CloseShiftModel.fromEntity(CloseShiftEntity entity) {
    return CloseShiftModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tocsrId: entity.tocsrId,
      tohemId: entity.tohemId,
      closeDate: entity.closeDate,
      closeTime: entity.closeTime,
      timezone: entity.timezone,
      expectedCash: entity.expectedCash,
      actualCash: entity.actualCash,
      approvalStatus: entity.approvalStatus,
      approvedBy: entity.approvedBy,
    );
  }
}
