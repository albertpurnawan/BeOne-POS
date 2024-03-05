// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemPropertyEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String properties;
  final String code;
  final String description;

  ItemPropertyEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.properties,
    required this.code,
    required this.description,
  });

  ItemPropertyEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? properties,
    String? code,
    String? description,
  }) {
    return ItemPropertyEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      properties: properties ?? this.properties,
      code: code ?? this.code,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'properties': properties,
      'code': code,
      'description': description,
    };
  }

  factory ItemPropertyEntity.fromMap(Map<String, dynamic> map) {
    return ItemPropertyEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      properties: map['properties'] as String,
      code: map['code'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemPropertyEntity.fromJson(String source) =>
      ItemPropertyEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemPropertyEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, properties: $properties, code: $code, description: $description)';
  }

  @override
  bool operator ==(covariant ItemPropertyEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.properties == properties &&
        other.code == code &&
        other.description == description;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        properties.hashCode ^
        code.hashCode ^
        description.hashCode;
  }
}
