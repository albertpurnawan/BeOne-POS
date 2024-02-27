// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemCategoryEntity {
  // final int id;
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String catCode;
  final String catName;
  final String catNameFrgn;
  final String? parentId;
  final int level;
  final String? phir1Id;

  ItemCategoryEntity({
    // required this.id,
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.catCode,
    required this.catName,
    required this.catNameFrgn,
    required this.parentId,
    required this.level,
    required this.phir1Id,
  });

  ItemCategoryEntity copyWith({
    // int? id,
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? catCode,
    String? catName,
    String? catNameFrgn,
    String? parentId,
    int? level,
    String? phir1Id,
  }) {
    return ItemCategoryEntity(
      // id: id ?? this.id,
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      catCode: catCode ?? this.catCode,
      catName: catName ?? this.catName,
      catNameFrgn: catNameFrgn ?? this.catNameFrgn,
      parentId: parentId ?? this.parentId,
      level: level ?? this.level,
      phir1Id: phir1Id ?? this.phir1Id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'id': id,
      'docId': docId,
      'createDate': createDate.toIso8601String(),
      'updateDate': updateDate?.toIso8601String(),
      'catCode': catCode,
      'catName': catName,
      'catNameFrgn': catNameFrgn,
      'parentId': parentId,
      'level': level,
      'phir1Id': phir1Id,
    };
  }

  factory ItemCategoryEntity.fromMap(Map<String, dynamic> map) {
    return ItemCategoryEntity(
      // id: map['id'] as int,
      docId: map['docId'] as String,
      createDate: DateTime.parse(map['createDate']),
      updateDate:
          map['updateDate'] != null ? DateTime.parse(map['updateDate']) : null,
      catCode: map['catCode'] as String,
      catName: map['catName'] as String,
      catNameFrgn: map['catNameFrgn'] as String,
      parentId: map['parent_id']['docid'] != null
          ? map['parent_id']['docid'] as String
          : null,
      level: map['level'] as int,
      phir1Id: map['phlir1_id']['docid'] != null
          ? map['phlir1_id']['docid'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemCategoryEntity.fromJson(String source) =>
      ItemCategoryEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemCategoryEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, catCode: $catCode, catName: $catName, catNameFrgn: $catNameFrgn, parentId: $parentId, level: $level, phir1Id: $phir1Id)';
  }

  @override
  bool operator ==(covariant ItemCategoryEntity other) {
    if (identical(this, other)) return true;

    return
        // other.id == id &&
        other.docId == docId &&
            other.createDate == createDate &&
            other.updateDate == updateDate &&
            other.catCode == catCode &&
            other.catName == catName &&
            other.catNameFrgn == catNameFrgn &&
            other.parentId == parentId &&
            other.level == level &&
            other.phir1Id == phir1Id;
  }

  @override
  int get hashCode {
    return
        // id.hashCode ^
        docId.hashCode ^
            createDate.hashCode ^
            updateDate.hashCode ^
            catCode.hashCode ^
            catName.hashCode ^
            catNameFrgn.hashCode ^
            parentId.hashCode ^
            level.hashCode ^
            phir1Id.hashCode;
  }
}
