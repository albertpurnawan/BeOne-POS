import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/mop_by_store.dart';

const String tableMOPByStore = "tpmt3";

class MOPByStoreFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tpmt1Id,
    tostrId,
    form,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tpmt1Id = "tpmt1Id";
  static const String tostrId = "tostrId";
  static const String form = "form";
}

class MOPByStoreModel extends MOPByStoreEntity implements BaseModel {
  MOPByStoreModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tpmt1Id,
    required super.tostrId,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toLocal().toIso8601String(),
      'updatedate': updateDate?.toLocal().toIso8601String(),
      'tpmt1Id': tpmt1Id,
      'tostrId': tostrId,
      'form': form,
    };
  }

  factory MOPByStoreModel.fromMap(Map<String, dynamic> map) {
    return MOPByStoreModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate']).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate']).toLocal()
          : null,
      tpmt1Id: map['tpmt1Id'] != null ? map['tpmt1Id'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      form: map['form'] as String,
    );
  }

  factory MOPByStoreModel.fromMapRemote(Map<String, dynamic> map) {
    return MOPByStoreModel.fromMap({
      ...map,
      "tpmt1Id": map['tpmt1docid'] != null ? map['tpmt1docid'] as String : null,
      "tostrId": map['tostrdocid'] != null ? map['tostrdocid'] as String : null,
    });
  }

  factory MOPByStoreModel.fromEntity(MOPByStoreEntity entity) {
    return MOPByStoreModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tpmt1Id: entity.tpmt1Id,
      tostrId: entity.tostrId,
      form: entity.form,
    );
  }
}
