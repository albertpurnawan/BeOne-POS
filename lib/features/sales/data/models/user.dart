import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/user.dart';

const String tableUser = "tousr";

class UserFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    email,
    username,
    password,
    tohemId,
    torolId,
    statusActive,
    activated,
    superUser,
    userType,
    tostrId,
    form,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String email = "email";
  static const String username = "username";
  static const String password = "password";
  static const String tohemId = "tohemId";
  static const String torolId = "torolId";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
  static const String superUser = "superuser";
  static const String userType = "usertype";
  static const String tostrId = "tostrId";
  static const String form = "form";
}

class UserModel extends UserEntity implements BaseModel {
  UserModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.email,
    required super.username,
    required super.password,
    required super.tohemId,
    required super.torolId,
    required super.statusActive,
    required super.activated,
    required super.superUser,
    required super.userType,
    required super.tostrId,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'email': email,
      'username': username,
      'password': password,
      'tohemId': tohemId,
      'torolId': torolId,
      'statusactive': statusActive,
      'activated': activated,
      'superuser': superUser,
      'usertype': userType,
      'tostrId': tostrId,
      'form': form,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      email: map['email'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
      tohemId: map['tohemId'] != null ? map['tohemId'] as String : null,
      torolId: map['torolId'] != null ? map['torolId'] as String : null,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      superUser: map['superuser'] as int,
      userType: map['usertype'] != null ? map['usertype'] as int : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      form: map['form'] as String,
    );
  }

  factory UserModel.fromMapRemote(Map<String, dynamic> map) {
    return UserModel.fromMap({
      ...map,
      "tohemId": map['tohemdocid'] != null ? map['tohemdocid'] as String : null,
      "torolId": map['toroldocid'] != null ? map['toroldocid'] as String : null,
      "tostrId": map['tostrdocid'] != null ? map['tostrdocid'] as String : null,
    });
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      email: entity.email,
      username: entity.username,
      password: entity.password,
      tohemId: entity.tohemId,
      torolId: entity.torolId,
      statusActive: entity.statusActive,
      activated: entity.activated,
      superUser: entity.superUser,
      userType: entity.userType,
      tostrId: entity.tostrId,
      form: entity.form,
    );
  }
}
