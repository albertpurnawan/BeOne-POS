// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserLogsEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? remarks;

  UserLogsEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.remarks,
  });

  UserLogsEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? remarks,
  }) {
    return UserLogsEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      remarks: remarks ?? this.remarks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'remarks': remarks,
    };
  }

  factory UserLogsEntity.fromMap(Map<String, dynamic> map) {
    return UserLogsEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      remarks: map['remarks'] != null ? map['remarks'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLogsEntity.fromJson(String source) =>
      UserLogsEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserLogsEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, remarks: $remarks)';
  }

  @override
  bool operator ==(covariant UserLogsEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.remarks == remarks;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        remarks.hashCode;
  }
}
