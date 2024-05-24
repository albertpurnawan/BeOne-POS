import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/authentication_store.dart';

const String tableAuthStore = "tastr";

class AuthStoreFields {
  static const List<String> values = [
    docid,
    createdate,
    updatedate,
    tostrdocid,
    tousrdocid,
  ];
  static const String docid = "docid";
  static const String createdate = "createdate";
  static const String updatedate = "updatedate";
  static const String tostrdocid = "tostrdocid";
  static const String tousrdocid = "tousrdocid";
}

class AuthStoreModel extends AuthStoreEntity implements BaseModel {
  AuthStoreModel({
    required super.docid,
    required super.createdate,
    required super.updatedate,
    required super.tostrdocid,
    required super.tousrdocid,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docid,
      'createdate': createdate.toUtc().toIso8601String(),
      'updatedate': updatedate.toUtc().toIso8601String(),
      'tostrdocid': tostrdocid,
      'tousrdocid': tousrdocid,
    };
  }

  factory AuthStoreModel.fromMap(Map<String, dynamic> map) {
    return AuthStoreModel(
      docid: map['docid'] as String,
      createdate: DateTime.parse(map['createdate'] as String),
      updatedate: DateTime.parse(map['updatedate'] as String),
      tostrdocid: map['tostrdocid'] as String,
      tousrdocid: map['tousrdocid'] as String,
    );
  }

  factory AuthStoreModel.fromEntity(AuthStoreEntity entity) {
    return AuthStoreModel(
      docid: entity.docid,
      createdate: entity.createdate,
      updatedate: entity.updatedate,
      tostrdocid: entity.tostrdocid,
      tousrdocid: entity.tousrdocid,
    );
  }
}
