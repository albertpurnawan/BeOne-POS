// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ItemPictureEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toitmId;
  final dynamic picture;
  final String? path;

  ItemPictureEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toitmId,
    required this.picture,
    required this.path,
  });

  ItemPictureEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toitmId,
    dynamic picture,
    String? path,
  }) {
    return ItemPictureEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toitmId: toitmId ?? this.toitmId,
      picture: picture ?? this.picture,
      path: path ?? this.path,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toitmId': toitmId,
      'picture': picture,
      'path': path,
    };
  }

  factory ItemPictureEntity.fromMap(Map<String, dynamic> map) {
    return ItemPictureEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toitmId: map['toitmId'] != null ? map['toitmId'] as String : null,
      picture: map['picture'] as dynamic,
      path: map['path'] != null ? map['path'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemPictureEntity.fromJson(String source) =>
      ItemPictureEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemPictureEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toitmId: $toitmId, picture: $picture, path: $path)';
  }

  @override
  bool operator ==(covariant ItemPictureEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toitmId == toitmId &&
        other.picture == picture &&
        other.path == path;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toitmId.hashCode ^
        picture.hashCode ^
        path.hashCode;
  }
}
