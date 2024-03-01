import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_by_store.dart';

const String tableMOPByStore = "tpmt3";

class MOPByStoreFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tpmt1id,
    tostrId,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tpmt1id = "tpmt1Id";
  static const String tostrId = "tostrId";
}

class MOPByStoreModel extends MOPByStoreEntity implements BaseModel {
  MOPByStoreModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tpmt1id,
    required super.tostrId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'tpmt1id': tpmt1id,
      'tostrId': tostrId,
    };
  }

  factory MOPByStoreModel.fromMap(Map<String, dynamic> map) {
    return MOPByStoreModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      tpmt1id: map['tpmt1id'] != null ? map['tpmt1id'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
    );
  }

  factory MOPByStoreModel.fromMapRemote(Map<String, dynamic> map) {
    return MOPByStoreModel.fromMap({
      ...map,
      "tpmt1Id": map['tpmt1_id']['docid'] != null
          ? map['tpmt1_id']['docid'] as String
          : null,
      "tostrId": map['tostr_id']['docid'] != null
          ? map['tostr_id']['docid'] as String
          : null,
    });
  }

  factory MOPByStoreModel.fromEntity(MOPByStoreEntity entity) {
    return MOPByStoreModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tpmt1id: entity.tpmt1id,
      tostrId: entity.tostrId,
    );
  }
}
