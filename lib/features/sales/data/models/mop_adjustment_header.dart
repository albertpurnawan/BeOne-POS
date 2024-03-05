import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_adjustment_header.dart';

const String tableMOPAdjustmentHeader = "tmpad";

class MOPAdjustmentHeaderFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    docNum,
    docDate,
    docTime,
    timezone,
    posted,
    postDate,
    postTime,
    remarks,
    tostrId,
    sync,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String docNum = "docnum";
  static const String docDate = "docdate";
  static const String docTime = "doctime";
  static const String timezone = "timezone";
  static const String posted = "posted";
  static const String postDate = "postdate";
  static const String postTime = "posttime";
  static const String remarks = "remarks";
  static const String tostrId = "tostrId";
  static const String sync = "sync";
}

class MOPAdjustmentHeaderModel extends MOPAdjustmentHeaderEntity
    implements BaseModel {
  MOPAdjustmentHeaderModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.docNum,
    required super.docDate,
    required super.docTime,
    required super.timezone,
    required super.posted,
    required super.postDate,
    required super.postTime,
    required super.remarks,
    required super.tostrId,
    required super.sync,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'docnum': docNum,
      'docdate': docDate.toUtc().toIso8601String(),
      'doctime': docTime.toUtc().toIso8601String(),
      'timezone': timezone,
      'posted': posted,
      'postdate': postDate.toUtc().toIso8601String(),
      'posttime': postTime.toUtc().toIso8601String(),
      'remarks': remarks,
      'tostrId': tostrId,
      'sync': sync,
    };
  }

  factory MOPAdjustmentHeaderModel.fromMap(Map<String, dynamic> map) {
    return MOPAdjustmentHeaderModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      docNum: map['docnum'] as String,
      docDate: DateTime.parse(map['docdate'] as String).toLocal(),
      docTime: DateTime.parse(map['doctime'] as String).toLocal(),
      timezone: map['timezone'] as String,
      posted: map['posted'] as int,
      postDate: DateTime.parse(map['postdate'] as String).toLocal(),
      postTime: DateTime.parse(map['posttime'] as String).toLocal(),
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      sync: map['sync'] as int,
    );
  }

  factory MOPAdjustmentHeaderModel.fromMapRemote(Map<String, dynamic> map) {
    return MOPAdjustmentHeaderModel.fromMap({
      ...map,
      "tostrId": map['tostr_id']?['docid'] != null
          ? map['tostr_id']['docid'] as String
          : null,
    });
  }

  factory MOPAdjustmentHeaderModel.fromEntity(
      MOPAdjustmentHeaderEntity entity) {
    return MOPAdjustmentHeaderModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      docNum: entity.docNum,
      docDate: entity.docDate,
      docTime: entity.docTime,
      timezone: entity.timezone,
      posted: entity.posted,
      postDate: entity.postDate,
      postTime: entity.postTime,
      remarks: entity.remarks,
      tostrId: entity.tostrId,
      sync: entity.sync,
    );
  }
}
