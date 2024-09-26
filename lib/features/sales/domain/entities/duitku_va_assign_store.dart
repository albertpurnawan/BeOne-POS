// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DuitkuVAAssignStoreEntity {
  final String docId;
  final DateTime? createDate;
  final DateTime? updateDate;
  final String? tovalId;
  final String? tostrId;

  DuitkuVAAssignStoreEntity({
    required this.docId,
    this.createDate,
    this.updateDate,
    this.tovalId,
    this.tostrId,
  });

  DuitkuVAAssignStoreEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? tovalId,
    String? tostrId,
  }) {
    return DuitkuVAAssignStoreEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      tovalId: tovalId ?? this.tovalId,
      tostrId: tostrId ?? this.tostrId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate?.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'tovalId': tovalId,
      'tostrId': tostrId,
    };
  }

  factory DuitkuVAAssignStoreEntity.fromMap(Map<String, dynamic> map) {
    return DuitkuVAAssignStoreEntity(
      docId: map['docId'] as String,
      createDate: map['createDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int) : null,
      updateDate: map['updateDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int) : null,
      tovalId: map['tovalId'] != null ? map['tovalId'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DuitkuVAAssignStoreEntity.fromJson(String source) =>
      DuitkuVAAssignStoreEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DuitkuVAAssignStoreEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, tovalId: $tovalId, tostrId: $tostrId)';
  }

  @override
  bool operator ==(covariant DuitkuVAAssignStoreEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.tovalId == tovalId &&
        other.tostrId == tostrId;
  }

  @override
  int get hashCode {
    return docId.hashCode ^ createDate.hashCode ^ updateDate.hashCode ^ tovalId.hashCode ^ tostrId.hashCode;
  }
}
