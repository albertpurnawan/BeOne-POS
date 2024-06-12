import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/authentication_store.dart';

const String tableAuthStore = "tastr";

class AuthStoreFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    tostrdocid,
    tousrdocid,
    statusActive,
    form,
  ];
  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tostrdocid = "tostrdocid";
  static const String tousrdocid = "tousrdocid";
  static const String statusActive = "statusactive";
  static const String form = "form";
}

class AuthStoreModel extends AuthStoreEntity implements BaseModel {
  AuthStoreModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.tostrdocid,
    required super.tousrdocid,
    required super.statusActive,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'tostrdocid': tostrdocid,
      'tousrdocid': tousrdocid,
      'statusactive': statusActive,
      'form': form,
    };
  }

  factory AuthStoreModel.fromMap(Map<String, dynamic> map) {
    return AuthStoreModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String)
          : null,
      tostrdocid: map['tostrdocid'] as String,
      tousrdocid: map['tousrdocid'] as String,
      statusActive: map['statusactive'] as int,
      form: map['form'] as String,
    );
  }

  factory AuthStoreModel.fromEntity(AuthStoreEntity entity) {
    return AuthStoreModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tostrdocid: entity.tostrdocid,
      tousrdocid: entity.tousrdocid,
      statusActive: entity.statusActive,
      form: entity.form,
    );
  }
}