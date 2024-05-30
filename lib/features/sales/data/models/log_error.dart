import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/log_error.dart';

const String tableLogError = "toerr";

class LogErrorFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    processInfo,
    description,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String processInfo = "processinfo";
  static const String description = "description";
}

class LogErrorModel extends LogErrorEntity implements BaseModel {
  LogErrorModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.processInfo,
    required super.description,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'processinfo': processInfo,
      'description': description,
    };
  }

  factory LogErrorModel.fromMap(Map<String, dynamic> map) {
    return LogErrorModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      processInfo: map['processinfo'] as String,
      description: map['description'] as String,
    );
  }

  factory LogErrorModel.fromEntity(LogErrorEntity entity) {
    return LogErrorModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      processInfo: entity.processInfo,
      description: entity.description,
    );
  }
}
