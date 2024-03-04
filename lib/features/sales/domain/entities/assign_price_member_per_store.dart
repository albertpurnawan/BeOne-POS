// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AssignPriceMemberPerStoreEntity {
  final String docId;
  final DateTime createDate;
  final DateTime? updateDate;
  final String? toplnId;
  final String? tostrId;
  final int statusActive;
  final int activated;

  AssignPriceMemberPerStoreEntity({
    required this.docId,
    required this.createDate,
    required this.updateDate,
    required this.toplnId,
    required this.tostrId,
    required this.statusActive,
    required this.activated,
  });

  AssignPriceMemberPerStoreEntity copyWith({
    String? docId,
    DateTime? createDate,
    DateTime? updateDate,
    String? toplnId,
    String? tostrId,
    int? statusActive,
    int? activated,
  }) {
    return AssignPriceMemberPerStoreEntity(
      docId: docId ?? this.docId,
      createDate: createDate ?? this.createDate,
      updateDate: updateDate ?? this.updateDate,
      toplnId: toplnId ?? this.toplnId,
      tostrId: tostrId ?? this.tostrId,
      statusActive: statusActive ?? this.statusActive,
      activated: activated ?? this.activated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docId': docId,
      'createDate': createDate.millisecondsSinceEpoch,
      'updateDate': updateDate?.millisecondsSinceEpoch,
      'toplnId': toplnId,
      'tostrId': tostrId,
      'statusActive': statusActive,
      'activated': activated,
    };
  }

  factory AssignPriceMemberPerStoreEntity.fromMap(Map<String, dynamic> map) {
    return AssignPriceMemberPerStoreEntity(
      docId: map['docId'] as String,
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate'] as int),
      updateDate: map['updateDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updateDate'] as int)
          : null,
      toplnId: map['toplnId'] != null ? map['toplnId'] as String : null,
      tostrId: map['tostrId'] != null ? map['tostrId'] as String : null,
      statusActive: map['statusActive'] as int,
      activated: map['activated'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AssignPriceMemberPerStoreEntity.fromJson(String source) =>
      AssignPriceMemberPerStoreEntity.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AssignPriceMemberPerStoreEntity(docId: $docId, createDate: $createDate, updateDate: $updateDate, toplnId: $toplnId, tostrId: $tostrId, statusActive: $statusActive, activated: $activated)';
  }

  @override
  bool operator ==(covariant AssignPriceMemberPerStoreEntity other) {
    if (identical(this, other)) return true;

    return other.docId == docId &&
        other.createDate == createDate &&
        other.updateDate == updateDate &&
        other.toplnId == toplnId &&
        other.tostrId == tostrId &&
        other.statusActive == statusActive &&
        other.activated == activated;
  }

  @override
  int get hashCode {
    return docId.hashCode ^
        createDate.hashCode ^
        updateDate.hashCode ^
        toplnId.hashCode ^
        tostrId.hashCode ^
        statusActive.hashCode ^
        activated.hashCode;
  }
}