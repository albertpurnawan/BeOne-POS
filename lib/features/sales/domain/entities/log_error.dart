// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LogErrorEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String processInfo;
  final String description;

  LogErrorEntity({
    required this.docId,
    required this.createDate,
    this.updateDate,
    required this.processInfo,
    required this.description,
  });

  LogErrorEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? processInfo,
    String? description,
  }) {
    return LogErrorEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      processInfo: processInfo ?? this.processInfo,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'processInfo': processInfo,
      'description': description,
    };
  }

  factory LogErrorEntity.fromMap(Map<String, dynamic> map) {
    return LogErrorEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      processInfo: map['processInfo'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LogErrorEntity.fromJson(String source) =>
      LogErrorEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LogErrorEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, processInfo: $processInfo, description: $description)';
  }

  @override
  bool operator ==(covariant LogErrorEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.processInfo == processInfo &&
        other.description == description;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        processInfo.hashCode ^
        description.hashCode;
  }
}
