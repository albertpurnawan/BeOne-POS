// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GenderEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String genderCode;
  final String description;

  GenderEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.genderCode,
    required this.description,
  });

  GenderEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? genderCode,
    String? description,
  }) {
    return GenderEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      genderCode: genderCode ?? this.genderCode,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'genderCode': genderCode,
      'description': description,
    };
  }

  factory GenderEntity.fromMap(Map<String, dynamic> map) {
    return GenderEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      genderCode: map['genderCode'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GenderEntity.fromJson(String source) =>
      GenderEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GenderEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, genderCode: $genderCode, description: $description)';
  }

  @override
  bool operator ==(covariant GenderEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.genderCode == genderCode &&
        other.description == description;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        genderCode.hashCode ^
        description.hashCode;
  }
}
