import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/authorization.dart';

const String tableAuthorization = "toaut";

class AuthorizationFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    // tformId,
    tousrId,
    authorization,
    setBy,
    canView,
    canCreate,
    canUpdate,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  // static const String tformId = "tformId";
  static const String tousrId = "tousrId";
  static const String authorization = "authorization";
  static const String setBy = "setby";
  static const String canView = "canview";
  static const String canCreate = "cancreate";
  static const String canUpdate = "canupdate";
}

class AuthorizationModel extends AuthorizationEntity implements BaseModel {
  AuthorizationModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    // required super.tformId,
    required super.tousrId,
    required super.authorization,
    required super.setBy,
    required super.canView,
    required super.canCreate,
    required super.canUpdate,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      // 'tformId': tformId,
      'tousrId': tousrId,
      'authorization': authorization,
      'setby': setBy,
      'canview': canView,
      'cancreate': canCreate,
      'canupdate': canUpdate,
    };
  }

  factory AuthorizationModel.fromMap(Map<String, dynamic> map) {
    return AuthorizationModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      // tformId: map['tformId'] != null ? map['tformId'] as String : null,
      tousrId: map['tousrId'] != null ? map['tousrId'] as String : null,
      authorization: map['authorization'] as int,
      setBy: map['setby'] as int,
      canView: map['canview'] != null ? map['canview'] as int : null,
      canCreate: map['cancreate'] != null ? map['cancreate'] as int : null,
      canUpdate: map['canupdate'] != null ? map['canupdate'] as int : null,
    );
  }

  factory AuthorizationModel.fromMapRemote(Map<String, dynamic> map) {
    return AuthorizationModel.fromMap({
      ...map,
      // "tformId": map['tform_id']?['docid'] != null
      //     ? map['tform_id']['docid'] as String
      //     : null,
      "tousrId": map['tousr_id']?['docid'] != null
          ? map['tousr_id']['docid'] as String
          : null,
    });
  }

  factory AuthorizationModel.fromEntity(AuthorizationEntity entity) {
    return AuthorizationModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      // tformId: entity.tformId,
      tousrId: entity.tousrId,
      authorization: entity.authorization,
      setBy: entity.setBy,
      canView: entity.canView,
      canCreate: entity.canCreate,
      canUpdate: entity.canUpdate,
    );
  }
}
