// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductHierarchyMasterEntity {
  final int id;
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String code;
  final String description;
  final int? tphirId;

  ProductHierarchyMasterEntity({
    required this.id,
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.code,
    required this.description,
    required this.tphirId,
  });

  ProductHierarchyMasterEntity copyWith({
    int? id,
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? code,
    String? description,
    int? tphirId,
  }) {
    return ProductHierarchyMasterEntity(
      id: id ?? this.id,
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      code: code ?? this.code,
      description: description ?? this.description,
      tphirId: tphirId ?? this.tphirId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'code': code,
      'description': description,
      'tphirId': tphirId,
    };
  }

  factory ProductHierarchyMasterEntity.fromMap(Map<String, dynamic> map) {
    return ProductHierarchyMasterEntity(
      id: map['id'] as int,
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      code: map['code'] as String,
      description: map['description'] as String,
      tphirId: map['tphirId'] != null ? map['tphirId'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductHierarchyMasterEntity.fromJson(String source) =>
      ProductHierarchyMasterEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductHierarchyMasterEntity(id: $id, docId: $docId, createDate: $createDate, updateDate: $updateDate, code: $code, description: $description, tphirId: $tphirId)';
  }

  @override
  bool operator ==(covariant ProductHierarchyMasterEntity other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.code == code &&
        other.description == description &&
        other.tphirId == tphirId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        code.hashCode ^
        description.hashCode ^
        tphirId.hashCode;
  }
}
