import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/user_logs.dart';

const String tableUserLogs = "golog";

class UserLogsFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    remarks,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String remarks = "remarks";
}

class UserLogsModel extends UserLogsEntity implements BaseModel {
  UserLogsModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.remarks,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'remarks': remarks,
    };
  }

  factory UserLogsModel.fromMap(Map<String, dynamic> map) {
    return UserLogsModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
    );
  }

  factory UserLogsModel.fromEntity(UserLogsEntity entity) {
    return UserLogsModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      remarks: entity.remarks,
    );
  }
}
