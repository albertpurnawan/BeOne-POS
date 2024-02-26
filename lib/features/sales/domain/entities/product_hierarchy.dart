// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductHierarchyEntity {
  final int id;
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String description;
  final int level;
  final int maxChar;

  ProductHierarchyEntity({
    required this.id,
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.description,
    required this.level,
    required this.maxChar,
  });

  ProductHierarchyEntity copyWith({
    int? id,
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? description,
    int? level,
    int? maxChar,
  }) {
    return ProductHierarchyEntity(
      id: id ?? this.id,
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      description: description ?? this.description,
      level: level ?? this.level,
      maxChar: maxChar ?? this.maxChar,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'description': description,
      'level': level,
      'maxChar': maxChar,
    };
  }

  factory ProductHierarchyEntity.fromMap(Map<String, dynamic> map) {
    return ProductHierarchyEntity(
      id: map['id'] as int,
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      description: map['description'] as String,
      level: map['level'] as int,
      maxChar: map['maxChar'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductHierarchyEntity.fromJson(String source) =>
      ProductHierarchyEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductHierarchyEntity(id: $id, docId: $docId, createDate: $createDate, updateDate: $updateDate, description: $description, level: $level, maxChar: $maxChar)';
  }

  @override
  bool operator ==(covariant ProductHierarchyEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.description == description &&
        other.level == level &&
        other.maxChar == maxChar;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        description.hashCode ^
        level.hashCode ^
        maxChar.hashCode;
  }
}
