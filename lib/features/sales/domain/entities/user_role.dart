// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserRoleEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String roleCode;
  final String roleName;
  final int statusActive;
  final int activated;

  UserRoleEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.roleCode,
    required this.roleName,
    required this.statusActive,
    required this.activated,
  });

  UserRoleEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? roleCode,
    String? roleName,
    int? statusActive,
    int? activated,
  }) {
    return UserRoleEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      roleCode: roleCode ?? this.roleCode,
      roleName: roleName ?? this.roleName,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'roleCode': roleCode,
      'roleName': roleName,
      'statusActive': statusActive,
      'activated': activated,
    };
  }

  factory UserRoleEntity.fromMap(Map<String, dynamic> map) {
    return UserRoleEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      roleCode: map['roleCode'] as String,
      roleName: map['roleName'] as String,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRoleEntity.fromJson(String source) =>
      UserRoleEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserRoleEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, roleCode: $roleCode, roleName: $roleName, statusActive: $statusActive, activated: $activated)';
  }

  @override
  bool operator ==(covariant UserRoleEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.roleCode == roleCode &&
        other.roleName == roleName &&
        other.statusActive == statusActive &&
        other.activated == activated;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        roleCode.hashCode ^
        roleName.hashCode ^
        statusActive.hashCode ^
        activated.hashCode;
  }
}
