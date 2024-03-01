// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemCategoryEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String catCode;
  final String catName;
  final String catNameFrgn;
  final int? parentId;
  final int level;
  final String? phir1Id;

  ItemCategoryEntity({
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
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? catCode,
    String? catName,
    String? catNameFrgn,
    int? parentId,
    int? level,
    String? phir1Id,
  }) {
    return ItemCategoryEntity(
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
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
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
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      catCode: map['catCode'] as String,
      catName: map['catName'] as String,
      catNameFrgn: map['catNameFrgn'] as String,
      parentId: map['parentId'] != null ? map['parentId'] as int : null,
      level: map['level'] as int,
      phir1Id: map['phir1Id'] != null ? map['phir1Id'] as String : null,
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

    return other.docId == docId &&
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
    return docId.hashCode ^
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
