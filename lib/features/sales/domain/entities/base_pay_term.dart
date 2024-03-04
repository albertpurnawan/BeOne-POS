// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BasePayTermEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String baseCode;
  final String description;

  BasePayTermEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.baseCode,
    required this.description,
  });

  BasePayTermEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? baseCode,
    String? description,
  }) {
    return BasePayTermEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      baseCode: baseCode ?? this.baseCode,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'baseCode': baseCode,
      'description': description,
    };
  }

  factory BasePayTermEntity.fromMap(Map<String, dynamic> map) {
    return BasePayTermEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      baseCode: map['baseCode'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BasePayTermEntity.fromJson(String source) =>
      BasePayTermEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BasePayTermEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, baseCode: $baseCode, description: $description)';
  }

  @override
  bool operator ==(covariant BasePayTermEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.baseCode == baseCode &&
        other.description == description;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        baseCode.hashCode ^
        description.hashCode;
  }
}
