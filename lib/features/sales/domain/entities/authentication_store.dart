// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AuthStoreEntity {
  final String docid;
  final DateTime createdate;
  final DateTime updatedate;
  final String tostrdocid;
  final String tousrdocid;

  AuthStoreEntity({
    required this.docid,
    required this.createdate,
    required this.updatedate,
    required this.tostrdocid,
    required this.tousrdocid,
  });

  AuthStoreEntity copyWith({
    String? docid,
    DateTime? createdate,
    DateTime? updatedate,
    String? tostrdocid,
    String? tousrdocid,
  }) {
    return AuthStoreEntity(
      docid: docid ?? this.docid,
      createdate: createdate ?? this.createdate,
      updatedate: updatedate ?? this.updatedate,
      tostrdocid: tostrdocid ?? this.tostrdocid,
      tousrdocid: tousrdocid ?? this.tousrdocid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docid,
      'createdate': createdate.millisecondsSinceEpoch,
      'updatedate': updatedate.millisecondsSinceEpoch,
      'tostrdocid': tostrdocid,
      'tousrdocid': tousrdocid,
    };
  }

  factory AuthStoreEntity.fromMap(Map<String, dynamic> map) {
    return AuthStoreEntity(
      docid: map['docid'] as String,
      createdate: DateTime.fromMillisecondsSinceEpoch(map['createdate'] as int),
      updatedate: DateTime.fromMillisecondsSinceEpoch(map['updatedate'] as int),
      tostrdocid: map['tostrdocid'] as String,
      tousrdocid: map['tousrdocid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthStoreEntity.fromJson(String source) =>
      AuthStoreEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AuthStoreEntity(docid: $docid, createdate: $createdate, updatedate: $updatedate, tostrdocid: $tostrdocid, tousrdocid: $tousrdocid)';
  }

  @override
  bool operator ==(covariant AuthStoreEntity other) {
    if (identical(this, other)) return true;

    return other.docid == docid &&
        other.createdate == createdate &&
        other.updatedate == updatedate &&
        other.tostrdocid == tostrdocid &&
        other.tousrdocid == tousrdocid;
  }

  @override
  int get hashCode {
    return docid.hashCode ^
        createdate.hashCode ^
        updatedate.hashCode ^
        tostrdocid.hashCode ^
        tousrdocid.hashCode;
  }
}
