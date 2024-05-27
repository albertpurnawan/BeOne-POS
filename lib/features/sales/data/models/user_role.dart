import 'package:pos_fe/core/resources/base_model.dart';
import 'package:pos_fe/features/sales/domain/entities/user_role.dart';

const String tableUserRole = "torol";

class UserRoleFields {
  static const List<String> values = [
    docId,
    createDate,
    updateDate,
    roleCode,
    roleName,
    statusActive,
    activated,
    form,
  ];

  static const String docId = "docid";
  static const String createDate = "createdate";
  static const String updateDate = "updatedate";
  static const String roleCode = "rolecode";
  static const String roleName = "rolename";
  static const String statusActive = "statusactive";
  static const String activated = "activated";
  static const String form = "form";
}

class UserRoleModel extends UserRoleEntity implements BaseModel {
  UserRoleModel({
    required super.docId,
    required super.createDate,
    required super.updateDate,
    required super.roleCode,
    required super.roleName,
    required super.statusActive,
    required super.activated,
    required super.form,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docId,
      'createdate': createDate.toUtc().toIso8601String(),
      'updatedate': updateDate?.toUtc().toIso8601String(),
      'rolecode': roleCode,
      'rolename': roleName,
      'statusactive': statusActive,
      'activated': activated,
      'form': form,
    };
  }

  factory UserRoleModel.fromMap(Map<String, dynamic> map) {
    return UserRoleModel(
      docId: map['docid'] as String,
      createDate: DateTime.parse(map['createdate'] as String).toLocal(),
      updateDate: map['updatedate'] != null
          ? DateTime.parse(map['updatedate'] as String).toLocal()
          : null,
      roleCode: map['rolecode'] as String,
      roleName: map['rolename'] as String,
      statusActive: map['statusactive'] as int,
      activated: map['activated'] as int,
      form: map['form'] as String,
    );
  }

  factory UserRoleModel.fromEntity(UserRoleEntity entity) {
    return UserRoleModel(
      docId: entity.docId,
      createDate: entity.createDate,
      updateDate: entity.updateDate,
      roleCode: entity.roleCode,
      roleName: entity.roleName,
      statusActive: entity.statusActive,
      activated: entity.activated,
      form: entity.form,
    );
  }
}
