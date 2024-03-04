// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AuthorizationEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  // final String? tformId;
  final String? tousrId;
  final int authorization;
  final int setBy;
  final int? canView;
  final int? canCreate;
  final int? canUpdate;

  AuthorizationEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    // required this.tformId,
    required this.tousrId,
    required this.authorization,
    required this.setBy,
    required this.canView,
    required this.canCreate,
    required this.canUpdate,
  });

  AuthorizationEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    // String? tformId,
    String? tousrId,
    int? authorization,
    int? setBy,
    int? canView,
    int? canCreate,
    int? canUpdate,
  }) {
    return AuthorizationEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      // tformId: tformId ?? this.tformId,
      tousrId: tousrId ?? this.tousrId,
      authorization: authorization ?? this.authorization,
      setBy: setBy ?? this.setBy,
      canView: canView ?? this.canView,
      canCreate: canCreate ?? this.canCreate,
      canUpdate: canUpdate ?? this.canUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      // 'tformId': tformId,
      'tousrId': tousrId,
      'authorization': authorization,
      'setBy': setBy,
      'canView': canView,
      'canCreate': canCreate,
      'canUpdate': canUpdate,
    };
  }

  factory AuthorizationEntity.fromMap(Map<String, dynamic> map) {
    return AuthorizationEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      // tformId: map['tformId'] != null ? map['tformId'] as String : null,
      tousrId: map['tousrId'] != null ? map['tousrId'] as String : null,
      authorization: map['authorization'] as int,
      setBy: map['setBy'] as int,
      canView: map['canView'] != null ? map['canView'] as int : null,
      canCreate: map['canCreate'] != null ? map['canCreate'] as int : null,
      canUpdate: map['canUpdate'] != null ? map['canUpdate'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthorizationEntity.fromJson(String source) =>
      AuthorizationEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AuthorizationEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tousrId: $tousrId, authorization: $authorization, setBy: $setBy, canView: $canView, canCreate: $canCreate, canUpdate: $canUpdate)';
  }

  @override
  bool operator ==(covariant AuthorizationEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        // other.tformId == tformId &&
        other.tousrId == tousrId &&
        other.authorization == authorization &&
        other.setBy == setBy &&
        other.canView == canView &&
        other.canCreate == canCreate &&
        other.canUpdate == canUpdate;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        // tformId.hashCode ^
        tousrId.hashCode ^
        authorization.hashCode ^
        setBy.hashCode ^
        canView.hashCode ^
        canCreate.hashCode ^
        canUpdate.hashCode;
  }
}
