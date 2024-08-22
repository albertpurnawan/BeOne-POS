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
    dflt,
    discAndRound,
    nonPositiveTrx,
    closeShift,
    resetLocalDb,
    form,
  ];
  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String tostrdocid = "tostrdocid";
  static const String tousrdocid = "tousrdocid";
  static const String statusActive = "statusactive";
  static const String dflt = "dflt";
  static const String discAndRound = "discandround";
  static const String nonPositiveTrx = "nonpositivetrx";
  static const String closeShift = "closeshift";
  static const String resetLocalDb = "resetlocaldb";
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
    required super.dflt,
    required super.discAndRound,
    required super.nonPositiveTrx,
    required super.closeShift,
    required super.resetLocalDb,
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
      'dflt': dflt,
      'discandround': discAndRound,
      'nonpositivetrx': nonPositiveTrx,
      'closeshift': closeShift,
      'resetlocaldb': resetLocalDb,
      'form': form,
    };
  }

  factory AuthStoreModel.fromMap(Map<String, dynamic> map) {
    return AuthStoreModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String),
      updateDate: map['updatedate'] != null ? DateTime.parse(map['updatedate'] as String) : null,
      tostrdocid: map['tostrdocid'] as String,
      tousrdocid: map['tousrdocid'] as String,
      statusActive: map['statusactive'] as int,
      dflt: map['dflt'] != null ? map['dflt'] as int : null,
      discAndRound: map['discandround'] as int,
      nonPositiveTrx: map['nonpositivetrx'] as int,
      closeShift: map['closeshift'] as int,
      resetLocalDb: map['resetlocaldb'] != null ? map['resetlocaldb'] as int : 0,
      form: map['form'] as String,
    );
  }

  factory AuthStoreModel.fromMapRemote(Map<String, dynamic> map) {
    return AuthStoreModel.fromMap({
      ...map,
      "dflt": map['default'] != null ? map['default'] as int : null,
    });
  }

  factory AuthStoreModel.fromEntity(AuthStoreEntity entity) {
    return AuthStoreModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      tostrdocid: entity.tostrdocid,
      tousrdocid: entity.tousrdocid,
      statusActive: entity.statusActive,
      dflt: entity.dflt,
      discAndRound: entity.discAndRound,
      nonPositiveTrx: entity.nonPositiveTrx,
      closeShift: entity.closeShift,
      resetLocalDb: entity.resetLocalDb,
      form: entity.form,
    );
  }
}
